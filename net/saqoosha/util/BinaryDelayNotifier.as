package net.saqoosha.util {
	
	import flash.events.Event;
	
	public class BinaryDelayNotifier extends DelayNotifier {
		
		private var _false2true:int;
		private var _true2false:int;
		
		public function BinaryDelayNotifier(init:Boolean, falseToTrueDelay:Number, trueToFalseDelay:Number) {
			super(init ? trueToFalseDelay : falseToTrueDelay, init);
			_false2true = falseToTrueDelay;
			_true2false = trueToFalseDelay;
			addEventListener(Event.CHANGE, _onChange, false, int.MAX_VALUE, false);
		}
		
		private function _onChange(e:Event):void {
			delay = value ? _true2false : _false2true;
		}
		
		public function get trueToFalseDelay():Number {
			return _true2false;
		}
		
		public function set trueToFalseDelay(value:Number):void {
			_true2false = value;
		}
		
		public function get falseToTrueDelay():Number {
			return _false2true;
		}
		
		public function set falseToTrueDelay(value:Number):void {
			_false2true = value;
		}
	}
}
