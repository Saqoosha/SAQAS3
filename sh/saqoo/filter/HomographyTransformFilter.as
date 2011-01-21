package sh.saqoo.filter {
	import sh.saqoo.geom.ZERO_POINT;

	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;

	
	public class HomographyTransformFilter extends ShaderFilter {
		
		[Embed(source='assets/homography.pbj', mimeType='application/octet-stream')]
		private static const ShaderByteClass:Class;
		
		
		public static function extract(target:BitmapData, source:BitmapData, points:Vector.<Point>):void {
			var filt:HomographyTransformFilter = new HomographyTransformFilter(target.width, target.height, points);
			target.applyFilter(source, target.rect, ZERO_POINT, filt);
		}
		
		
		
		private var _shader:Shader;
		
		public var p0:Point;
		public var p1:Point;
		public var p2:Point;
		public var p3:Point;
		
		
		public function HomographyTransformFilter(outWidth:int, outHeight:int, points:Vector.<Point>) {
			_shader = new Shader(new ShaderByteClass());
			this.outWidth = outWidth;
			this.outHeight = outHeight;
			this.p0 = points[0];
			this.p1 = points[1];
			this.p2 = points[2];
			this.p3 = points[3];
			recalcParam();
			super(_shader);
		}
		
		public function recalcParam():void {
			var sx:Number = (p0.x - p1.x) + (p2.x - p3.x);
			var sy:Number = (p0.y - p1.y) + (p2.y - p3.y);
			var dx1:Number = p1.x - p2.x;
			var dx2:Number = p3.x - p2.x;
			var dy1:Number = p1.y - p2.y;
			var dy2:Number = p3.y - p2.y;
			var z:Number = (dx1 * dy2) - (dy1 * dx2);
			var g:Number = ((sx * dy2) - (sy * dx2)) / z;
			var h:Number = ((sy * dx1) - (sx * dy1)) / z;
			_shader.data.A.value = [p1.x - p0.x + g * p1.x];
			_shader.data.B.value = [p3.x - p0.x + h * p3.x];
			_shader.data.C.value = [p0.x];
			_shader.data.D.value = [p1.y - p0.y + g * p1.y];
			_shader.data.E.value = [p3.y - p0.y + h * p3.y];
			_shader.data.F.value = [p0.y];
			_shader.data.G.value = [g];
			_shader.data.H.value = [h];
		}
		
		public function get outWidth():int {
			return _shader.data.outWidth.value[0];
		}
		public function set outWidth(value:int):void {
			_shader.data.outWidth.value = [value];
		}
		
		public function get outHeight():int {
			return _shader.data.outHeight.value[0];
		}
		public function set outHeight(value:int):void {
			_shader.data.outHeight.value = [value];
		}
	}
}