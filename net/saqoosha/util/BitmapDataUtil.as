package net.saqoosha.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	public class BitmapDataUtil {
		
		
		private static const ZERO_POINT:Point = new Point(0, 0);
		
		
		public static function resize(source:BitmapData, target:*, smoothing:Boolean = true, quality:String = 'best'):BitmapData {
			var q:String;
			if (StageReference.stage) {
				q = StageReference.stage.quality;
				StageReference.stage.quality = quality;
			}
			
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
			
			if (StageReference.stage) {
				StageReference.stage.quality = q;
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
			var h:int = orgbmp.height;
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
