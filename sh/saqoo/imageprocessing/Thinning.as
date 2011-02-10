package sh.saqoo.imageprocessing {
	import flash.display.BitmapData;
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
		public static function apply(image:BitmapData):BitmapData {
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
			return image;
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
	}
}
