package sh.saqoo.signal {

	import org.osflash.signals.natives.NativeMappedSignal;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Saqoosha
	 */
	public class SigTimer extends Timer {


		private var _sigTimer:NativeMappedSignal;
		private var _sigComplete:NativeMappedSignal;


		public function SigTimer(delay:Number, repeatCount:int = 0) {
			super(delay, repeatCount);
		}


		public function get sigTimer():NativeMappedSignal {
			return _sigTimer ||= new NativeMappedSignal(this, TimerEvent.TIMER);
		}


		public function get sigComplete():NativeMappedSignal {
			return _sigComplete ||= new NativeMappedSignal(this, TimerEvent.TIMER_COMPLETE);
		}
	}
}
