package sh.saqoo.imageprocessing {

	import flash.display.BitmapData;

	/**
	 * @author Saqoosha
	 */
	public class Skeletonize {


		private static const STRONG_RIDGE:int = 3;
		private static const GOOD_RIDGE:int = 2;
		private static const WEAK_RIDGE:int = 1;
		private static const NONE:int = 0;
		
		
		private static const CONNECT_CONDS:Array = [0x11, 0x22, 0x44, 0x88, 0x09, 0x12, 0x24, 0x48, 0x90, 0x21, 0x42, 0x84];


		public static function apply(distanceMap:Vector.<Number>, width:int, height:int, minDistance:Number = 0):BitmapData {
			var w:int = width;
			var h:int = height;
			var Sx:Vector.<Number> = new Vector.<Number>(w * h);
			var Sy:Vector.<Number> = new Vector.<Number>(w * h);
			var i:int;
			var x:int, y:int;
			for (y = 0; y < h - 1; y++) {
				for (x = 0; x < w - 1; x++) {
					i = y * w + x;
					Sx[i] = distanceMap[i + 1] - distanceMap[i];
					Sy[i] = distanceMap[i + w] - distanceMap[i];
				}
			}
			var image:BitmapData = new BitmapData(width, height, true, 0xff000000);
			var lx:int, ly:int;
			for (y = 1; y < h - 1; y++) {
				for (x = 1; x < w - 1; x++) {
					i = y * w + x;
					lx = NONE;
					if (Sx[i - 1] > 0) {
						if (Sx[i] < 0) { // +-
							lx = STRONG_RIDGE;
						} else if (Sx[i] == 0) {
							if (Sx[i + 1] < 0) { // +o-
								lx = STRONG_RIDGE;
							} else { // +o
								lx = WEAK_RIDGE;
							}
						}
					} else if (Sx[i - 1] == 0) {
						if (Sx[i] < 0) { // o-
							lx = WEAK_RIDGE;
						}
					}
					ly = NONE;
					if (Sy[i - w] > 0) {
						if (Sy[i] < 0) {
							ly = STRONG_RIDGE;
						} else if (Sy[i] == 0) {
							if (Sy[i + w] < 0) {
								ly = STRONG_RIDGE;
							} else {
								ly = WEAK_RIDGE;
							}
						}
					} else if (Sy[i - w] == 0) {
						if (Sy[i] < 0) {
							ly = WEAK_RIDGE;
						}
					}
					if (lx + ly >= GOOD_RIDGE && distanceMap[i] > minDistance) {
//					if (lx == L_STRONG || ly == L_STRONG) {
						image.setPixel(x, y, 0xffffffff);
//					} else if (lx == L_WEAK || ly == L_WEAK) {
//						image.setPixel(x, y, 0x333333);
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
//						if (s == 0x11 || s == 0x22 || s == 0x44 || s == 0x88) {
						if (CONNECT_CONDS.indexOf(s) != -1) {
							image.setPixel(x, y, 0xffffffff);
						}
					}
				}
			}
			
			return image;
		}
	}
}
