package sh.saqoo.geom {
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class LineSegment implements IPathSegment {
		
		private var _start:Point;
		private var _end:Point;
		
		public function LineSegment(start:Point, end:Point) {
			this._start = start;
			this._end = end;
		}
		
		public function get start():Point {
			return this._start;
		}
		
		public function get end():Point {
			return this._end;
		}
		
		public function draw(g:Graphics):void {
			g.moveTo(this._start.x, this._start.y);
			g.lineTo(this._end.x, this._end.y);
		}
		
		public function getPointAt(t:Number):Point {
			const tt:Number = 1 - t;
			return new Point(this._start.x * tt + this._end.x * t, this._start.y * tt + this._end.y * t);
		}
		
		public function get length():Number {
			return Point.distance(this._start, this._end);
		}
		
	}
	
}