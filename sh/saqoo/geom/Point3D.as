package sh.saqoo.geom {
	
	public class Point3D {

		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function Point3D(x:Number = 0, y:Number = 0, z:Number = 0) {
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function add(p:Point3D):Point3D {
			return new Point3D(x + p.x, y + p.y, z + p.z);
		}
		
		public function subtract(p:Point3D):Point3D {
			return new Point3D(x - p.x, y - p.y, z - p.z);
		}
		
		public static function blend(a:Point3D, b:Point3D, alpha:Number = 1, out:Point3D = null):Point3D {
			var ret:Point3D = out || new Point3D();
			var beta:Number = 1 - alpha;
			ret.x = a.x * alpha + b.x * beta;
			ret.y = a.y * alpha + b.y * beta;
			ret.z = a.z * alpha + b.z * beta;
			return ret;
		}
		
		public function clone():Point3D {
			return new Point3D(x, y, z);
		}
		
		public function toString():String {
			return '[Point3D x=' + x + ', y=' + y + ', z=' + z + ']';
		}
	}
}