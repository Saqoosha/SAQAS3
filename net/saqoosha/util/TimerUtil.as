package net.saqoosha.util {
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimerUtil {
		
		public static function setTimer(callback:Function, msecs:uint):void {
			var timer:Timer = new Timer(msecs, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, callback, false, 0, true);
			timer.start();
		}

	}
	
}