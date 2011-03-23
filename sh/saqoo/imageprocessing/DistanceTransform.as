package sh.saqoo.imageprocessing {

	import flash.display.BitmapData;
	
	/**
	 * @author Saqoosha
	 * @see http://people.cs.uchicago.edu/~pff/dt/
	 */
	public class DistanceTransform {
		
		
		private static const MAX_DISTANCE:Number = 1e20;
		
		
		private var _width:int;
		private var _height:int;
		private var _maxDistance:Number;
		private var _distanceMap:Vector.<Number>;
		
		
		public function DistanceTransform():void {
		}


		public function apply(image:BitmapData):Vector.<Number> {
			_distanceMap = new Vector.<Number>();
			var pixels:Vector.<uint> = image.getVector(image.rect);
			_width = image.width;
			_height = image.height;
			var n:int = _width * _height;
			for (var i:int = 0; i < n; i++) {
				_distanceMap[i] = (pixels[i] & 0xff) < 128 ? 0 : MAX_DISTANCE;
			}
			_maxDistance = _dt2d(_distanceMap, image.width, image.height);
			_maxDistance = Math.sqrt(_maxDistance);
			return _distanceMap;
		}
		
		
		public function getNormalizedDistanceImage(target:BitmapData = null):BitmapData {
			if (!target) target = new BitmapData(_width, _height);
			var pixels:Vector.<uint> = new Vector.<uint>();
			var n:int = _width * _height;
			for (var i:int = 0; i < n; i++) {
				var c:int = Math.sqrt(_distanceMap[i]) / _maxDistance * 255;
				c = c > 255 ? 255 : c;
				pixels[i] = c << 16 | c << 8 | c | 0xff000000;
			}
			target.setVector(target.rect, pixels);
			return target;
		}
		
		
		private function _dt2d(f:Vector.<Number>, width:int, height:int):Number {
			var i:int;
			var d:Number, max:Number = 0;
			for (i = 0; i < height; i++) {
				_dt1d(f, width, i * width);
			}
			for (i = 0; i < width; i++) {
				d = _dt1d(f, height, i, width);
				if (max < d && d < MAX_DISTANCE) max = d;
			}
			return max;
		}
		
		
		private function _dt1d(f:Vector.<Number>, size:int, offset:int = 0, interval:int = 1):Number {
			var d:Vector.<Number> = new Vector.<Number>(size, true);
			var v:Vector.<int> = new Vector.<int>(size, true);
			var z:Vector.<Number> = new Vector.<Number>(size + 1, true);
			var k:int = 0;
			var s:Number;
			v[0] = 0;
			z[0] = -MAX_DISTANCE;
			z[1] = MAX_DISTANCE;
			for (var q:int = 1; q < size; q++) {
				while ((s = ((f[q * interval + offset] + q * q) - (f[v[k] * interval + offset] + v[k] * v[k])) / (2 * q - 2 * v[k])) <= z[k]) k--;
				k++;
				v[k] = q;
				z[k] = s;
				z[k + 1] = Number.MAX_VALUE;
			}
			k = 0;
			for (q = 0; q < size; q++) {
				while (z[k + 1] < q) k++;
				var r:Number = q - v[k];
				d[q] = r * r + f[v[k] * interval + offset];
			}
			var max:Number = 0;
			for (var i:int = 0; i < size; i++) {
				f[i * interval + offset] = d[i];
				if (max < d[i]) max = d[i];
			}
			return max;
		}
		
		
		public function get width():int { return _width; }
		public function get height():int { return _height; }
		public function get maxDistance():Number { return _maxDistance; }
		public function get distanceMap():Vector.<Number> { return _distanceMap; }
	}
}
