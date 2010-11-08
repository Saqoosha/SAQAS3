package net.saqoosha.util {

	
	public class NotificationCenter {

		
		private static const _defaultCenter:NotificationCenter = new NotificationCenter();

		public static function get defaultCenter():NotificationCenter {
			return _defaultCenter;
		}
		
		
		//
		

		private var _observers:Array;


		public function NotificationCenter() {
			_observers = [];
		}

		
		public function addObserver(callback:Function, name:String = null, object:Object = null):void {
			_observers.push(new ObserverInfo(callback, name, object));
		}

		
		public function removeObserver(callback:Function, name:String = null, object:Object = null):void {
			var i:int = _observers.length;
			while (i--) {
				var info:ObserverInfo = _observers[i];
				if (info.callback == callback && (name == null || info.name == name) && (object == null || info.object == object)) {
					_observers.splice(i, 1);
					break;
				}
			}
		}

		
		public function postNotification(name:String, object:Object, userInfo:* = null):void {
			for each (var info:ObserverInfo in _observers) {
				if ((info.name == null || info.name == name) && (info.object == null || info.object == object)) {
					info.callback(name, object, userInfo);
				}
			}
		}
	}
}


class ObserverInfo {

	
	public var callback:Function;
	public var name:String;
	public var object:Object;

	public function ObserverInfo(callback:Function, name:String, object:Object) {
		this.callback = callback;
		this.name = name;
		this.object = object;
	}
}
