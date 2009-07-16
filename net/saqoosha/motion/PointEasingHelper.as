package net.saqoosha.motion {
	
	import flash.geom.Point;
	
	public class PointEasingHelper {
		
		private var _easeX:EasingHelper;
		private var _easeY:EasingHelper;
		
		public function PointEasingHelper(inix:Number, iniy:Number, factor:Number = 20) {
			this._easeX = new EasingHelper(inix, factor);
			this._easeY = new EasingHelper(iniy, factor);
		}
		
		public function update(newx:Number = NaN, newy:Number = NaN):void {
			this._easeX.update(newx);
			this._easeY.update(newy);
		}
		
		public function get currentX():Number {
			return this._easeX.current;
		}
		
		public function set currentX(value:Number):void {
			this._easeX.current = value;
		}
		
		public function get currentY():Number {
			return this._easeY.current;
		}
		
		public function set currentY(value:Number):void {
			this._easeY.current = value;
		}
		
		public function get current():Point {
			return new Point(this._easeX.current, this._easeY.current);
		}
		
		public function get targetX():Number {
			return this._easeX.target;
		}
		
		public function set targetX(value:Number):void {
			this._easeX.target = value;
		}
		
		public function get targetY():Number {
			return this._easeY.target;
		}
		
		public function set targetY(value:Number):void {
			this._easeY.target = value;
		}
		
		public function get factor():Number {
			return this._easeX.factor;
		}
		
		public function set factor(newVal:Number):void {
			this._easeX.factor = newVal;
			this._easeY.factor = newVal;
		}
		
		public function toString():String {
			return '[PointEasingHelper: current=' + this.current + ', factor=' + this.factor + ']';
		}

	}
	
}