package sh.saqoo.imageprocessing {

	import flash.display.BitmapData;

	/**
	 * @author Saqoosha
	 */
	public class Skeletonize {


		private static const L_STRONG:int = 4;
		private static const L_GOOD:int = 2;
		private static const L_WEAK:int = 1;
		private static const L_NONE:int = 0;


		public static function apply(distanceMap:Vector.<Number>, width:int, height:int):BitmapData {
			var w:int = width;
			var h:int = height;
			var Sx:Vector.<int> = new Vector.<int>(w * h);
			var Sy:Vector.<int> = new Vector.<int>(w * h);
			var i:int;
			var x:int, y:int;
			for (y = 0; y < h - 1; y++) {
				for (x = 0; x < w - 1; x++) {
					i = y * w + x;
					Sx[i] = distanceMap[i + 1] - distanceMap[i];
					Sy[i] = distanceMap[i + w] - distanceMap[i];
				}
			}
			var image:BitmapData = new BitmapData(width, height, false, 0x000000);
			var lx:int, ly:int;
			for (y = 1; y < h - 1; y++) {
				for (x = 1; x < w - 1; x++) {
					i = y * w + x;
					lx = L_NONE;
					if (Sx[i - 1] > 0) {
						if (Sx[i] < 0) {
							lx = L_STRONG;
						} else if (Sx[i] == 0) {
							if (Sx[i + 1] < 0) {
								lx = L_STRONG;
							} else {
								lx = L_WEAK;
							}
						}
					} else if (Sx[i - 1] == 0) {
						if (Sx[i] < 0) {
							lx = L_WEAK;
						}
					}
					ly = L_NONE;
					if (Sy[i - w] > 0) {
						if (Sy[i] < 0) {
							ly = L_STRONG;
						} else if (Sy[i] == 0) {
							if (Sy[i + w] < 0) {
								ly = L_STRONG;
							} else {
								ly = L_WEAK;
							}
						}
					} else if (Sy[i - w] == 0) {
						if (Sy[i] < 0) {
							ly = L_WEAK;
						}
					}
					if (lx + ly >= L_STRONG) {
						image.setPixel(x, y, 0xffffff);
					}
				}
			}
			
			for (y = 1; y < h - 1; y++) {
				for (x = 1; x < w - 1; x++) {
					if (image.getPixel(x, y) == 0) {
						var s:int = 0;
						s |= int(!!image.getPixel(x + 1, y    ));
						s |= int(!!image.getPixel(x + 1, y + 1)) << 1;
						s |= int(!!image.getPixel(x    , y + 1)) << 2;
						s |= int(!!image.getPixel(x - 1, y + 1)) << 3;
						s |= int(!!image.getPixel(x - 1, y    )) << 4;
						s |= int(!!image.getPixel(x - 1, y - 1)) << 5;
						s |= int(!!image.getPixel(x    , y - 1)) << 6;
						s |= int(!!image.getPixel(x + 1, y - 1)) << 7;
						if (s == 0x11 || s == 0x22 || s == 0x44 || s == 0x88) {
							image.setPixel(x, y, 0xffffff);
						}
					}
				}
			}
			
			return image;
		}
	}
}
