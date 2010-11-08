package net.saqoosha.youtube {
	import flash.events.Event;

	
	/**
	 * @author Saqoosha
	 */
	public class YouTubePlayerEvent extends Event {
		
		
		public static const READY:String = 'onReady';
		public static const STATE_CHANGE:String = 'onStateChange';
		public static const PLAYBACK_QUALITY_CHANGE:String = 'onPlaybackQualityChange';
		public static const ERROR:String = 'onError';
		
		
		public var state:int;
		public var quality:String;
		public var errorCode:int;

		
		public function YouTubePlayerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
