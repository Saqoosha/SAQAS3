package sh.saqoo.math {

	import flash.geom.Point;
	import flash.geom.Vector3D;


	public class MathUtil {


		public static const toRadian:Number = Math.PI / 180;
		public static const toDegree:Number = 180 / Math.PI;


		public static function randomInRange(low:Number, high:Number):Number {
			return low + (high - low) * Math.random();
		}
		
		
		public static function randomSign(p:Number = 0.5):Number { 
			return Math.random() < p ? 1 : -1;
		}


		/**
		 * @see http://www.phys.cs.is.nagoya-u.ac.jp/~watanabe/pdf/prob.pdf
		 */
		public static function randomInCircle(radius:Number, center:Point = null):Point {
			var th:Number = Math.random() * Math.PI * 2;
			var r:Number = Math.sqrt(Math.random()) * radius;
			var p:Point = new Point(Math.cos(th) * r, Math.sin(th) * r);
			if (center) {
				p.x += center.x;
				p.y += center.y;
			}
			return p;
		}
		
		
		/**
		 * @see http://www.phys.cs.is.nagoya-u.ac.jp/~watanabe/pdf/prob.pdf
		 */
		public static function randomOnSphereSurface(radius:Number, center:Vector3D = null):Vector3D {
			var z:Number = Math.random() * 2 - 1;
			var zz:Number = Math.sqrt(1 - z * z);
			var th:Number = Math.random() * Math.PI * 2;
			
			var v:Vector3D = new Vector3D();
			v.x = zz * Math.cos(th);
			v.y = zz * Math.sin(th);
			v.z = z;
			
			v.scaleBy(radius);
			if (center) v.incrementBy(center);
			return v;
		}
		
		
		/**
		 * @see http://www.phys.cs.is.nagoya-u.ac.jp/~watanabe/pdf/prob.pdf
		 */
		public static function randomInSphere(radius:Number, center:Vector3D = null):Vector3D {
			var z:Number = Math.random() * 2 - 1;
			var th:Number = Math.random() * Math.PI * 2;
			var r:Number = Math.pow(Math.random(), 1 / 3);
			
			var v:Vector3D = new Vector3D();
			v.z = r * z;
			r *= Math.sqrt(1 - z * z);
			v.x = r * Math.cos(th);
			v.y = r * Math.sin(th);
			
			v.scaleBy(radius);
			if (center) v.incrementBy(center);
			return v;
		}
	}
}
