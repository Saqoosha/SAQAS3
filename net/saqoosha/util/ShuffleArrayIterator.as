package net.saqoosha.util {
	
	public class ShuffleArrayIterator {
		
		private var _array:Array;
		private var _arrIndex:Array;
		private var _current:int;
		private var _autoLoop:Boolean;
		
		public function ShuffleArrayIterator(arr:Array, autoLoop:Boolean = false) {
			this._array = arr;
			this._current = 0;
			this._autoLoop = autoLoop;
			this.shuffle();
		}
		
		public function hasNext():Boolean {
			return this._autoLoop || this._current < this._array.length;
		}
		
		public function next():* {
			if (this._autoLoop && this._current == this._array.length) {
				this.start();
			}
			return this._array[this._arrIndex[this._current++]];
		}
		
		public function start():void {
			this._current = 0;
		}
		
		public function shuffle():void {
			this._arrIndex = this._array.sort(function (a:*, b:*):Number { return Math.random() < 0.5 ? 1 : -1 }, Array.RETURNINDEXEDARRAY);
		}
		
		public function get array():Array {
			return this._array;
		}
		
		public function get arrayIndex():Array {
			return this._arrIndex
		}
		
		public function get autoLoop():Boolean {
			return this._autoLoop;
		}
		
		public function set autoLoop(val:Boolean):void {
			this._autoLoop = val;
		}

	}
	
}