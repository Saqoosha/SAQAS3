package sh.saqoo.util {
	import flash.media.Sound;
	import flash.utils.ByteArray;

	
	/**
	 * @author Saqoosha
	 */
	public class SoundUtil {
		
		
		/**
		 * @param sound Sound instance to extract.
		 * @param numSamples Number of samples.
		 * @param startPosition Start position in milliseconds.
		 * @param outData ByteArray to copy to. If not specified, allocated inside this method and returned.
		 */
		public static function extractLoop(sound:Sound, numSamples:int, startPosition:Number, outData:ByteArray = null):ByteArray {
			outData ||= new ByteArray();
			var n:int = sound.extract(outData, numSamples, startPosition);
			if (numSamples - n > 0) {
				sound.extract(outData, numSamples - n, 0);
			}
			return outData;
		}
		
		
		/**
		 * @param soundData Sound data represented by ByteArray.
		 * @param numSamples Number of samples to copy.
		 * @param startPosition Start position in samples.
		 * @param outData ByteArray to copy to. If not specified, allocated inside this method and returned.
		 */
		public static function copyLoopBytes(soundData:ByteArray, numSamples:int, startPosition:int, outData:ByteArray = null):ByteArray {
			outData ||= new ByteArray();
			var require:int = numSamples << 3;
			var available:int = soundData.length - (soundData.position << 3);
			available &= 0x7ffffff8;
			if (require <= available) {
				outData.writeBytes(soundData, startPosition << 3, require);
			} else {
				outData.writeBytes(soundData, startPosition << 3, available);
				outData.writeBytes(soundData, 0, require - available);
			}
			return outData;
		}
	}
}
