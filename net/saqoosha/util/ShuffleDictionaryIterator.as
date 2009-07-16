package net.saqoosha.util {
	
	import flash.utils.Dictionary;
	
	public class ShuffleDictionaryIterator {
		
		private var _dic:Dictionary;
		private var _key:Array;
		private var _keyIndex:Array;
		private var _current:int;
		private var _autoLoop:Boolean;
		
		public function ShuffleDictionaryIterator(dic:Dictionary, autoLoop:Boolean = false) {
			this._dic = dic;
			this._current = 0;
			this._autoLoop = autoLoop;
			this.shuffle();
		}
		
		public function hasNext():Boolean {
			return this._autoLoop || this._current < this._key.length;
		}
		
		public function next():* {
			if (this._autoLoop && this._current == this._key.length) {
				this.start();
			}
			return this._dic[this._key[this._keyIndex[this._current++]]];
		}
		
		public function start():void {
			this._current = 0;
		}
		
		public function shuffle():void {
			this._key = [];
			for (var key:* in this._dic) {
				this._key.push(key);
			}
			this._keyIndex = this._key.sort(function (a:*, b:*):Number { return Math.random() < 0.5 ? 1 : -1 }, Array.RETURNINDEXEDARRAY);
		}
		
		public function get dictionary():Dictionary {
			return this._dic;
		}
		
		public function get keyIndex():Array {
			return this._keyIndex;
		}
		
		public function get autoLoop():Boolean {
			return this._autoLoop;
		}
		
		public function set autoLoop(val:Boolean):void {
			this._autoLoop = val;
		}
		
		public function get length():int {
			return this._key.length;
		}

	}
	
}