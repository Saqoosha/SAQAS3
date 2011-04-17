package sh.saqoo.geom {

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Saqoosha
	 */
	public class SpiralCoordinateIterator {


		public static const DOWN:int = 0;
		public static const LEFT:int = 1;
		public static const UP:int = 2;
		public static const RIGHT:int = 3;
		
		
		private var _current:Point;
		private var _rect:Rectangle;
		private var _direction:int;

		public function get direction():int { return _direction; }
		public function get rect():Rectangle { return _rect; }


		public function SpiralCoordinateIterator(iniDir:int = RIGHT) {
			_current = new Point(0, 0);
			_rect = new Rectangle(0, 0, 0, 0);
			_direction = iniDir;
		}


		public function start():void {
			_current.x = 0;
			_current.y = 0;
			_rect.width = 0;
			_rect.height = 0;
		}


		public function get next():Point {
			var ret:Point = _current.clone();
			switch (_direction) {
				case DOWN:
					if (++_current.y > _rect.height * 0.5) {
						_rect.height++;
						_direction = ++_direction % 4;
					}
					break;
				case LEFT:
					if (--_current.x < -_rect.width * 0.5) {
						_rect.width++;
						_direction = ++_direction % 4;
					}
					break;
				case UP:
					if (--_current.y < -_rect.height * 0.5) {
						_rect.height++;
						_direction = ++_direction % 4;
					}
					break;
				case RIGHT:
					if (++_current.x > _rect.width * 0.5) {
						_rect.width++;
						_direction = ++_direction % 4;
					}
					break;
			}
			return ret;
		}
	}
}
