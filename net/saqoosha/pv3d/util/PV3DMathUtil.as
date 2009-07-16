package net.saqoosha.pv3d.util {
	
	import net.saqoosha.geom.Point3D;
	
	import org.papervision3d.core.math.Matrix3D;
	
	public class PV3DMathUtil {
		
		public static function transformPoint3D(p:Point3D, m:Matrix3D, out:Point3D = null):Point3D {
			var vx:Number = p.x;
			var vy:Number = p.y;
			var vz:Number = p.z;
			var ret:Point3D = out || new Point3D();
			ret.x = vx * m.n11 + vy * m.n12 + vz * m.n13 + m.n14;
			ret.y = vx * m.n21 + vy * m.n22 + vz * m.n23 + m.n24;
			ret.z = vx * m.n31 + vy * m.n32 + vz * m.n33 + m.n34;
			return ret;
		}
	}
}