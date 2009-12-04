package net.saqoosha.math {
	import org.papervision3d.core.math.Number3D;
	
	public class MathUtil {
		
		public static function randomInRange(low:Number, high:Number):Number {
			return low + (high - low) * Math.random();
		}
		
		public static function randomOnSphereSurface(radius:Number, out:Number3D = null):Number3D {
			out ||= new Number3D();
			var phi:Number = Math.random() * Math.PI * 2;
			out.z = Math.random() * 2 - 1;
			var theta:Number = Math.sqrt(1 - out.z * out.z);
			out.x = radius * theta * Math.cos(phi);
			out.y = radius * theta * Math.sin(phi);
			out.z *= radius;
			return out;
		}
	}
}