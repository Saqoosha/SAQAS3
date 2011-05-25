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
			switch (signal.valueClasses.length) {
				case 0: signal.addOnce(_onSignal0); break;
				case 1: signal.addOnce(_onSignal1); break;
				case 2: signal.addOnce(_onSignal2); break;
				case 3: signal.addOnce(_onSignal3); break;
				default: throw new Error();
			}
		}


		private function _onSignal0():void {
			if (--count == 0) dispatch();
		}


		private function _onSignal1(arg0:*):void {
			if (--count == 0) dispatch();
		}


		private function _onSignal2(arg0:*, arg1:*):void {
			if (--count == 0) dispatch();
		}


		private function _onSignal3(arg0:*, arg1:*, arg2:*):void {
			if (--count == 0) dispatch();
		}
	}
}
