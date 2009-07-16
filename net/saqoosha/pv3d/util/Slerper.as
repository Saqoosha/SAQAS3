package net.saqoosha.pv3d {
	
	import org.papervision3d.core.math.Quaternion;
	import org.papervision3d.objects.DisplayObject3D;
	
	public class Slerper {
		
		private var _target:DisplayObject3D;
		private var _start:Quaternion;
		private var _end:Quaternion;
		private var _current:Quaternion;
		private var _alpha:Number = 0;
		
		public function Slerper(target:DisplayObject3D, start:Quaternion = null, end:Quaternion = null) {
			this._target = target;
			this._start = start;
			this._end = end;
			this._current = this._start ? this._start.clone() : new Quaternion();
			this._alpha = 0;
		}
		
		public function get target():DisplayObject3D {
			return this._target;
		}
		
		public function set target(value:DisplayObject3D):void {
			this._target = value;
		}
		
		public function get start():Quaternion {
			return this._start;
		}
		
		public function set start(value:Quaternion):void {
			this._start = value;
		}
		
		public function get end():Quaternion {
			return this._end;
		}
		
		public function set end(value:Quaternion):void {
			this._end = value;
		}
		
		public function get alpha():Number {
			return this._alpha
		}
		
		private static var tmp:Quaternion;
		public function set alpha(value:Number):void {
			this._alpha = value;
			if (this._alpha == 0.0) {
				tmp = this._start;
			} else if (this._alpha == 1.0) {
				tmp = this._end;
			} else {
				tmp = this._current;
				slerp(this._start, this._end, this._alpha, this._current);
			}
			this._target.transform.copy3x3(tmp.matrix);
		}
		
		private static var __angle:Number;
		private static var __scale:Number;
		private static var __invscale:Number;
		private static var __theta:Number;
		private static var __invsintheta:Number;
		public static function slerp( qa:Quaternion, qb:Quaternion, alpha:Number, out:Quaternion = null ):Quaternion
		{
			__angle = qa.w * qb.w + qa.x * qb.x + qa.y * qb.y + qa.z * qb.z
	 
	         if (__angle < 0.0)
	         {
	                 qa.x *= -1.0;
	                 qa.y *= -1.0;
	                 qa.z *= -1.0;
	                 qa.w *= -1.0;
	                 __angle *= -1.0;
	         }
	 
	         if ((__angle + 1.0) > Quaternion.EPSILON) // Take the shortest path
	         {
	                 if ((1.0 - __angle) >= Quaternion.EPSILON)  // spherical interpolation
	                 {
	                         __theta = Math.acos(__angle);
	                         __invsintheta = 1.0 / Math.sin(__theta);
	                         __scale = Math.sin(__theta * (1.0-alpha)) * __invsintheta;
	                         __invscale = Math.sin(__theta * alpha) * __invsintheta;
	                 }
	                 else // linear interploation
	                 {
	                         __scale = 1.0 - alpha;
	                         __invscale = alpha;
	                 }
	         }
	         else // long way to go...
	         {
				 qb.y = -qa.y;
				 qb.x = qa.x;
				 qb.w = -qa.w;
				 qb.z = qa.z;
	
	             __scale = Math.sin(Math.PI * (0.5 - alpha));
	             __invscale = Math.sin(Math.PI * alpha);
	         }
	 
	 		if (out) {
	 			out.x = __scale * qa.x + __invscale * qb.x;
				out.y = __scale * qa.y + __invscale * qb.y;
				out.z = __scale * qa.z + __invscale * qb.z;
				out.w = __scale * qa.w + __invscale * qb.w;
	 		} else {
				out =  new Quaternion(  __scale * qa.x + __invscale * qb.x, 
										__scale * qa.y + __invscale * qb.y,
										__scale * qa.z + __invscale * qb.z,
										__scale * qa.w + __invscale * qb.w );
	 		}
	 		return out;
		}
			
	}

}