package sh.saqoo.starling {

	import starling.display.DisplayObjectContainer;
	import starling.textures.SubTexture;
	import starling.textures.Texture;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author Saqoosha
	 */
	public class QuadWarp extends DisplayObjectContainer {
		
		
		private var _numGrid:int;
		private var _subImages:Vector.<DeformableImage> = new Vector.<DeformableImage>();
		
		
		public function QuadWarp(texture:Texture, numGrid:int = 8) {
			_numGrid = numGrid;
			var frame:Rectangle = texture.frame;
            var width:Number  = frame ? frame.width  : texture.width;
            var height:Number = frame ? frame.height : texture.height;
			var r:Rectangle = new Rectangle(0, 0, width / numGrid, height / numGrid);
			for (var y:int = 0; y < numGrid; y++) {
				r.y = r.height * y;
				for (var x:int = 0; x < numGrid; x++) {
					r.x = r.width * x;
					var img:DeformableImage = new DeformableImage(new SubTexture(texture, r));
					addChild(img);
					_subImages.push(img);
				}
			}
			warp(new Point(), new Point(width + 200, -200), new Point(width, height), new Point(0, height));
		}
		
		
		public function warp(p0:Point, p1:Point, p2:Point, p3:Point):void {
			var system:Vector.<Number> = _calcSystem(p0, p1, p2, p3);
			var p:Point = new Point();
			for (var y:int = 0; y <= _numGrid; y++) {
				for (var x:int = 0; x <= _numGrid; x++) {
					_invert(x / _numGrid, y / _numGrid, system, p);
					if (x < _numGrid) {
						if (y < _numGrid) _subImages[y * _numGrid + x].setPosition(0, p.x, p.y);
						if (y > 0) _subImages[(y - 1) * _numGrid + x].setPosition(2, p.x, p.y);
					}
					if (x > 0) {
						if (y < _numGrid) _subImages[y * _numGrid + x - 1].setPosition(1, p.x, p.y);
						if (y > 0) _subImages[(y - 1) * _numGrid + x - 1].setPosition(3, p.x, p.y);
					}
				}
			}
		}
		
		
		private function _calcSystem(p0:Point, p1:Point, p2:Point, p3:Point):Vector.<Number> {
			var system:Vector.<Number> = new Vector.<Number>();
			var sx:Number = (p0.x - p1.x) + (p2.x - p3.x);
			var sy:Number = (p0.y - p1.y) + (p2.y - p3.y);

			var dx1:Number = p1.x - p2.x;
			var dx2:Number = p3.x - p2.x;
			var dy1:Number = p1.y - p2.y;
			var dy2:Number = p3.y - p2.y;

			var z:Number = (dx1 * dy2) - (dy1 * dx2);
			var g:Number = ((sx * dy2) - (sy * dx2)) / z;
			var h:Number = ((sy * dx1) - (sx * dy1)) / z;

			system[0] = p1.x - p0.x + g * p1.x;
			system[1] = p3.x - p0.x + h * p3.x;
			system[2] = p0.x;
			system[3] = p1.y - p0.y + g * p1.y;
			system[4] = p3.y - p0.y + h * p3.y;
			system[5] = p0.y;
			system[6] = g;
			system[7] = h;

			return system;
		}


		private function _invert(u:Number, v:Number, system:Vector.<Number>, p:Point = null):Point {
			p ||= new Point();
			p.x = (system[0] * u + system[1] * v + system[2]) / (system[6] * u + system[7] * v + 1);
			p.y = (system[3] * u + system[4] * v + system[5]) / (system[6] * u + system[7] * v + 1);
			return p;
		}
	}
}
