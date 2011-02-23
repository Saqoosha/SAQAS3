package sh.saqoo.imageprocessing {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	
	/**
	 * Hilditch's Thinning (Skeltonize)
	 * @author Saqoosha
	 * @see http://homepage3.nifty.com/hiroyuki-kobo/ip_trainer/skeletonize/1.htm
	 */
	public class Thinning {
		
		
		private static const WHITE:int = 255;
		
		private static const dx:Vector.<int> = Vector.<int>([1, 1, 0, -1, -1, -1, 0, 1]);
		private static const dy:Vector.<int> = Vector.<int>([0, -1, -1, -1, 0, 1, 1, 1]);
		private static const A:Vector.<Boolean> = new Vector.<Boolean>(8, true);

		
		/**
		 * Apply thinning filter. Using blue channel only.
		 * @return Black and white image.
		 */
		public static function apply(image:BitmapData):void {
			var w:int = image.width;
			var h:int = image.height;
			var i:int, n:int, x:int, y:int, idx:int;
			var U:Vector.<int> = new Vector.<int>(w * h, true);
			var V:Vector.<Boolean> = new Vector.<Boolean>(w * h, true);
			
			var pixels:ByteArray = image.getPixels(image.rect);
			n = w * h;
			for (i = 0; i < n; ++i) {
				U[i] = pixels[i * 4 + 3];
				V[i] = false;
			}
			do {
				var count:int = 0;
				for (y = 1; y < h - 1; y++) {
					for (x = 1; x < w - 1; x++) {
						idx = x + y * w;
						if (U[idx] != WHITE) continue;
						var nA:int = 0;
						for (i = 0; i < 8; i++) {
							A[i] = Boolean(U[x + dx[i] + (y + dy[i]) * w]);
							if (A[i]) nA++;
						}
						if (nA <= 1 || nA >= 7) continue;
						if (CountCn() != 1) continue;
						if (V[x + dx[2] + (y + dy[2]) * w] && (CountCn2(2) != 1)) continue;
						if (V[x + dx[4] + (y + dy[4]) * w] && (CountCn2(4) != 1)) continue;
						V[idx] = true;
						count++;
					}
				}
				for (i = 0; i < n; ++i) {
					if (V[i]) {
						U[i] = 0;
						V[i] = false;
					}
				}
			} while (count);
			
			for (i = 0; i < n; ++i) {
				idx = i * 4;
				pixels[idx++] = 0xff;
				pixels[idx++] = U[i];
				pixels[idx++] = U[i];
				pixels[idx++] = U[i];
			}
			
			pixels.position = 0;
			image.setPixels(image.rect, pixels);
		}

		
		private static function CountCn():int {
			var cn_num:int = 0;
			if (!A[0] && (A[1] || A[2])) cn_num++;
			if (!A[2] && (A[3] || A[4])) cn_num++;
			if (!A[4] && (A[5] || A[6])) cn_num++;
			if (!A[6] && (A[7] || A[0])) cn_num++;
			return cn_num;
		}
		
		
		private static function CountCn2(n:int):int {
			var tmp:Boolean = A[n];
			A[n] = false;
			var cn_num:int = CountCn();
			A[n] = tmp;
			return cn_num;
		}
		
		
		/**
		 * Extract chain of points from skeltonized image.
		 */
		public static function extractPointChains(image:BitmapData):Vector.<Vector.<Point>> {
			var chains:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
			var pixels:ByteArray = image.getPixels(image.rect);
			var width:int = image.width;
			var height:int = image.height;
			var idx:int, idx2:int;
			var x:int, y:int, i:int;
			
			// set black to 1px border around image.
			for (x = 0; x < width; x++) {
				idx = x * 4 + 1;
				pixels[idx++] = 0;
				pixels[idx++] = 0;
				pixels[idx++] = 0;
				idx = ((height - 1) * width + x) * 4 + 1;
				pixels[idx++] = 0;
				pixels[idx++] = 0;
				pixels[idx++] = 0;
			}
			for (y = 0; y < height; y++) {
				idx = y * width * 4 + 1;
				pixels[idx++] = 0;
				pixels[idx++] = 0;
				pixels[idx++] = 0;
				idx += (width - 1) * 4;
				pixels[idx++] = 0;
				pixels[idx++] = 0;
				pixels[idx++] = 0;
			}
			
			var w1:int = width - 1;
			var h1:int = height - 1;
			for (y = 1; y < h1; y++) {
				for (x = 1; x < w1; x++) {
					idx = (y * width + x) * 4 + 3; // blue channel
					if (pixels[idx] != WHITE) continue; // non-line pixel or already labeled.
					
					pixels[idx - 2] = 0;
					pixels[idx - 1] = 0;
					pixels[idx - 0] = 0;
					
					const dx:Vector.<int> = Vector.<int>([1, 1, 0, -1, -1, -1, 0, 1]);
					const dy:Vector.<int> = Vector.<int>([0, 1, 1, 1, 0, -1, -1, -1]);
					const dd:Vector.<uint> = Vector.<uint>([0, 3, 6, 1, 4, 7, 2, 5]);
					var dir:int = 0;
					var d:int;
					var target:Vector.<int> = new Vector.<int>();
					for (i = 0; i < 8; i++) {
						d = dd[i];
						idx2 = idx + (dx[d] + dy[d] * width) * 4;
						if (pixels[idx2] == WHITE) {
							target.push(d);
							if (target.length == 2) {
								break;
							}
						}
					}
					
					if (target.length > 0) {
						var points:Vector.<Point> = new Vector.<Point>();
						points.push(new Point(x, y));
	
						for each (dir in target) {
							idx = (y * width + x) * 4 + 3;
							var xx:int = x;
							var yy:int = y;
							var foundNext:Boolean;
							do {
								foundNext = false;
								for (i = 0; i < 8; i++) {
									d = (dir + i) & 7;
									idx2 = idx + (dx[d] + dy[d] * width) * 4;
									if (pixels[idx2] == 0xff) {
										pixels[idx2 - 2] = 0;
										pixels[idx2 - 1] = 0;
										pixels[idx2 - 0] = 0;
										dir = d;
										idx = idx2;
										xx += dx[d];
										yy += dy[d];
										points.push(new Point(xx, yy));
										foundNext = true;
										break;
									}
								}
							} while (foundNext);
							if (target.length == 2) {
								points.reverse();
							}
						}
						if (points.length > 1) {
							chains.push(points);
						}
					}
				}
			}
			
			return chains;
		}
	}
}
