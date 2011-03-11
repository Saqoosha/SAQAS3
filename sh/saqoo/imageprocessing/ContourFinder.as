package sh.saqoo.imageprocessing {

	import sh.saqoo.geom.Blob;

	import flash.display.BitmapData;
	import flash.geom.Point;


	/**
	 * @author Saqoosha
	 */
	public class ContourFinder {


		private static const OUTER_CONTOUR:int = 0x00ff00;
		private static const INNER_CONTOUR:int = 0xff0000;


		public static function find(image:BitmapData, foreground:uint = 0xffffff, background:uint = 0x000000):Vector.<Blob> {
			var blobs:Vector.<Blob> = new Vector.<Blob>();
			const dx:Array = [1, 1, 0, -1, -1, -1, 0, 1];
			const dy:Array = [0, 1, 1, 1, 0, -1, -1, -1];
			var dir:int = 0;
			var x:int, y:int, xx:int, yy:int, sx:int, sy:int;
			var w:int = image.width;
			var w1:int = w - 1;
			var h:int = image.height;
			var h1:int = h - 1;
			for (x = 0; x < w; x++) {
				image.setPixel(x, 0, background);
				image.setPixel(x, h1, background);
			}
			for (y = 0; y < h; y++) {
				image.setPixel(0, y, background);
				image.setPixel(w1, y, background);
			}
			for (y = 1; y < h1; y++) {
				for (x = 1; x < w1; x++) {
					if (image.getPixel(x, y) == foreground) {
						var s:int;
						var c:int;
						if (image.getPixel(x - 1, y) == background) {
							s = 1;
							c = OUTER_CONTOUR;
							dir = 3;
						} else if (image.getPixel(x + 1, y) == background) {
							s = -1;
							c = INNER_CONTOUR;
							dir = 0;
						} else {
							continue;
						}
						var points:Vector.<Point> = new Vector.<Point>();
						points.push(new Point(x, y));
						sx = xx = x;
						sy = yy = y;
						image.setPixel(x, y, c);
						do {
							for (var i:int = 0; i < 8; i++) {
								var d:int = (dir + 8 - i * s) % 8;
								if (image.getPixel(xx + dx[d], yy + dy[d]) != background) {
									xx += dx[d];
									yy += dy[d];
									image.setPixel(xx, yy, c);
									points.push(new Point(xx, yy));
									dir = (d + 8 + 3 * s) % 8;
									break;
								}
							}
						} while (xx != sx || yy != sy);
						if (points.length > 2) {
							var blob:Blob = new Blob(points, c == INNER_CONTOUR);
							blobs.push(blob);
						}
					}
				}
			}
			return blobs;
		}
	}
}
