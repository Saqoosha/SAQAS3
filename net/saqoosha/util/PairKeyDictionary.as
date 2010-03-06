package net.saqoosha.util {
	import flash.utils.Dictionary;

	
	/**
	 * @author hiko
	 */
	public class PairKeyDictionary {

		
		private var _dict:Dictionary;

		
		public function PairKeyDictionary() {
			_dict = new Dictionary();
		}
		
		
		public function setValue(key1:*, key2:*, value:*):void {
			if (!_dict[key1]) {
				_dict[key1] = new Dictionary();
			}
			if (!_dict[key2]) {
				_dict[key2] = new Dictionary();
			}
			_dict[key1][key2] = _dict[key2][key1] = value;
		}

		
		public function getValue(key1:*, key2:*):* {
			if (_dict[key1]) {
				return _dict[key1][key2];
			} else if (_dict[key2]) {
				return _dict[key2][key1];
			} else {
				return undefined;
			}
		}
		
		
		public function deleteValue(key1:*, key2:*):void {
			if (_dict[key1]) {
				delete _dict[key1][key2];
			}
			if (_dict[key2]) {
				delete _dict[key2][key1];
			}
		}
		
		
		public function getKeys(key1:* = null):Array {
			var keys:Array = [];
			var key:*;
			if (key1 == null) {
				for (key in _dict) {
					keys.push(key);
				}
			} else {
				for (key in _dict[key1]) {
					keys.push(key);
				}
			}
			return keys;
		}
		
		
		public function clearAll():void {
			_dict = new Dictionary();
		}
	}
}
