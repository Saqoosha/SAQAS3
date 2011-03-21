package sh.saqoo.util {

	import sh.saqoo.geom.CubicBezierSegment;

	import flash.display.DisplayObject;
	import flash.geom.Matrix;
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
		
		
		/**
		 * Calc the angle between vector v0 and v1.
		 * Clockwise angle becomes positive number.
		 * @see http://www5d.biglobe.ne.jp/~noocyte/Programming/Geometry/RotationDirection.html
		 */
		public static function angleBetween(v0:Point, v1:Point):Number {
			return Math.atan2(GeometryUtil.cross(v0, v1), GeometryUtil.dot(v0, v1));
		}
		
		
		/**
		 * Check whether the point is insde polygon.
		 */
		public static function isInsidePolygon(point:Point, polygon:Vector.<Point>):Boolean {
			var sum:Number = 0;
			var n:int = polygon.length;
			if (n < 3) return false;
			var v0:Point = polygon[n - 1].subtract(point);
			for (var i:int; i < n; i++) {
				var v1:Point = polygon[i].subtract(point);
				sum += GeometryUtil.angleBetween(v0, v1);
				v0 = v1;
			}
			return Boolean(Math.round(sum / (Math.PI * 2)) & 1);
		}
		
		
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


		/**
		 * Inset polygon with distance.
		 * @param points Vertices of the polygon. must be clockwise.
		 * @param distance Distance of inset.
		 * @see http://alienryderflex.com/polygon_inset/
		 */
		public static function insetPolygon(points:Vector.<Point>, distance:Number):Vector.<Point> {
			if (points.length < 3) throw new Error('requires at least 3 points.');
			var n:int = points.length;
			var p0:Point = points[n - 1];
			var inset:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < n; i++) {
				var p1:Point = points[i];
				var p2:Point = points[(i + 1) % n];
				inset.push(insetCorner(p0, p1, p2, distance));
				p0 = p1;
			}
			return inset;
		}
		
		
		/**
		 * Calc the inset point of p1.
		 * @see http://alienryderflex.com/polygon_inset/
		 */
		public static function insetCorner(p0:Point, p1:Point, p2:Point, distance:Number):Point {
		    //  Calculate length of line segments.
		    var d1:Point = p1.subtract(p0);
		    var d2:Point = p2.subtract(p1);
		    
		    //  Exit if either segment is zero - length.
		    if (d1.length == 0 || d2.length == 0) return null;
		    
			//  Inset each of the two line segments.
			d1.normalize(distance);
			var a:Point = new Point(p0.x + d1.y, p0.y - d1.x);
			var b:Point = new Point(p1.x + d1.y, p1.y - d1.x);
			d2.normalize(distance);
			var c:Point = new Point(p1.x + d2.y, p1.y - d2.x);
			var d:Point = new Point(p2.x + d2.y, p2.y - d2.x);
			
			//  If inset segments connect perfectly, return the connection point.
			if (b.equals(c)) return b;
			
			//  Return the intersection point of the two inset segments (if any).
			return getIntersectionPoint(a, b, c, d);
		}
		
		
		/**
		 * Calc the intersection point of the line segment (a-b) with the line segment (c-d).
		 * @see http://alienryderflex.com/intersect/
		 */
		public static function getIntersectionPoint(a:Point, b:Point, c:Point, d:Point):Point {
			//  (1) Translate the system so that point A is on the origin.
			b = b.subtract(a);
			c = c.subtract(a);
			d = d.subtract(a);
			
			//  Discover the length of segment A-B.
			var distAB:Number = b.length;
			
			//  (2) Rotate the system so that point B is on the positive X axis.
			var cos:Number = b.x / distAB;
			var sin:Number = b.y / distAB;
			var newX:Number = c.x * cos + c.y * sin;
			c.y = c.y * cos - c.x * sin;
			c.x = newX;
			newX = d.x * cos + d.y * sin;
			d.y = d.y * cos - d.x * sin;
			d.x = newX;
			
			//  Fail if the lines are parallel.
			if (c.y == d.y) return null;

			//  (3) Discover the position of the intersection point along line A-B.
			var ABpos:Number = d.x + (c.x - d.x) * d.y / (d.y - c.y);

			//  (4) Apply the discovered position to line A-B in the original coordinate system.
		    return new Point(a.x + ABpos * cos, a.y + ABpos * sin);
		}


		/**
		 * Approximate circular arc with several cubic bezier segments.
		 * @see http://www.devenezia.com/papers/other/Bezier%20Points%20for%20Circular%20Arc.pdf
		 */
		public static function convertArcToCubicBezier(center:Point, radius:Number, startAngle:Number, endAngle:Number):Vector.<CubicBezierSegment> {
			var th:Number = endAngle - startAngle;
			var n:int = Math.ceil(th / (Math.PI / 2));
			var segments:Vector.<CubicBezierSegment> = new Vector.<CubicBezierSegment>();
			for (var i:int = 0; i < n; i++) {
				segments.push(_convertArcToBezier(center, radius, startAngle + i / n * th, startAngle + (i + 1) / n * th));
			}
			return segments;
		}
		
		
		private static function _convertArcToBezier(center:Point, radius:Number, startAngle:Number, endAngle:Number):CubicBezierSegment {
			var th:Number = (endAngle - startAngle) * 0.5;
			var mtx:Matrix = new Matrix();
			mtx.scale(radius, radius);
			mtx.rotate(startAngle + th);
			mtx.translate(center.x, center.y);
			var p0:Point = new Point(Math.cos(th), Math.sin(th));
			var p1:Point = new Point((4 - p0.x) / 3, (1 - p0.x) * (3 - p0.x) / (3 * p0.y));
			var p2:Point = new Point(p1.x, -p1.y);
			var p3:Point = new Point(p0.x, -p0.y);
			return new CubicBezierSegment(
				mtx.transformPoint(p3),
				mtx.transformPoint(p2),
				mtx.transformPoint(p1),
				mtx.transformPoint(p0)
			);
		}
	}
}
