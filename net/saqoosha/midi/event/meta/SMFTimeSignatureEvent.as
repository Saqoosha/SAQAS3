package net.saqoosha.midi.event.meta {
	import net.saqoosha.midi.event.SMFMetaEvent;

	/**
	 * @author hiko
	 */
	public class SMFTimeSignatureEvent extends SMFMetaEvent {

		
		private var _n:int;
		private var _d:int;
		private var _c:int;
		private var _b:int;
		
		
		public function SMFTimeSignatureEvent(deltaTime:int, n:int = 0, d:int = 0, c:int = 0, b:int = 0) {
			super(deltaTime, SMFMetaEvent.TYPE_TIME_SIGNATURE);
			_n = n;
			_d = d;
			_c = c;
			_b = b;
		}
		
		
		public function get n():int {
			return _n;
		}
		
		
		public function set n(value:int):void {
			_n = value;
		}
		
		
		public function get d():int {
			return _d;
		}
		
		
		public function set d(value:int):void {
			_d = value;
		}
		
		
		public function get c():int {
			return _c;
		}
		
		
		public function set c(value:int):void {
			_c = value;
		}
		
		
		public function get b():int {
			return _b;
		}
		
		
		public function set b(value:int):void {
			_b = value;
		}
		
		
		public override function toString():String {
			return '[SMFTimeSignatureEvent delta=' + deltaTime + ' n=' + _n + ' d=' + _d + ' c=' + _c + ' b=' + _b + ']';
		}
	}
}
