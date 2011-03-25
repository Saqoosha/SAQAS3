package sh.saqoo.util {

	import sh.saqoo.filter.ColorMatrixFilterFactory;
	import sh.saqoo.geom.ZERO_POINT;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
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
		
		
		public static function mono(image:BitmapData):void {
			image.applyFilter(image, image.rect, ZERO_POINT, ColorMatrixFilterFactory.luma());
		}


		internal static function _getMinMax(hist:Vector.<Number>):Object {
			var min:int = 0;
			var max:int = 255;
			var i:int;
			for (i = 0; i < 256; i++) {
				min = i;
				if (hist[i]) break;
			}
			for (i = 255; i >= 0; i--) {
				max = i;
				if (hist[i]) break;
			}
			return {min: min, max: max};
		}


		public static function stretchHistogram(image:BitmapData):void {
			var hist:Vector.<Vector.<Number>> = image.histogram();
			var r:Object = _getMinMax(hist[0]);
			var rs:Number = 255 / (r.max - r.min);
			var g:Object = _getMinMax(hist[1]);
			var gs:Number = 255 / (g.max - g.min);
			var b:Object = _getMinMax(hist[2]);
			var bs:Number = 255 / (b.max - b.min);
			image.applyFilter(image, image.rect, ZERO_POINT, new ColorMatrixFilter([
				rs,  0,  0, 0, -r.min * rs,
				 0, gs,  0, 0, -g.min * gs,
				 0,  0, bs, 0, -b.min * bs,
				 0,  0,  0, 1, 0
			]));
			return;
		}
		
		
		public static function equalizeHistogram(image:BitmapData):void {
			var hist:Vector.<Vector.<Number>> = image.histogram();
			var v:Object = _getMinMax(hist[0]);
			var cfd:Array = [];
			var sum:int = 0;
			var i:int;
			for (i = 0; i < 256; i++) {
				sum += hist[0][i];
				cfd.push(sum);
			}
			var lut:Array = new Array(256);
			var alpha:Array = new Array(256);
			var size:int = image.width * image.height;
			for (i = 0; i < 256; i++) {
				if (v.min <= i && i <= v.max) {
					var l:int = Math.round((cfd[i] - cfd[0]) / (size - cfd[0]) * 255);
					lut[i] = l << 16 | l << 8 | l | 0xff000000;
				} else {
					lut[i] = 0;
				}
				alpha[i] = 255;
			}
			var org:BitmapData = image.clone();
			image.fillRect(image.rect, 0x0);
			image.paletteMap(org, image.rect, ZERO_POINT, lut, [], []);
		}


		/**
		 * Binarize image with threshold. Only blue channel is used in thresholding.
		 */
		public static function binarize(image:BitmapData, threshold:int, inverted:Boolean = false, target:BitmapData = null):void {
			var source:BitmapData = image;
			var white:String = '>';
			var black:String = '<=';
			if (inverted) {
				source = image.clone();
				white = '<=';
				black = '>';
			}
			target ||= image;
			target.threshold(source, source.rect, ZERO_POINT, white, threshold, 0xffffffff, 0x000000ff);
			target.threshold(source, source.rect, ZERO_POINT, black, threshold, 0xff000000, 0x000000ff);
		}


		public static function resize(source:BitmapData, target:*, smoothing:Boolean = true):BitmapData {
			var w:Number = 0;
			var h:Number = 0;
			var resized:BitmapData = null;
			switch (true) {
				case target is BitmapData:
					resized = BitmapData(target);
					w = resized.width;
					h = resized.height;
					break;
				case target is Point:
					w = target.x;
					h = target.y;
					resized = new BitmapData(w, h, source.transparent, 0x00000000);
					break;
				case target is Rectangle:
					w = Rectangle(target).width;
					h = Rectangle(target).height;
					resized = new BitmapData(w, h, source.transparent, 0x00000000);
					break;
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
