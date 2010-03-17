package net.saqoosha.pv3d.util {
	import net.saqoosha.geom.Point3D;

	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;

	
	public class PV3DUtil {
		
		
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

		
		public static function normalizeVertices(obj:TriangleMesh3D):void {
			obj.updateTransform();
			for each (var v:Vertex3D in obj.geometry.vertices) {
				var n3:Number3D = v.toNumber3D();
				Matrix3D.multiplyVector(obj.transform, n3);
				v.x = n3.x;
				v.y = n3.y;
				v.z = n3.z;
			}
			obj.x = obj.y = obj.z = 0;
			obj.rotationX = obj.rotationY = obj.rotationZ = 0;
			obj.scale = 1;
			obj.updateTransform();
		}


		public static function flipZ(obj:TriangleMesh3D):TriangleMesh3D {
			obj.scaleZ *= -1;
			obj.z *= -1;
			return obj;
		}
	}
}
