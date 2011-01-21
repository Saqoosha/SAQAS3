package sh.saqoo.pv3d.util {
	import org.papervision3d.core.math.Matrix3D;

	import flash.geom.Matrix3D;

	/**
	 * @author Saqoosha
	 */
	public function copyPV3DMatrixToFL3DMatrix(pv3dmatrix:org.papervision3d.core.math.Matrix3D, fl3dmatrix:flash.geom.Matrix3D = null):flash.geom.Matrix3D {
		var p:org.papervision3d.core.math.Matrix3D = pv3dmatrix;
		fl3dmatrix ||= new flash.geom.Matrix3D();
		var f:Vector.<Number> = fl3dmatrix.rawData;
		f[0]  =  p.n11;  f[1]  = -p.n21;  f[2]  =  p.n31;  f[3]  =  p.n41;
		f[4]  = -p.n12;  f[5]  =  p.n22;  f[6]  = -p.n32;  f[7]  =  p.n42;
		f[8]  =  p.n13;  f[9]  = -p.n23;  f[10] =  p.n33;  f[11] =  p.n43;
		f[12] =  p.n14;  f[13] = -p.n24;  f[14] =  p.n34;  f[15] =  p.n44;
		fl3dmatrix.rawData = f;
		return fl3dmatrix;
	}
}
