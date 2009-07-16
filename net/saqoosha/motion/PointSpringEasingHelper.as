package net.saqoosha.motion {
	
	import flash.geom.Point;
	
	public class PointSpringEasingHelper {
		
		private var _easeX:SpringEasingHelper;
		private var _easeY:SpringEasingHelper;
		
		public function PointSpringEasingHelper(inix:Number, iniy:Number, factor:Number = 20, decay:Number = 0.8) {
			this._easeX = new SpringEasingHelper(inix, factor, decay);
			this._easeY = new SpringEasingHelper(iniy, factor, decay);
		}
		
		public function update(newx:Number, newy:Number):void {
			this._easeX.update(newx);
			this._easeY.update(newy);
		}
		
		public function get currentX():Number {
			return this._easeX.current;
		}
		
		public function get currentY():Number {
			return this._easeY.current;
		}
		
		public function get current():Point {
			return new Point(this._easeX.current, this._easeY.current);
		}
		
		public function get factor():Number {
			return this._easeX.factor;
		}
		
		public function set factor(newVal:Number):void {
			this._easeX.factor = newVal;
			this._easeY.factor = newVal;
		}
		
		public function get decay():Number {
			return this._easeX.decay;
		}
		
		public function set decay(newVal:Number):void {
			this._easeX.decay = newVal;
			this._easeY.decay = newVal;
		}
		
		public function toString():String {
			return '[PointSpringEasingHelper: current=' + this.current + ', factor=' + this.factor + ', decay=' + this.decay + ']';
		}

	}
	
}