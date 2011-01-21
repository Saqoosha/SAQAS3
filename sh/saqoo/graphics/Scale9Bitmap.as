package sh.saqoo.graphics {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	
	/**
	 * @author hiko
	 */
	public class Scale9Bitmap extends Sprite {
		
		
		private var _width:Number;
		private var _height:Number;
		
		private var _bitmapData:BitmapData;
		private var _rect:Rectangle;
		private var _smoothing:Boolean;
		private var _dirty:Boolean;
		
		private var _topMatrix:Matrix;
		private var _topRightMatrix:Matrix;
		private var _leftMatrix:Matrix;
		private var _centerMatrix:Matrix;
		private var _rightMatrix:Matrix;
		private var _bottomLeftMatrix:Matrix;
		private var _bottomMatrix:Matrix;
		private var _bottomRightMatrix:Matrix;
	
		
		public function Scale9Bitmap(bitmapData:BitmapData, rect:Rectangle, smoothing:Boolean = false) {
			_bitmapData = bitmapData;
			_rect = rect;
			_smoothing = smoothing;
			
			_width = bitmapData.width;
			_height = bitmapData.height;
			
			_topMatrix = new Matrix();
			_topRightMatrix = new Matrix();
			_leftMatrix = new Matrix();
			_centerMatrix = new Matrix();
			_rightMatrix = new Matrix();
			_bottomLeftMatrix = new Matrix();
			_bottomMatrix = new Matrix();
			_bottomRightMatrix = new Matrix();
			
			_dirty = true;
			_draw();
		}
	
		
		private function _draw():void {
			var bw0:Number = _rect.x;
			var bw1:Number = _rect.width;
			var bw2:Number = _bitmapData.width - (bw0 + bw1);
			var dw0:Number = bw0;
			var dw1:Number = _width - (bw0 + bw2);
			var dw2:Number = bw2;
			var bh0:Number = _rect.y;
			var bh1:Number = _rect.height;
			var bh2:Number = _bitmapData.height - (bh0 + bh1);
			var dh0:Number = bh0;
			var dh1:Number = _height - (bh0 + bh2);
			var dh2:Number = bh2;
			
			if (_dirty) {
				var sw:Number = dw1 / bw1;
				var sh:Number = dh1 / bh1;
				_topMatrix.identity();
				_topMatrix.translate(-bw0, 0);
				_topMatrix.scale(sw, 1);
				_topMatrix.translate(bw0, 0);
				_topRightMatrix.tx = dw1 - bw1;
				_leftMatrix.identity();
				_leftMatrix.translate(0, -bh0);
				_leftMatrix.scale(1, sh);
				_leftMatrix.translate(0, bh0);
				_centerMatrix.a = _topMatrix.a;
				_centerMatrix.d = _leftMatrix.d;
				_centerMatrix.tx = _topMatrix.tx;
				_centerMatrix.ty = _leftMatrix.ty;
				_rightMatrix.d = _leftMatrix.d;
				_rightMatrix.tx = _topRightMatrix.tx;
				_rightMatrix.ty = _leftMatrix.ty;
				_bottomLeftMatrix.ty = dh1 - bh1;
				_bottomMatrix.a = _topMatrix.a;
				_bottomMatrix.tx = _topMatrix.tx;
				_bottomMatrix.ty = _bottomLeftMatrix.ty;
				_bottomRightMatrix.tx = _rightMatrix.tx;
				_bottomRightMatrix.ty = _bottomMatrix.ty;
			}
			
			graphics.clear();
			
			// top-left
			graphics.beginBitmapFill(_bitmapData, null, false, _smoothing);
			graphics.drawRect(0, 0, dw0, dh0);
			graphics.endFill();
			
			// top
			graphics.beginBitmapFill(_bitmapData, _topMatrix, false, _smoothing);
			graphics.drawRect(dw0, 0, dw1, dh0);
			graphics.endFill();
			
			// top-right
			graphics.beginBitmapFill(_bitmapData, _topRightMatrix, false, _smoothing);
			graphics.drawRect(dw0 + dw1, 0, dw2, dh0);
			graphics.endFill();
			
			// left
			graphics.beginBitmapFill(_bitmapData, _leftMatrix, false, _smoothing);
			graphics.drawRect(0, dh0, dw0, dh1);
			graphics.endFill();
			
			// center
			graphics.beginBitmapFill(_bitmapData, _centerMatrix, false, _smoothing);
			graphics.drawRect(dw0, dh0, dw1, dh1);
			graphics.endFill();
			
			// right
			graphics.beginBitmapFill(_bitmapData, _rightMatrix, false, _smoothing);
			graphics.drawRect(dw0 + dw1, dh0, dw2, dh1);
			graphics.endFill();
			
			// bottom-left
			graphics.beginBitmapFill(_bitmapData, _bottomLeftMatrix, false, _smoothing);
			graphics.drawRect(0, dh0 + dh1, dw0, dh2);
			graphics.endFill();
			
			// bottom
			graphics.beginBitmapFill(_bitmapData, _bottomMatrix, false, _smoothing);
			graphics.drawRect(dw0, dh0 + dh1, dw1, dh2);
			graphics.endFill();
			
			// bottom-right
			graphics.beginBitmapFill(_bitmapData, _bottomRightMatrix, false, _smoothing);
			graphics.drawRect(dw0 + dw1, dh0 + dh1, dw2, dh2);
			graphics.endFill();
		}
	
		
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			if (value != _width) {
				_width = value;
				_draw();
			}
		}
		
		
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
			if (value != _height) {
				_height = value;
				_draw();
			}
		}
		
		
		public function get bitmapData():BitmapData { return _bitmapData; }
		public function set bitmapData(value:BitmapData):void {
			if (value != _bitmapData) {
				_bitmapData = value;
				_dirty = true;
				_draw();
			}
		}
		
		
		public function get rect():Rectangle { return _rect; }
		public function set rect(value:Rectangle):void {
			if (value != _rect) {
				_rect = value;
				_dirty = true;
				_draw();
			}
		}
		
		//
	}
}
