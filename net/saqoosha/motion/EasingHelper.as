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
				this.target = newVal;
			}
			this._current += (this._target - this._current) * this._factor;
		}
		
		public function get target():Number {
			return this._target;
		}
		
		public function set target(newVal:Number):void {
			this._target = newVal;
		}
		
		public function get current():Number {
			return this._current;
		}
		
		public function set current(newVal:Number):void {
			this._current = newVal;
		}
		
		public function get factor():Number {
			return 1 / this._factor;
		}
		
		public function set factor(newVal:Number):void {
			this._factor = 1 / newVal;
		}
		
		public function toString():String {
			return '[EasingHelper: current=' + this._current + ', factor=' + this._factor + ']';
		}

	}
	
}