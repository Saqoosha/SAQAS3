package sh.saqoo.util {

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	public class GeometryUtil {
		
		
		private static const _tmpPoint:Point = new Point();
		
		public static function localXToGlobalX(local:DisplayObject, x:Number):Number {
			_tmpPoint.x = x;
			return local.localToGlobal(_tmpPoint).x;
		}
		
		public static function localYToGlobalY(local:DisplayObject, y:Number):Number {
			_tmpPoint.y = y;
			return local.localToGlobal(_tmpPoint).y;
		}
		
		public static function globalXToLocalX(local:DisplayObject, x:Number):Number {
			_tmpPoint.x = x;
			return local.globalToLocal(_tmpPoint).x;
		}
		
		public static function globalYToLocalY(local:DisplayObject, y:Number):Number {
			_tmpPoint.y = y;
			return local.globalToLocal(_tmpPoint).y;
		}
		
		
		public static function center(rect:Rectangle, out:Point = null):Point {
			out ||= new Point();
			out.x = rect.x + rect.width * 0.5;
			out.y = rect.y + rect.height * 0.5;
			return out;
		}
		
		
		public static function dot(a:Point, b:Point):Number {
			return a.x * b.x + a.y * b.y;
		}
		
		public static function cross(a:Point, b:Point):Number {
			return a.x * b.y - a.y * b.x;
		}
		
		
		//
		
		
		/**
		 * Reduce the number of points using Douglas-Packer algorithm.
		 * @see http://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm
		 */
		public static function reducePoints(points:Vector.<Point>, epsilon:Number = 10.0):Vector.<Point> {
			var dmax:Number = 0;
			var index:int = 0;
			var n:int = points.length - 1;
			for (var i:int = 1; i < n; ++i) {
				var d:Number = _distance(points[0], points[n], points[i]);
				if (d > dmax) {
					dmax = d;
					index = i;
				}
			}
			if (dmax > epsilon) {
				var r1:Vector.<Point> = reducePoints(points.slice(0, index + 1), epsilon);
				r1.pop();
				var r2:Vector.<Point> = reducePoints(points.slice(index, n + 1), epsilon);
				return r1.concat(r2);
			} else {
				return Vector.<Point>([points[0], points[n]]);
			}
		}


		/**
		 * Calculate distance between line segment (p0->p1) to point (p2).
		 * @see http://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segments
		 */
		private static function _distance(p0:Point, p1:Point, p2:Point):Number {
			var t:Point = p1.subtract(p0);
			t.normalize(1);
			var ac:Point = p2.subtract(p0);
			var d:Number = ac.x * -t.y + ac.y * t.x;
			return d < 0 ? -d : d;
		}
	}
}
