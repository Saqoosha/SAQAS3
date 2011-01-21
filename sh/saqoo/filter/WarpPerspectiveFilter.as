package sh.saqoo.filter {
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;

	
	public class WarpPerspectiveFilter extends ShaderFilter {
		
		
		[Embed(source='assets/warpPerspective.pbj', mimeType='application/octet-stream')]
		private static const ShaderByteClass:Class;
		
		
		public static function warp(source:BitmapData, points:Vector.<Point>, target:BitmapData):BitmapData {
			var warp:WarpPerspectiveFilter = new WarpPerspectiveFilter(source.width, source.height, points);
			var shader:Shader = warp.shader;
			shader.data.source.input = source;
			shader.data.srcWidth.value = [source.width];
			shader.data.srcHeight.value = [source.height];
			var sh:Shape = new Shape();
			sh.graphics.beginShaderFill(warp.shader);
			sh.graphics.drawRect(0, 0, target.width, target.height);
			sh.graphics.endFill();
			target.draw(sh);
			return target;
		}
		
		
		private var _shader:Shader;
		
		public var p0:Point;
		public var p1:Point;
		public var p2:Point;
		public var p3:Point;
		
		
		public function WarpPerspectiveFilter(srcWidth:int, srcHeight:int, points:Vector.<Point>) {
			_shader = new Shader(new ShaderByteClass());
			this.srcWidth = srcWidth;
			this.srcHeight = srcHeight;
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

			var a11:Number = p1.x - p0.x + g * p1.x;
			var a12:Number = p3.x - p0.x + h * p3.x;
			var a13:Number = p0.x;
			var a21:Number = p1.y - p0.y + g * p1.y;
			var a22:Number = p3.y - p0.y + h * p3.y;
			var a23:Number = p0.y;
			var a31:Number = g;
			var a32:Number = h;
			var a33:Number = 1;
			
			var det:Number = a11 * a22 * a33  +  a21 * a32 * a13  +  a31 * a12 * a23  -  a11 * a32 * a23  -  a31 * a22 * a13  -  a21 * a12 * a33;
			
			_shader.data.A.value = [(a22 * a33 - a23 * a32) / det];
			_shader.data.B.value = [(a13 * a32 - a12 * a33) / det];
			_shader.data.C.value = [(a12 * a23 - a13 * a22) / det];
			_shader.data.D.value = [(a23 * a31 - a21 * a33) / det];
			_shader.data.E.value = [(a11 * a33 - a13 * a31) / det];
			_shader.data.F.value = [(a13 * a21 - a11 * a23) / det];
			_shader.data.G.value = [(a21 * a32 - a22 * a31) / det];
			_shader.data.H.value = [(a12 * a31 - a11 * a32) / det];
			_shader.data.I.value = [(a11 * a22 - a12 * a21) / det];
		}
		
		
		public function get srcWidth():int {
			return _shader.data.srcWidth.value[0];
		}
		
		
		public function set srcWidth(value:int):void {
			_shader.data.srcWidth.value = [value];
		}
		
		
		public function get srcHeight():int {
			return _shader.data.srcHeight.value[0];
		}
		
		
		public function set srcHeight(value:int):void {
			_shader.data.srcHeight.value = [value];
		}
	}
}
