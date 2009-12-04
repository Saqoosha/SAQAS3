package net.saqoosha.pv3d.material {
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	import org.papervision3d.materials.BitmapMaterial;

	public class AlphaBitmapMaterial extends BitmapMaterial {
		
		private var _orignal:BitmapData;
		private var _color:ColorTransform;
		
		public function AlphaBitmapMaterial(asset:BitmapData = null, alpha:Number = 1.0) {
			super(asset.clone(), false);
			_orignal = asset;//.clone();
			_color = new ColorTransform();
			this.alpha = alpha;
			_updateBitmap();
		}
		
		protected function _updateBitmap():void {
			bitmap.fillRect(bitmap.rect, 0x0);
			_color.alphaMultiplier = fillAlpha;
			bitmap.draw(_orignal, null, _color);
		}
		
		public override function destroy():void {
//			if (_orignal) {
//				_orignal.dispose();
//				_orignal = null;
//			}
			_orignal = null;
			_color = null;
			super.destroy();
		}
		
		public function get original():BitmapData {
			return _orignal;
		}
		
		public function get alpha():Number {
			return fillAlpha;
		}
		
		public function set alpha(value:Number):void {
			if (fillAlpha != value) {
				fillAlpha = value;
				_updateBitmap();
			}
		}
	}
}