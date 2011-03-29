package sh.saqoo.audio {

	import flash.display.Shader;
	import flash.display.ShaderInput;
	import flash.display.ShaderJob;
	import flash.utils.ByteArray;

	/**
	 * @author Saqoosha
	 */
	public class SimpleAudioMixer {


		public static const MAX_TRACKS:int = 14;
		
		[Embed(source='SimpleAudioMixer.pbj', mimeType='application/octet-stream')]
		private static var MixerShaderDataClass:Class;
		
		private static var _mixer:Shader;
		private static var _dummy:ByteArray;


		/**
		 * Mixdown multitrack sounds by ShaderJob. (at least 2x faster than AS3 only ver.)
		 */
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


		/**
		 * AS3 only multitrack mixdown implementation. (slow...)
		 */
		public static function mix0(out:ByteArray, numSamples:int, tracks:Array):ByteArray {
			out ||= new ByteArray();

			for each (var data:ByteArray in tracks) {
				data.position = 0;
			}

			var n:int = numSamples * 2;
			var m:int = tracks.length;
			var val:Number;
			for (var i:int = 0; i < n; i++) {
				val = 0;
				for (var j:int = 0; j < m; j++) {
					val += tracks[j].readFloat();
				}
				out.writeFloat(val);
			}

			out.length = numSamples * 8;
			return out;
		}
	}
}
