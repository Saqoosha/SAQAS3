package net.saqoosha.math {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	
	/**
	 * @author hiko
	 */
	public class SummedAreaTable {
		
		
		/**
		 * data format: ARGB ARGB ARGB ARGB....
		 */
		private var _sat:Vector.<Number>;
		
		
		public function SummedAreaTable(source:BitmapData) {
			var pix:ByteArray = source.getPixels(source.rect);
			_sat = new Vector.<Number>(source.width * source.height * 4, true);
			
			var w:int = source.width;
			var h:int = source.height;
			var x:int, y:int, idx:int;
			for (x = 0; x < w; ++x) {
				idx = x * 4;
				_sat[idx] = pix[idx++];				_sat[idx] = pix[idx++];				_sat[idx] = pix[idx++];				_sat[idx] = pix[idx++];
			}
			for (y = 0; y < w; ++y) {
				idx = y * w * 4;
				_sat[idx] = pix[idx++];				_sat[idx] = pix[idx++];				_sat[idx] = pix[idx++];				_sat[idx] = pix[idx++];
			}
			
			var w4:int = w * 4;			for (y = 1; y < h; ++y) {
				for (x = 1; x < w;++x) {
					idx = (y * w + x) * 4;
					_sat[idx] = pix[idx] + _sat[idx - 4] + _sat[idx - w4] + _sat[idx - w4 - 4]; idx++;					_sat[idx] = pix[idx] + _sat[idx - 4] + _sat[idx - w4] + _sat[idx - w4 - 4]; idx++;					_sat[idx] = pix[idx] + _sat[idx - 4] + _sat[idx - w4] + _sat[idx - w4 - 4]; idx++;					_sat[idx] = pix[idx] + _sat[idx - 4] + _sat[idx - w4] + _sat[idx - w4 - 4]; idx++;
				}
			}
		}
		
		
		public function get values():Vector.<Number> {
			return _sat;
		}
	}
}
