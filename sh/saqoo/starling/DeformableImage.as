package sh.saqoo.starling {

	import starling.core.RenderSupport;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	import flash.geom.Rectangle;


	public class DeformableImage extends Quad {


		private var mTexture:Texture;


		public function DeformableImage(texture:Texture) {
			var frame:Rectangle = texture.frame;
			var width:Number = frame ? frame.width : texture.width;
			var height:Number = frame ? frame.height : texture.height;
			var pma:Boolean = texture.premultipliedAlpha;

			super(width, height, 0xffffff, pma);

			mTexture = texture;
			mTexture.adjustVertexData(mVertexData, 0, 4);
		}


		protected override function updateVertexData(width:Number, height:Number, color:uint, premultipliedAlpha:Boolean):void {
			super.updateVertexData(width, height, color, premultipliedAlpha);
			mVertexData.setTexCoords(0, 0.0, 0.0);
			mVertexData.setTexCoords(1, 1.0, 0.0);
			mVertexData.setTexCoords(2, 0.0, 1.0);
			mVertexData.setTexCoords(3, 1.0, 1.0);
		}


		public override function render(support:RenderSupport, alpha:Number):void {
			support.batchQuad(this, alpha, mTexture, TextureSmoothing.BILINEAR);
		}


		public function setPosition(vertexID:int, x:Number, y:Number, z:Number=0.0):void {
			mVertexData.setPosition(vertexID, x, y);
		}
	}
}
