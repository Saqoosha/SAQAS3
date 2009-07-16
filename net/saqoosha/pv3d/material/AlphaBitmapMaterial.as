package net.saqoosha.pv3d.material {
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	import org.papervision3d.materials.BitmapMaterial;

	public class AlphaBitmapMaterial extends BitmapMaterial {
		
		private var _orignal:BitmapData;
		private var _color:ColorTransform;
		
		public function AlphaBitmapMaterial(asset:BitmapData = null, alpha:Number = 1.0) {
			super(asset.clone(), false);
			this._orignal = asset;//.clone();
			this._color = new ColorTransform();
			this.alpha = alpha;
			this._updateBitmap();
		}
		
		protected function _updateBitmap():void {
			this.bitmap.fillRect(this.bitmap.rect, 0x0);
			this._color.alphaMultiplier = this.fillAlpha;
			this.bitmap.draw(this._orignal, null, this._color);
		}
		
		public override function destroy():void {
//			if (this._orignal) {
//				this._orignal.dispose();
//				this._orignal = null;
//			}
			this._orignal = null;
			this._color = null;
			super.destroy();
		}
		
		public function get original():BitmapData {
			return this._orignal;
		}
		
		public function get alpha():Number {
			return this.fillAlpha;
		}
		
		public function set alpha(value:Number):void {
			if (this.fillAlpha != value) {
				this.fillAlpha = value;
				this._updateBitmap();
			}
		}
	}
}