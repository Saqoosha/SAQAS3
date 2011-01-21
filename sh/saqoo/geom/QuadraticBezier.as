package sh.saqoo.geom {
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class QuadraticBezier implements IPathSegment  {
		
		public static const NUM_SEGMUNTS:int = 30;
		
		private var _start:Point;
		private var _control:Point;
		private var _end:Point;
		private var _length:Number;
		private var _ratio:Array;
		
		public function QuadraticBezier(start:Point, control:Point, end:Point) {
			this._start = start;
			this._control = control;
			this._end = end;
			this.integralInit();
			this.ratioInit();
		}
		
		public function get start():Point {
			return this._start;
		}
		
		public function get control():Point {
			return this._control;
		}
		
		public function get end():Point {
			return this._end;
		}
		
		private function ratioInit():void {
			this._ratio = [];
			var dl:Number = this._length / NUM_SEGMUNTS;
			for (var l:Number = 0; l <= this._length; l += dl) {
				this._ratio.push(this.length2T(l));
			}
			this._ratio.push(1);
		}
		
		public function draw(g:Graphics):void {
			g.moveTo(this._start.x, this._start.y);
			g.curveTo(this._control.x, this._control.y, this._end.x, this._end.y);
		}
	
		public function getPointAt(t:Number):Point {
			if (t <= 0) {
				return this._start.clone();
			} else if (1 <= t) {
				return this._end.clone();
			} else {
				var it:Number = t * NUM_SEGMUNTS;
				const idx:int = Math.floor(it);
				it -= idx;
				t = this._ratio[idx] * (1 - it) + this._ratio[idx + 1] * it;
				const tt:Number = 1 - t;
				const t1:Number = tt * tt;
				const t2:Number = 2 * t * tt;
				const t3:Number = t * t;
				return new Point(
					this._start.x * t1 + this._control.x * t2 + this._end.x * t3,
					this._start.y * t1 + this._control.y * t2 + this._end.y * t3
				);
			}
		}
		
		public function get length():Number {
			return this._length;
		}
		


		/**
		 * code by nutsu: http://nutsu.com/blog/2007/092600_as_bezjesegment1.html
		 */
		 
		private var XY:Number;
		private var B:Number;
		private var C:Number;
		private var CS:Number;
		private var CS2:Number;
		private var INTG_0:Number;
		
		private function integralInit():void{
			var kx:Number = this._start.x + this._end.x - 2 * this._control.x;
			var ky:Number = this._start.y + this._end.y - 2 * this._control.y;
			var ax:Number = - this._start.x + this._control.x;
			var ay:Number = - this._start.y + this._control.y;
			
			XY = kx*kx + ky*ky;
			B  = ( ax*kx + ay*ky )/XY;
			C  = ( ax*ax + ay*ay )/XY - B*B;
			if( C>1e-10 ){
				CS  = Math.sqrt(C);
				CS2 = 0.0;
			}else{
				C = 0;
				CS = CS2 = 1.0;
			}
			INTG_0  = integralBezje(0.0);
			
			this._length = integral(1.0);
		}

		private function integralBezje( t:Number ):Number{
			var BT:Number  = B+t;
			var BTS:Number = Math.sqrt( BT*BT+C );
			return Math.sqrt(XY) * ( BTS*BT + C * Math.log( (BT + BTS)/CS + CS2 ) );
		}

		public function integral(t:Number):Number{
			return (integralBezje(t) - INTG_0);
		}
		
		public function length2T( len:Number, d:Number=0.1 ):Number{
			if( len<0 || len>_length ){
				return Number.NaN;
			}else{
				return seekL( len, d );
			}
		}
		
		private function seekL( len:Number, d:Number=0.1, t0:Number=0.5, td:Number=0.25  ):Number{
			var lent0:Number = integral(t0);
			if( Math.abs( len-lent0 )<d ){
				return t0;
			}else{
				return seekL( len, d, (lent0<len) ? t0+td : t0-td, td/2 );
			}
		}
		
	}
	
}