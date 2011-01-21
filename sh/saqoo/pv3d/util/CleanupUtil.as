package sh.saqoo.pv3d.util {
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.proto.GeometryObject3D;
	import org.papervision3d.objects.DisplayObject3D;

	
	public class CleanupUtil {

		
		public static function destroyDisplayObject3D(obj:DisplayObject3D):void {
//			if (obj.material) {
//				obj.material.destroy();
//				obj.material = null;
//			}
//			if (obj.materials) {
//				for each (var mat:MaterialObject3D in obj.materials.materialsByName) {
//					obj.materials.removeMaterial(mat);
//					mat.destroy();
//				}
//				obj.materials = null; 
//			}
			if (obj.geometry) {
				destroyGeometryObject3D(obj.geometry);
				obj.geometry = null;
			}
			for each (var child:DisplayObject3D in obj.children) {
				obj.removeChild(child);
				destroyDisplayObject3D(child);
			}
		}

		
		public static function destroyGeometryObject3D(geom:GeometryObject3D):void {
			for each (var v:Vertex3D in geom.vertices) {
				destroyVertex3D(v);
			}
			geom.vertices = null;
			for each (var f:Triangle3D in geom.faces) {
				destroyTriangle3D(f);
			}
			geom.faces = null;
		}

		
		public static function destroyTriangle3D(tri:Triangle3D):void {
			tri.vertices = null;
			tri.uv0 = null;
			tri.uv1 = null;
			tri.uv2 = null;
			tri.v0 = null;
			tri.v1 = null;
			tri.v2 = null;
			tri.faceNormal = null;
			tri.material = null;
		}

		
		public static function destroyVertex3D(v:Vertex3D):void {
			v.extra = null;
			v.vertex3DInstance = null;
			v.normal = null;
			v.connectedFaces = null;
		}
	}
}
