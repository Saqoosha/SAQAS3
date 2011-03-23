package sh.saqoo.filter {
	import sh.saqoo.geom.ZERO_POINT;

	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.utils.ByteArray;

	
	/**
	 * @author Saqoosha
	 */
	public class CannyEdgeDetector {
		
		
		private static const MONO_FILTER:ColorMatrixFilter = ColorMatrixFilterFactory.luma();
		private static const BLUR_FILTER:ConvolutionFilter = new ConvolutionFilter(5, 5, [
			2,  4,  5,  4, 2,
			4,  9, 12,  9, 4,
			5, 12, 15, 12, 5,
			4,  9, 12,  9, 4,
			2,  4,  5,  4, 2
		], 159);


		public static function apply(image:BitmapData, highThreshold:int = 64, lowThreshold:int = 32):void {
			image.applyFilter(image, image.rect, ZERO_POINT, MONO_FILTER);
			image.applyFilter(image, image.rect, ZERO_POINT, BLUR_FILTER);
			
			var pixels:ByteArray = image.getPixels(image.rect);
			pixels = _s3(pixels, image.width, image.height);
			pixels = _s4(pixels, image.width, image.height);			pixels = _s5(pixels, image.width, image.height, highThreshold, lowThreshold);
			image.setPixels(image.rect, pixels);
		}


		private static function _s3(org:ByteArray, width:int, height:int):ByteArray {
			var dst:ByteArray = new ByteArray();
			dst.length = org.length;
			var w:int = width;
			var ww:int = w * 4;
			var h:int = height;
			var idx:int = 0;
			for (var y:int = 1; y < h - 1; ++y) {
				for (var x:int = 1; x < w - 1; ++x) {
					idx = (y * w + x) * 4;
					dst[idx] = 0xff;
					idx += 3;
					var hs:Number = 0;
					hs -= org[idx - ww - 4];
					hs -= org[idx - 4] * 2;
					hs -= org[idx + ww - 4];
					hs += org[idx - ww + 4];
					hs += org[idx + 4] * 2;
					hs += org[idx + ww + 4];
					var vs:Number = 0;
					vs -= org[idx - ww - 4];
					vs -= org[idx - ww] * 2;
					vs -= org[idx - ww + 4];
					vs += org[idx + ww - 4];
					vs += org[idx + ww] * 2;
					vs += org[idx + ww + 4];
					var g:int = Math.sqrt(hs * hs + vs * vs);
					dst[idx] = g >> 1;
					dst[idx - 2] = int((Math.atan2(vs, hs) + Math.PI * 1.125) / (Math.PI * 0.25)) % 4;
				}
			}
			return dst;
		}
		
		
		private static function _s4(org:ByteArray, width:int, height:int):ByteArray {
			var dst:ByteArray = new ByteArray();
			dst.length = org.length;
			var w:int = width;
			var ww:int = w * 4;
			var h:int = height;
			var idx:int = 0;
			for (var y:int = 1; y < h - 1; ++y) {
				for (var x:int = 1; x < w - 1; ++x) {
					idx = (y * w + x) * 4 + 1;
					var a:int = org[idx];
					idx += 2;
					var g:int = org[idx];
					var g0:int, g1:int;
					switch (a) {
						case 0:
							g0 = org[idx - 4];
							g1 = org[idx + 4];
							break;
						case 1:
							g0 = org[idx - ww - 4];
							g1 = org[idx + ww + 4];
							break;
						case 2:
							g0 = org[idx - ww];
							g1 = org[idx + ww];
							break;
						case 3:
							g0 = org[idx - ww + 4];
							g1 = org[idx + ww - 4];
							break;
					}
					dst[idx - 3] = 0xff;
					if (g >= g0 && g >= g1) {
						dst[idx] = dst[idx - 1] = dst[idx - 2] = g;
					}
				}
			}
			return dst;
		}


		private static const dx:Array = [1, 1, 0, -1, -1, -1, 0, 1];
		private static const dy:Array = [0, 1, 1, 1, 0, -1, -1, -1];

		private static function _s5(org:ByteArray, width:int, height:int, high:int, low:int):ByteArray {
			var dst:ByteArray = new ByteArray();
			dst.length = org.length;
			var n:int = dst.length;
			var i:int;
			for (i = 0; i < n; i += 4) {
				dst[i] = 0xff;
			}
			var w:int = width;
			var ww:int = w * 4;
			var h:int = height;
			var idx:int = 0;
			var thh:int = high >> 1;
			var thl:int = low >> 1;
			for (var y:int = 1; y < h - 1; ++y) {
				for (var x:int = 1; x < w - 1; ++x) {
					idx = (y * w + x) * 4 + 3;
					if (org[idx] > thh) {
						org[idx] = 0;
						var track:Array = [idx];
						while (track.length) {
							i = track.pop();
							for (var d:int = 0; d < 8; ++d) {
								var ii:int = i + dx[d] * 4 + dy[d] * ww;
								if (org[ii] > thl) {
									org[ii] = 0;
									track.push(ii);
								}
							}
							dst[i] = dst[i - 1] = dst[i - 2] = dst[i - 3] = 0xff;
						}
					}
				}
			}
			return dst;
		}
	}
}
