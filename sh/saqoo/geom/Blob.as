package sh.saqoo.geom {

	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * Mainly used by ContourFinder class.
	 * @author Saqoosha
	 * @see sh.saqoo.imageprocessing.ContourFinder
	 */
	public class Blob {
		
		
		private var _points:Vector.<Point>;
		private var _bounds:Rectangle;
		private var _area:Number;
		private var _isHole:Boolean;
		
		
		public function get points():Vector.<Point> { return _points; }
		public function get bounds():Rectangle { return _bounds; }
		public function get area():Number { return _area; }
		public function get isHole():Boolean { return _isHole; }
		public function get density():Number { return _area ? _area / (_bounds.width * _bounds.height) : 0; }
	
	
		public function Blob(points:Vector.<Point>, isHole:Boolean) {
			_points = points;
			_isHole = isHole;

			var xmin:int, xmax:int, ymin:int, ymax:int;
			xmin = ymin = int.MAX_VALUE;
			xmax = ymax = int.MIN_VALUE;
			var i:int, n:int = _points.length - 1;
			_area = 0;
			for (i = 0; i < n; i++) {
				var p0:Point = _points[i + 1];
				var p1:Point = _points[i];
				_area += (p1.x - p0.x) * (p0.y + p1.y) * 0.5;
				if (p0.x < xmin) xmin = p0.x;
				if (xmax < p0.x) xmax = p0.x;
				if (p0.y < ymin) ymin = p0.y;
				if (ymax < p0.y) ymax = p0.y;
			}
			_area = Math.abs(_area);
			_bounds = new Rectangle(xmin, ymin, xmax - xmin, ymax - ymin);
		}


		public function toString():String {
			return '[Blob points=' + _points.length + ' bounds=' + _bounds + ' area=' + _area + ' density=' + (int(density * 1000) / 1000) + ' isHole=' + _isHole + ']';
		}
	}
}
