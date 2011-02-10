package sh.saqoo.util {
	import sh.saqoo.geom.ZERO_POINT;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	
	public class BitmapDataUtil {
		
		
		public static function mirror(image:BitmapData):BitmapData {
			var mirrored:BitmapData = image.clone();
			var mtx:Matrix = new Matrix();
			mtx.scale(-1, 1);
			mtx.translate(image.width, 0);
			mirrored.draw(image, mtx);
			return mirrored;
		}

		
		public static function calcAverageColor(image:BitmapData, rect:Rectangle = null):uint {
			var hist:Vector.<Vector.<Number>> = image.histogram(rect);
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;
			var a:Number = 0;
			for (var i:int = 0; i < 256; ++i) {
				r += hist[0][i] * i;
				g += hist[1][i] * i;
				b += hist[2][i] * i;
				a += hist[3][i] * i;
			}
			var p:int = rect ? rect.width * rect.height : image.width * image.height;
			r /= p;
			g /= p;
			b /= p;
			a /= p;
			return (a << 24) | (r << 16) | (g << 8) | b;
		}

		
		public static function resize(source:BitmapData, target:*, smoothing:Boolean = true):BitmapData {
			var w:Number = 0;
			var h:Number = 0;
			var resized:BitmapData = null;
			if (target is BitmapData) {
				resized = BitmapData(target);
				w = resized.width;
				h = resized.height;
			} else if (target is Rectangle) {
				w = Rectangle(target).width;
				h = Rectangle(target).height;
				resized = new BitmapData(w, h);
			}
			
			if (w && h) {
				var s:Number = Math.max(w / source.width, h / source.height);
				var mtx:Matrix = new Matrix(s, 0, 0, s, (w - s * source.width) / 2, (h - s * source.height) / 2);
				resized.draw(source, mtx, null, null, null, smoothing);
			}
			
			return resized;
		}
		
		
		public static function breakApartHorizontal(orgbmp:BitmapData, ptnbmp:BitmapData, parent:Sprite = null):Sprite {
			if (!orgbmp.rect.equals(ptnbmp.rect)) {
				throw new ArgumentError('original and pattern must be same size!');
			}
			
			var h:int = orgbmp.height;
			var tmp:BitmapData = new BitmapData(1, h, true, 0x0);
			var copy:Rectangle = new Rectangle(0, 0, 1, h);
			var rect:Rectangle;
			var sp:Sprite = parent || new Sprite();
			var c:int = 0xffff0000;
			
			while (copy.x < ptnbmp.width) {
				tmp.copyPixels(ptnbmp, copy, ZERO_POINT);
				rect = tmp.getColorBoundsRect(0xffffff, 0x0, true);
				if (rect.height) {
					ptnbmp.floodFill(copy.x, rect.y, c);
					rect = ptnbmp.getColorBoundsRect(0xffffffff, c, true);
					rect.y = 0;
					rect.height = h;
					var ch:BitmapData = new BitmapData(rect.width, h, true, 0x0);
					ch.copyPixels(orgbmp, rect, ZERO_POINT);
					sp.addChild(new Bitmap(ch)).x = rect.x;
					copy.x = rect.left;
					c++;
				}
				copy.x++;
			}
			
			tmp.dispose();
			
			return sp;
		}


		public static function breakApartVertical(orgbmp:BitmapData, ptnbmp:BitmapData, parent:Sprite = null):Sprite {
			if (!orgbmp.rect.equals(ptnbmp.rect)) {
				throw new ArgumentError('original and pattern must be same size!');
			}
			
			var w:int = orgbmp.width;
			var tmp:BitmapData = new BitmapData(w, 1, true, 0x0);
			var copy:Rectangle = new Rectangle(0, 0, w, 1);
			var rect:Rectangle;
			var sp:Sprite = parent || new Sprite();
			var c:int = 0xffff0000;
			
			while (copy.y < ptnbmp.height) {
				tmp.copyPixels(ptnbmp, copy, ZERO_POINT);
				rect = tmp.getColorBoundsRect(0xffffff, 0x0, true);
				if (rect.width) {
					ptnbmp.floodFill(rect.x, copy.y, c);
					rect = ptnbmp.getColorBoundsRect(0xffffffff, c, true);
					rect.x = 0;
					rect.width = w;
					var ch:BitmapData = new BitmapData(w, rect.height, true, 0x0);
					ch.copyPixels(orgbmp, rect, ZERO_POINT);
					sp.addChild(new Bitmap(ch)).y = rect.y;
					copy.y = rect.bottom;
					c++;
				}
				copy.y++;
			}
			
			tmp.dispose();
			
			return sp;
		}
	}
}
