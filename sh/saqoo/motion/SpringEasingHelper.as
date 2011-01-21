package sh.saqoo.motion {

	public class SpringEasingHelper extends EasingHelper {

		private var _velocity:Number;
		private var _decay:Number;

		public function SpringEasingHelper(inival:Number, factor:Number = 20, decay:Number = 0.8) {
			super(inival, factor);
			_velocity = 0;
			_decay = decay;
		}

		public override function update(newVal:Number = NaN):void {
			if (!isNaN(newVal)) {
				target = newVal;
			}
			_velocity += (_target - _current) * _factor;
			_current += _velocity;
			_velocity *= _decay;
		}

		public override function reset():void {
			_current = _target;
			_velocity = 0;
		}

		public function get velocity():Number {
			return _velocity;
		}

		public function get decay():Number {
			return _decay;
		}

		public function set decay(newVal:Number):void {
			_decay = newVal;
		}

		public override function toString():String {
			return '[SpringEasingHelper: current=' + _current + ', factor=' + _factor + ']';
		}
	}
}
