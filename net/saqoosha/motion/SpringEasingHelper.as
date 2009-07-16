package net.saqoosha.motion {

	public class SpringEasingHelper extends EasingHelper {

		private var _velocity:Number;
		private var _decay:Number;

		public function SpringEasingHelper(inival:Number, factor:Number = 20, decay:Number = 0.8) {
			super(inival, factor);
			this._velocity = 0;
			this._decay = decay;
		}

		public override function update(newVal:Number = NaN):void {
			if (!isNaN(newVal)) {
				this.target = newVal;
			}
			this._velocity += (this._target - this._current) * this._factor;
			this._current += this._velocity;
			this._velocity *= this._decay;
		}
		
		public function get velocity():Number {
			return this._velocity;
		}

		public function get decay():Number {
			return this._decay;
		}

		public function set decay(newVal:Number):void {
			this._decay = newVal;
		}

		public override function toString():String {
			return '[SpringEasingHelper: current=' + this._current + ', factor=' + this._factor + ']';
		}
	}
}