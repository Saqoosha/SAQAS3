package net.saqoosha.motion {

	public class EasingHelper {

		protected var _target:Number;
		protected var _current:Number;
		protected var _factor:Number;

		public function EasingHelper(inival:Number, factor:Number = 20) {
			this.target = inival;
			this.current = inival;
			this.factor = factor;
		}

		public function update(newVal:Number = NaN):void {
			if (!isNaN(newVal)) {
				target = newVal;
			}
			_current += (_target - _current) * _factor;
		}

		public function reset():void {
			_current = _target;
		}

		public function get target():Number {
			return _target;
		}

		public function set target(newVal:Number):void {
			_target = newVal;
		}

		public function get current():Number {
			return _current;
		}

		public function set current(newVal:Number):void {
			_current = newVal;
		}

		public function get factor():Number {
			return 1 / _factor;
		}

		public function set factor(newVal:Number):void {
			_factor = 1 / newVal;
		}

		public function toString():String {
			return '[EasingHelper: current=' + _current + ', factor=' + _factor + ']';
		}

	}

}
