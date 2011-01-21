package sh.saqoo.util {

	
	/**
	 * @author Saqoosha
	 */
	public class RandomIterator {
		
		
		private var _objects:*;
		private var _prevIndex:int;
		
		
		public function RandomIterator(...args) {
			if (args.length == 1) {
				_objects = args[0];
			} else {
				_objects = ArrayUtil.fromArguments(args);
			}
			_prevIndex = -1;
		}
		
		
		public function getNext():* {
			var idx:int;
			do {
				idx = int(Math.random() * _objects.length);
			} while (idx == _prevIndex);
			_prevIndex = idx;
			return _objects[idx];
		}

		
		public function get objects():* {
			return _objects;
		}
		
		
		public function set objects(objects:*):void {
			_objects = objects;
		}
	}
}
