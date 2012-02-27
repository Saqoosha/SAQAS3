package sh.saqoo.geom {

	import flash.geom.Vector3D;

	/**
	 * @author Saqoosha
	 */
	public class Quaternion {
		
		
		public static const EPS:Number = 1e-8;
		
		
		/**
		 * @see https://github.com/Papervision3D/Papervision3D/blob/master/src/org/papervision3d/core/math/Quaternion.as#L390
		 */
		public static function slerp(a:Vector3D, b:Vector3D, alpha:Number, out:Vector3D = null):Vector3D {
			out ||= new Vector3D();
			
			var ax:Number, ay:Number, az:Number, aw:Number;
			var bx:Number, by:Number, bz:Number, bw:Number;
			
			var angle:Number = a.w * b.w + a.x * b.x + a.y * b.y + a.z * b.z;
			if (angle < 0.0) {
				ax = a.x * -1.0;
				ay = a.y * -1.0;
				az = a.z * -1.0;
				aw = a.w * -1.0;
				angle *= -1.0;
			} else {
				ax = a.x;
				ay = a.y;
				az = a.z;
				aw = a.w;
			}
			
			var scale:Number;
			var invscale:Number;
		 
			if (angle + 1.0 > EPS) { // Take the shortest path
				bx = b.x;
				by = b.y;
				bz = b.z;
				bw = b.w;
				
				if (1.0 - angle >= EPS) { // spherical interpolation
					var theta:Number = Math.acos(angle);
					var invsintheta:Number = 1.0 / Math.sin(theta);
					scale = Math.sin(theta * (1.0 - alpha)) * invsintheta;
					invscale = Math.sin(theta * alpha) * invsintheta;
				} else { // linear interploation
					scale = 1.0 - alpha;
					invscale = alpha;
				}
				
			} else { // long way to go...
				by = -ay;
				bx = ax;
				bw = -aw;
				bz = az;
	
				scale = Math.sin(Math.PI * (0.5 - alpha));
				invscale = Math.sin(Math.PI * alpha);
			}
	 
			out.x = scale * ax + invscale * bx;
			out.y = scale * ay + invscale * by;
			out.z = scale * az + invscale * bz;
			out.w = scale * aw + invscale * bw;
			if (isNaN(out.x)) {
				throw new Error('something wrong!!!!!!!!!!!!!!!!');
			}
			
			return out;
		}
	}
}
