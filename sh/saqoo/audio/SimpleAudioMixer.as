package sh.saqoo.audio {
	import flash.display.Shader;
	import flash.display.ShaderInput;
	import flash.display.ShaderJob;
	import flash.utils.ByteArray;

	
	/**
	 * @author Saqoosha
	 */
	public class SimpleAudioMixer {
		
		
		public static const MAX_TRACKS:int = 8;
		
		
		[Embed(source='SimpleAudioMixer.pbj', mimeType='application/octet-stream')]
		private static var MixerShaderDataClass:Class;
		
		private static var _mixer:Shader;
		private static var _dummy:ByteArray;
		
		
		public static function mix(out:ByteArray, numSamples:int, tracks:Array):ByteArray {
			if (!_mixer) {
				_mixer = new Shader(new MixerShaderDataClass() as ByteArray);
				_dummy = new ByteArray();
				_dummy.length = 16; // 1px
			}
			
			var datalen:int = numSamples * 8;
			var channels:int = 4;
			var width:int = 256;
			var widthBytes:int = width * 1 * channels * 4;
			var height:int = Math.ceil(datalen / widthBytes);
			datalen = width * height * channels * 4;
			
			var numTracks:int = Math.min(MAX_TRACKS, tracks.length);
			_mixer.data.numTracks.value = [numTracks];
			
			for (var i:int; i < numTracks;++i) {
				var track:ByteArray = tracks[i];
				var input:ShaderInput = _mixer.data['audio' + i];
				input.input = track;
				input.width = width;
				input.height = height;
				track.length = Math.max(datalen, track.length);
			}
			
			for (; i < MAX_TRACKS; ++i) {
				input = _mixer.data['audio' + i];
				input.input = _dummy;
				input.width = 1;
				input.height = 1;
			}
			
			
			out ||= new ByteArray();
			var job:ShaderJob = new ShaderJob(_mixer, out, width, height);
			job.start(true);
			
			out.length = numSamples * 8;
			return out;
		}
	}
}
