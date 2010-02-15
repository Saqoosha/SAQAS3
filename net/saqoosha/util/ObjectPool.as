package net.saqoosha.util {
	
	import flash.utils.Dictionary;
	
	public class ObjectPool {
		
		private static const _instance:ObjectPool = new ObjectPool();
		public static function getInstance():ObjectPool {
			return _instance;
		}
		
		//
		
		private var _pool:Dictionary = new Dictionary(false); 
		
		public function ObjectPool() {
			if (_instance) {
				throw new ArgumentError('Singleton!');
			}
		}
		
		public function registerObject(key:String, object:*):* {
			if (!(this._pool[key])) {
				this._pool[key] = [];
			}
			this._pool[key].push(object);
			return object;
		}
		
		public function getObject(key:String):* {
			if (this._pool[key]) {
				var p:Array = this._pool[key];
				if (p.length) {
					return p.pop();
				} else {
					null;
				}
			} else {
				return null;
			}
		}
		
		public function numObjectsForKey(key:String):int {
			if (this._pool[key]) {
				return this._pool[key].length;
			} else {
				return 0;
			}
		}
	}
}