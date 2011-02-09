package sh.saqoo.geom {
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	
	/**
	 * Cubic Hermite Spline
	 * @author Saqoosha
	 * @see http://en.wikipedia.org/wiki/Cubic_Hermite_spline
	 * @see http://www.cubic.org/docs/hermite.htm
	 */
	public dynamic class CubicHermite extends Proxy {
		
		
		private var _p0:Point;
		private var _v0:Point;
		private var _p1:Point;
		private var _v1:Point;
		
		private var _points:Vector.<Point>;
		
		
		public function CubicHermite(p0:Point = null, v0:Point = null, p1:Point = null, v1:Point = null) {
			_p0 = p0 || new Point();
			_v0 = v0 || new Point();
			_p1 = p1 || new Point();
			_v1 = v1 || new Point();
			_points = Vector.<Point>([_p0, _v0, _p1, _v1]);
		}
		
		
		public function getPositionAt(t:Number, out:Point = null):Point {
			out ||= new Point();
			var t2:Number = t * t;
			var t3:Number = t2 * t;
			var a:Number = 2 * t3 - 3 * t2 + 1;
			var b:Number = t3 - 2 * t2 + t;
			var c:Number = -2 * t3 + 3 * t2;
			var d:Number = t3 - t2;
			out.x = _p0.x * a + _v0.x * b + _p1.x * c + _v1.x * d;
			out.y = _p0.y * a + _v0.y * b + _p1.y * c + _v1.y * d;
			return out;
		}
		
		
		public function getTangentAt(t:Number, out:Point = null):Point {
			out ||= new Point();
			var t2:Number = t * t;
			var a:Number = 6 * (t2 - t);
			var b:Number = 3 * t2 - 4 * t + 1;
			var c:Number = 6 * (t - t2);
			var d:Number = 3 * t2 - 2 * t;
			out.x = _p0.x * a + _v0.x * b + _p1.x * c + _v1.x * d;
			out.y = _p0.y * a + _v0.y * b + _p1.y * c + _v1.y * d;
			return out;
		}

		
		public function draw(graphics:Graphics, numSegments:int = 50):void {
			var p:Point = new Point();
			for (var i:int = 1; i <= numSegments; ++i) {
				getPositionAt(i / numSegments, p);
				graphics.lineTo(p.x, p.y);
			}
		}

		
		public function debugDraw(graphics:Graphics):void {
			graphics.lineStyle(0, 0x0, 0.2);
			graphics.moveTo(_p0.x, _p0.y);
			graphics.lineTo(_p0.x + _v0.x, _p0.y + _v0.y);
			graphics.moveTo(_p1.x, _p1.y);
			graphics.lineTo(_p1.x + _v1.x, _p1.y + _v1.y);
			graphics.lineStyle();
			graphics.beginFill(0xff0000);
			graphics.drawCircle(_p0.x, _p0.y, 3);			graphics.drawCircle(_p1.x, _p1.y, 3);
			graphics.endFill();
			graphics.beginFill(0x0000ff);
			graphics.drawCircle(_p0.x + _v0.x, _p0.y + _v0.y, 3);
			graphics.drawCircle(_p1.x + _v1.x, _p1.y + _v1.y, 3);
			graphics.endFill();
		}

		
		public function get p0():Point { return _p0; }
		public function set p0(value:Point):void {
			_p0.x = value.x;
			_p0.y = value.y;
		}
		
		
		public function get v0():Point { return _v0; }
		public function set v0(value:Point):void {
			_v0.x = value.x;
			_v0.y = value.y;
		}
		
		
		public function get p1():Point { return _p1; }
		public function set p1(value:Point):void {
			_p1.x = value.x;
			_p1.y = value.y;
		}
		
		
		public function get v1():Point { return _v1; }
		public function set v1(value:Point):void {
			_v1.x = value.x;
			_v1.y = value.y;
		}

		
		override flash_proxy function getProperty(name:*):* {
			var index:int = int(name);
			if (index < 0 || 3 < index || !(name is String)) throw new ArgumentError('Prop name must be int in range 0 to 3.');
			return _points[index];
		}

		
		override flash_proxy function setProperty(name:*, value:*):void {
			var index:int = int(name);
			if (index < 0 || 3 < index || !(name is String)) throw new ArgumentError('Prop name must be int in range 0 to 3.');
			if (!(value is Point)) throw new ArgumentError('Value must be instance of flash.geom.Point.');
			_points[index].x = value.x;			_points[index].y = value.y;
		}

		
		override flash_proxy function nextNameIndex(index:int):int {
			return 0;
		}
		
		
		public function toString():String {
			return '[CubicHermite p0=' + _p0 + ' v0=' + _v0 + ' p1=' + _p1 + ' v1=' + _v1 + ']';
		}
	}
}
