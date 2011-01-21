package sh.saqoo.util {

	
	public class ShuffleArrayIterator {

		
		private var _array:Array;
		private var _arrIndex:Array;
		private var _current:int;
		private var _autoLoop:Boolean;

		
		public function ShuffleArrayIterator(arr:Array, autoLoop:Boolean = false) {
			_array = arr;
			_current = 0;
			_autoLoop = autoLoop;
			shuffle();
		}
		

		public function hasNext():Boolean {
			return _autoLoop || _current < _array.length;
		}
		

		public function next():* {
			if (_autoLoop && _current == _array.length) {
				start();
			}
			return _array[_arrIndex[_current++]];
		}
		

		public function start():void {
			_current = 0;
		}
		

		public function shuffle():void {
			_arrIndex = _array.sort(function (a:*, b:*):Number {
				return Math.random() < 0.5 ? 1 : -1;
			}, Array.RETURNINDEXEDARRAY);
		}
		

		public function get array():Array {
			return _array;
		}
		

		public function get arrayIndex():Array {
			return _arrIndex;
		}
		

		public function get autoLoop():Boolean {
			return _autoLoop;
		}
		

		public function set autoLoop(val:Boolean):void {
			_autoLoop = val;
		}
	}
}
