package net.saqoosha.audio {

	
	/**
	 * @author Saqoosha
	 */
	public class MixInfo {
		
		
		public var sound:*;
		public var startTime:Number = 0;
		public var inPoint:Number = 0;
		public var duration:Number = 0;
		public var fadeInTime:Number = 0;
		public var fadeOutTime:Number = 0;
		
		
		/**
		 * @param sound Sound or ByteArray.
		 * @param startTime Sound start time in milliseconds.
		 * @param inPosition Sound start position in milliseconds.
		 * @param duration Sound duration in milliseconds.
		 */
		public function MixInfo(sound:*, startTime:Number = 0, inPoint:Number = 0, duration:Number = 0, fadeInTime:Number = 0, fadeOutTime:Number = 0) {
			this.sound = sound;
			this.startTime = startTime;
			this.inPoint = inPoint;
			this.duration = duration;
			this.fadeInTime = fadeInTime;
			this.fadeOutTime = fadeOutTime;
		}

		
		public function toString():String {
			return '[MixInfo startTime=' + startTime + ' inPoint=' + inPoint + ' duration=' + duration + ' fadeInTime=' + fadeInTime + ' fadeOutTime=' + fadeOutTime + ']';
		}
	}
}
