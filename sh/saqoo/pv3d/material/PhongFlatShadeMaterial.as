package sh.saqoo.pv3d.material {
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.material.AbstractLightShadeMaterial;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.proto.LightObject3D;
	import org.papervision3d.core.render.data.RenderSessionData;
	import org.papervision3d.core.render.draw.ITriangleDrawer;
	import org.papervision3d.materials.utils.LightMaps;
	
	public class PhongFlatShadeMaterial extends AbstractLightShadeMaterial implements ITriangleDrawer {
		
		private var _colors:Array;
		
		public function PhongFlatShadeMaterial(light:LightObject3D, specular:uint = 0xffffff, power:int = 50, diffuse:uint=0x808080, ambient:uint=0x000000) {
			super();
			this.fillAlpha = 1;
			this.light = light;
			_colors = [];
			const sr:int = (specular >> 16) & 0xff;
			const sg:int = (specular >> 8) & 0xff;
			const sb:int = specular & 0xff;
			const dr:int = (diffuse >> 16) & 0xff;
			const dg:int = (diffuse >> 8) & 0xff;
			const db:int = diffuse & 0xff;
			const ar:int = (ambient >> 16) & 0xff;
			const ag:int = (ambient >> 8) & 0xff;
			const ab:int = ambient & 0xff;
			var i:int = 512;
			var ks:Number, kd:Number;
			while (i--) {
				ks = Math.pow(Math.cos(i / 512 * Math.PI / 2), power);
				kd = 1 - (i / 512);
				_colors.push(
					(Math.min(0xff, ar + kd * dr + ks * sr) << 16) |
					(Math.min(0xff, ag + kd * dg + ks * sg) << 8) |
					(Math.min(0xff, ab + kd * db + ks * sb))
				);
			}
		}
		
		/**
		 * Localized stuff.
		 */
		private static var zd:Number;
		private static var x0:Number;
		private static var y0:Number;
		private static var currentColor:int;
		private static var zAngle:int;
		override public function drawTriangle(face3D:Triangle3D, graphics:Graphics, renderSessionData:RenderSessionData, altBitmap:BitmapData = null, altUV:Matrix = null):void {
			lightMatrix = Matrix3D(lightMatrices[face3D.instance]);
			zd = face3D.faceNormal.x * lightMatrix.n31 + face3D.faceNormal.y * lightMatrix.n32 + face3D.faceNormal.z * lightMatrix.n33;
			if(zd < 0){zd = 0;};
			x0 = face3D.v0.vertex3DInstance.x;
		    y0 = face3D.v0.vertex3DInstance.y;
			zAngle = zd * 0x1ff;
			currentColor = _colors[zAngle];
			
			graphics.beginFill(currentColor, this.fillAlpha);
			graphics.moveTo(x0, y0);
			graphics.lineTo(face3D.v1.vertex3DInstance.x, face3D.v1.vertex3DInstance.y);
			graphics.lineTo(face3D.v2.vertex3DInstance.x, face3D.v2.vertex3DInstance.y);
			graphics.lineTo(x0, y0);
			graphics.endFill();
			renderSessionData.renderStatistics.shadedTriangles++;
		}
	}
}