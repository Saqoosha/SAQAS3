package sh.saqoo.audio {

	import sh.saqoo.util.EnterFrameBeacon;

	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Saqoosha
	 */
	public class WAVEncoder {


		public static function encode(soundData:ByteArray):ByteArray {
			var fmt:ByteArray = _createFmtChunk();
			var data:ByteArray = _createDataChunk(soundData);
			var wav:ByteArray = new ByteArray();
			wav.endian = Endian.LITTLE_ENDIAN;
			wav.writeUTFBytes('RIFF');
			wav.writeInt(fmt.length + data.length);
			wav.writeUTFBytes('WAVE');
			wav.writeBytes(fmt);
			wav.writeBytes(data);
			wav.position = 0;
			return wav;
		}


		private static function _createFmtChunk():ByteArray {
			var fmt:ByteArray = new ByteArray();
			fmt.endian = Endian.LITTLE_ENDIAN;
			fmt.writeUTFBytes('fmt ');
			fmt.writeInt(16); // chunk size in bytes
			fmt.writeShort(1); // PCM
			fmt.writeShort(2); // Stereo
			fmt.writeInt(44100); // 44.1KHz
			fmt.writeInt(44100 * 2 * 2); // bytes / sec
			fmt.writeShort(2 * 2); // bytes / sample * channels
			fmt.writeShort(16); // bits / sample
			fmt.position = 0;
			return fmt;
		}


		private static function _createDataChunk(soundData:ByteArray):ByteArray {
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeUTFBytes('data');
			var numSamples:int = soundData.length / 4;
			data.writeInt(numSamples * 2);
			soundData.position = 0;
			for (var i:int = 0; i < numSamples;++i) {
				var val:Number = soundData.readFloat() * 32768;
				val = val > 32767 ? 32767 : val < -32768 ? -32768 : val;
				data.writeShort(val);
			}
			data.position = 0;
			return data;
		}

		
		public static function encodeAsync(soundData:ByteArray, onComplete:Function):void {
			_createDataChunkAsync(soundData, function (data:ByteArray):void {
				var fmt:ByteArray = _createFmtChunk();
				var wav:ByteArray = new ByteArray();
				wav.endian = Endian.LITTLE_ENDIAN;
				wav.writeUTFBytes('RIFF');
				wav.writeInt(fmt.length + data.length);
				wav.writeUTFBytes('WAVE');
				wav.writeBytes(fmt);
				wav.writeBytes(data);
				wav.position = 0;
				onComplete(wav);
			});
		}


		public static var NUM_SAMPLES_PER_FRAME:int = 1024 * 10;

		private static function _createDataChunkAsync(soundData:ByteArray, onComplete:Function):void {
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data.writeUTFBytes('data');
			var numSamples:int = soundData.length / 4;
			data.writeInt(numSamples * 2);
			soundData.position = 0;
			var i:int = 0;
			var n:int = Math.min(NUM_SAMPLES_PER_FRAME, numSamples);
			EnterFrameBeacon.add(function (e:Event):void {
				for (; i < n; ++i) {
					var val:Number = soundData.readFloat() * 32768;
					val = val > 32767 ? 32767 : val < -32768 ? -32768 : val;
					data.writeShort(val);
				}
				if (i == numSamples) {
					EnterFrameBeacon.remove(arguments.callee);
					data.position = 0;
					onComplete(data);
				} else {
					n = Math.min(n + NUM_SAMPLES_PER_FRAME, numSamples);
				}
			});
		}
	}
}
