package sh.saqoo.math {

	import flash.geom.Point;


	public class MathUtil {


		public static const toRadian:Number = Math.PI / 180;
		public static const toDegree:Number = 180 / Math.PI;


		public static function randomInRange(low:Number, high:Number):Number {
			return low + (high - low) * Math.random();
		}
		
		
		public static function randomSign(p:Number):Number { 
			return Math.random() < p ? 1 : -1;
		}


		/**
		 * @see http://www.phys.cs.is.nagoya-u.ac.jp/~watanabe/pdf/prob.pdf
		 */
		public static function randomPointInCircle(radius:Number, center:Point = null):Point {
			var th:Number = Math.random() * Math.PI * 2;
			var r:Number = Math.sqrt(Math.random()) * radius;
			var p:Point = new Point(Math.cos(th) * r, Math.sin(th) * r);
			if (center) {
				p.x += center.x;
				p.y += center.y;
			}
			return p;
		}
	}
}
