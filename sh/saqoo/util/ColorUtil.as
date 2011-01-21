package sh.saqoo.util {
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	
	public class ColorUtil {
		
		
		/**
		 * Convert HSV color to RGB color int
		 * @param h	Hue (0-360)
		 * @param s	Satuation (0-1)
		 * @param	v	Value (0-1)
		 * @return	int
		 */
		public static function intFromHSV(h:Number, s:Number, v:Number):int {
			var r:Number, g:Number, b:Number;
			const i:Number = Math.floor((h / 60) % 6);
			const f:Number = (h / 60) - i;
			const p:Number = v * (1 - s);
			const q:Number = v * (1 - f * s);
			const t:Number = v * (1 - (1 - f) * s);
			switch(i) {
				case 0: r=v; g=t; b=p; break;
				case 1: r=q; g=v; b=p; break;
				case 2: r=p; g=v; b=t; break;
				case 3: r=p; g=q; b=v; break;
				case 4: r=t; g=p; b=v; break;
				case 5: r=v; g=p; b=q; break;
			}
			return (int(r * 0xff) << 16) | (int(g * 0xff) << 8) | int(b * 0xff);
		}
		
		
		/**
		 * Adjust contrast
		 * @param color	Color value (int)
		 * @param contrast	Contrast (-1 to 1)
		 * @return	int
		 */
		public static function adjustContrast(color:int, contrast:Number):int {
			var r:Number = (color >> 16) & 0xff;
			var g:Number = (color >> 8) & 0xff;
			var b:Number = color & 0xff;
			var c:Number = 1 + contrast;
			var o:Number = 127 * -contrast;
			r = (r * c + o) << 0;
			g = (g * c + o) << 0;
			b = (b * c + o) << 0;
			return (r << 16) | (g << 8) | b;
		}
	
	
		/**
		 * Convert HSV color to RGB color
		 * @param h	Hue (0-360)
		 * @param s	Satuation (0-1)
		 * @param	v	Value (0-1)
		 * @return	RGB color object
		 */
		public static function hsv2rgb(h:Number, s:Number, v:Number):Object { 
			var r:Number, g:Number, b:Number;
			
			var i:Number = Math.floor((h/60)%6);
			var f:Number = (h/60)-i;
			var p:Number = v*(1-s);
			var q:Number = v*(1-f*s);
			var t:Number = v*(1-(1-f)*s);
			
			switch(i) {
				case 0: r=v; g=t; b=p; break;
				case 1: r=q; g=v; b=p; break;
				case 2: r=p; g=v; b=t; break;
				case 3: r=p; g=q; b=v; break;
				case 4: r=t; g=p; b=v; break;
				case 5: r=v; g=p; b=q; break;
			}
			
			return { r:Math.round(r*255), g:Math.round(g*255), b:Math.round(b*255) };
		}


//		/**
//		 * Convert RGB color to HSV color
//		 * @param r	Red (0-255)
//		 * @param g	Green (0-255)
//		 * @param	b	Blue (0-255)
//		 * @return	HSV color object
//		 */
//		public static function rgb2hsv(red:Number, green:Number, blue:Number):Object {
//			var hsvArr = new Array();
//			red = red / 255;
//			green = green / 255;
//			blue = blue / 255;
//			
//			var myMax:Number = Math.max(red, Math.max(green, blue));
//			var myMin:Number = Math.min(red, Math.min(green, blue));
//			var v:Number = myMax;
//			var s:Number;
//			var h:Number;
//			if (myMax > 0) {
//				s = (myMax - myMin) / myMax;
//			}
//			else {
//				s = 0;
//			}
//			if (s > 0) {
//				var myDiff:Number = myMax - myMin;
//				var rc:Number = (myMax - red) / myDiff;
//				var gc:Number = (myMax - green) / myDiff;
//				var bc:Number = (myMax - blue) / myDiff;
//				if (red == myMax) {
//					h = (bc - gc) / 6;
//				}
//				if (green == myMax) {
//					h = (2 + rc - bc) / 6;
//				}
//				if (blue == myMax) {
//					h = (4 + gc - rc) / 6;
//				}
//			}
//			else {
//				h = 0;
//			}
//			if (h < 0) {
//				h += 1;
//			}
//			return { h:Math.round(h * 360), s:s, v:v};
//		}
//		
//		public static function RGBNumber2HSV(col:Number):Object {
//			return ColorUtil.rgb2hsv(col >> 16 & 0xff, col >> 8 & 0xff, col & 0xff);
//		}
//		
//		public static function HSV2RGBNumber(h:Number, s:Number, v:Number):Number {
//			var rgb:Object = ColorUtil.hsv2rgb(h, s, v);
//			return rgb.r << 16 | rgb.g << 8 | rgb.b;
//		}
//		
//		public static function blendRGBNumber(c1:Number, c2:Number, ratio:Number):Number {
//			var rt1:Number = (typeof(ratio) == 'number') ? Math.max(0, Math.min(1.0, ratio)) : 0.5;
//			var rt2:Number = (1.0 - rt1);
//			var r:Number = Math.floor((c1 >> 16 & 0xff) * rt1 + (c2 >> 16 & 0xff) * rt2);
//			var g:Number = Math.floor((c1 >> 8 & 0xff) * rt1 + (c2 >> 8 & 0xff) * rt2);
//			var b:Number = Math.floor((c1 & 0xff) * rt1 + (c2 & 0xff) * rt2);
//			return r << 16 | g << 8 | b;
//		}
//		
//	//	public static function RGB2Number(r:Number, g:Number, b:Number):Number {
//	//		return r << 16 | g << 8 | b;
//	//	}
//		
//		public static function randomHSV2number(hmin:Number, hmax:Number, smin:Number, smax:Number, vmin:Number, vmax:Number):Number {
//			var rgb:Object = ColorUtil.hsv2rgb(hmin + (hmax - hmin) * Math.random(), smin + (smax - smin) * Math.random(), vmin + (vmax - vmin) * Math.random());
//			return rgb.r << 16 | rgb.g << 8 | rgb.b;
//		}
//		
//		public static function randomHSVVariation(rgb:Number, rangeH:Number, rangeS:Number, rangeV:Number):Number {
//			var hsv:Object = ColorUtil.RGBNumber2HSV(rgb);
//			if (rangeH) {
//				hsv.h = (hsv.h + Math.random() * rangeH + 360) % 360;
//			}
//			if (rangeS) {
//				hsv.s = Math.max(0, Math.min(1, hsv.s + Math.random() * rangeS));
//			}
//			if (rangeV) {
//				hsv.v = Math.max(0, Math.min(1, hsv.v + Math.random() * rangeV));
//			}
//			return ColorUtil.HSV2RGBNumber(hsv.h, hsv.s, hsv.v);
//		}
		
		
		public static function blendColors(...colors):int {
			var n:int = colors.length;
			var r:int = 0;
			var g:int = 0;
			var b:int = 0;
			for (var i:int = 0; i < n; i++) {
				var c:int = colors[i];
				r += (c >> 16) & 0xff;
				g += (c >> 8) & 0xff;
				b += c & 0xff;
			}
			r /= n;
			g /= n;
			b /= n;
			return ((r << 16) & 0xff0000) | ((g << 8) & 0x00ff00) | (b & 0x0000ff);
		}


		public static function tint(obj:DisplayObject, color:uint):void {
			obj.transform.colorTransform = new ColorTransform(0, 0, 0, 1, (color >> 16) & 0xff, (color >> 8) & 0xff, color & 0xff, 0);
		}
	}
}
