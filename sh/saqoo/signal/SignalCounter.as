package sh.saqoo.signal {

	import org.osflash.signals.Signal;

	/**
	 * @author Saqoosha
	 */
	public class SignalCounter extends Signal {
		
		
		public var count:int;


		public function SignalCounter(count:uint = 1) {
			this.count = count;
		}
		
		
		public function addSignal(signal:Signal):void {
			signal.addOnce(_onSignal);
		}


		private function _onSignal():void {
			if (--count == 0) dispatch();
		}
	}
}
