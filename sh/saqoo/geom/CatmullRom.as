package sh.saqoo.geom {
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	
	/**
	 * Catmull-Rom Spline Curve
	 * @author Saqoosha
	 */
	public dynamic class CatmullRom extends Proxy {
		
		
		private var _p0:Point;
		private var _p1:Point;
		private var _p2:Point;
		private var _p3:Point;
		
		private var _points:Vector.<Point>;
		
		
		public function CatmullRom(p0:Point = null, p1:Point = null, p2:Point = null, p3:Point = null) {
			_p0 = p0 || new Point();
			_p1 = p1 || new Point();
			_p2 = p2 || new Point();
			_p3 = p3 || new Point();
			_points = Vector.<Point>([_p0, _p1, _p2, _p3]);
		}
		
		
		public function getPointAt(t:Number, out:Point = null):Point {
			out ||= new Point();
			var t2:Number = t * t;
			var t3:Number = t2 * t;
			var a:Number = -t3 + 2 * t2 - t;
			var b:Number = 3 * t3 - 5 * t2 + 2;
			var c:Number = -3 * t3 + 4 * t2 + t;
			var d:Number = t3 - t2;
			out.x = (_p0.x * a + _p1.x * b + _p2.x * c + _p3.x * d) * 0.5;
			out.y = (_p0.y * a + _p1.y * b + _p2.y * c + _p3.y * d) * 0.5;
			return out;
		}
		
		
		public function getTangentAt(t:Number, out:Point = null):Point {
			out ||= new Point();
			var t2:Number = t * t;
			var a:Number = -3 * t2 + 4 * t - 1;
			var b:Number = 9 * t2 - 10 * t;
			var c:Number = -9 * t2 + 8 * t + 1;
			var d:Number = 3 * t2 - 2 * t;
			out.x = (_p0.x * a + _p1.x * b + _p2.x * c + _p3.x * d) * 0.5;
			out.y = (_p0.y * a + _p1.y * b + _p2.y * c + _p3.y * d) * 0.5;
			return out;
		}

		
		public function draw(graphics:Graphics, numSegments:int = 50, moveToFirst:Boolean = false):void {
			var p:Point = new Point();
			if (moveToFirst) {
			}
			for (var i:int = 1; i <= numSegments; ++i) {
				getPointAt(i / numSegments, p);
				graphics.lineTo(p.x, p.y);
			}
		}
		
		
		public function debugDraw(graphics:Graphics):void {
			graphics.lineStyle(0, 0x0, 0.2);
			graphics.moveTo(_p0.x, _p0.y);
			graphics.lineTo(_p1.x, _p1.y);
			graphics.moveTo(_p2.x, _p2.y);
			graphics.lineTo(_p3.x, _p3.y);
			graphics.lineStyle();
			graphics.beginFill(0xff0000);
			graphics.drawCircle(_p0.x, _p0.y, 3);
			graphics.drawCircle(_p3.x, _p3.y, 3);
			graphics.endFill();
			graphics.beginFill(0x0000ff);
			graphics.drawCircle(_p1.x, _p1.y, 3);
			graphics.drawCircle(_p2.x, _p2.y, 3);
			graphics.endFill();
		}

		
		public function setPoints(points:Vector.<Point>):void {
			p0 = points[0];
			p1 = points[1];
			p2 = points[2];
			p3 = points[3];
		}

		
		public function get p0():Point { return _p0; }
		public function set p0(value:Point):void {
			_p0.x = value.x;
			_p0.y = value.y;
		}
		
		
		public function get p1():Point { return _p1; }
		public function set p1(value:Point):void {
			_p1.x = value.x;
			_p1.y = value.y;
		}
		
		
		public function get p2():Point { return _p2; }
		public function set p2(value:Point):void {
			_p2.x = value.x;
			_p2.y = value.y;
		}
		
		
		public function get p3():Point { return _p3; }
		public function set p3(value:Point):void {
			_p3.x = value.x;
			_p3.y = value.y;
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
			_points[index].x = value.x;
			_points[index].y = value.y;
		}

		
		override flash_proxy function nextNameIndex(index:int):int {
			return 0;
		}
		
		
		public function toString():String {
			return '[CatmullRom p0=' + _p0 + ' p1=' + _p1 + ' p2=' + _p2 + ' p3=' + _p3 + ']';
		}
	}
}
