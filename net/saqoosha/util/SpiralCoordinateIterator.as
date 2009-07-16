package net.saqoosha.util {
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SpiralCoordinateIterator {
		
		public static const DOWN:int = 0;
		public static const LEFT:int = 1;
		public static const UP:int = 2;
		public static const RIGHT:int = 3;
		
		private var _current:Point;
		private var _rect:Rectangle;
		private var _direction:int;
		
		public function SpiralCoordinateIterator(iniDir:int = RIGHT) {
			this._current = new Point(0, 0);
			this._rect = new Rectangle(0, 0, 0, 0);
			this._direction = iniDir;
		}
		
		public function start():void {
			this._current.x = 0;
			this._current.y = 0;
			this._rect.width = 0;
			this._rect.height = 0;
		}
		
		public function next():Point {
			var ret:Point = this._current.clone();
//		trace(this._current, this._rect, this._direction);
			switch (this._direction) {
				case DOWN:
					if (++this._current.y > this._rect.height * 0.5) {
						this._rect.height++;
						this._direction = ++this._direction % 4;
					}
					break;
				case LEFT:
					if (--this._current.x < -this._rect.width * 0.5) {
						this._rect.width++;
						this._direction = ++this._direction % 4;
					}
					break;
				case UP:
					if (--this._current.y < -this._rect.height * 0.5) {
						this._rect.height++;
						this._direction = ++this._direction % 4;
					}
					break;
				case RIGHT:
					if (++this._current.x > this._rect.width * 0.5) {
						this._rect.width++;
						this._direction = ++this._direction % 4;
					}
					break;
			}
			return ret;
		}
		
		public function get direction():int {
			return this._direction;
		}
		
		public function get rect():Rectangle {
			return this._rect;
		}

	}
	
}