package net.saqoosha.util {
	import org.osflash.signals.natives.NativeRelaySignal;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	
	/**
	 * @author Saqoosha
	 */
	public class SigTimer extends Timer {

		
		private var _sigTimer:NativeRelaySignal;
		private var _sigComplete:NativeRelaySignal;

		
		public function SigTimer(delay:Number, repeatCount:int = 0) {
			super(delay, repeatCount);
		}
		
		
		public function get sigTimer():NativeRelaySignal {
			return _sigTimer ||= new NativeRelaySignal(this, TimerEvent.TIMER);
		}
		
		
		public function get sigComplete():NativeRelaySignal {
			return _sigComplete ||= new NativeRelaySignal(this, TimerEvent.TIMER_COMPLETE);
		}
	}
}
