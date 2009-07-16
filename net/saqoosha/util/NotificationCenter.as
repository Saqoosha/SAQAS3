package net.saqoosha.util {
	
	import jp.progression.commands.Func;
	
	public class NotificationCenter {
		
		private static const _defaultCenter:NotificationCenter = new NotificationCenter();
		
		public static function defaultCenter():NotificationCenter {
			return _defaultCenter;
		}
		
		private var _observers:Array;
		
		public function NotificationCenter() {
			this._observers = [];
		}
		
		public function addObserver(observer:Object, func:String, name:String = null, object:Object = null):void {
			this._observers.push(new ObserverInfo(observer, func, name, object));
		}
		
		public function removeObserver(observer:Object, name:String = null, object:Object = null):void {
			var i:int = this._observers.length;
			while (i--) {
				var info:ObserverInfo = this._observers[i];
				if (info.observer == observer && (name == null || info.name == name) && (object == null || info.object == object)) {
					this._observers.splice(i, 1);
				}
			}
		}
		
		public function postNotification(name:String, object:Object, userInfo:* = null):void {
			for each (var info:ObserverInfo in this._observers) {
				if ((info.name == null || info.name == name) && (info.object == null || info.object == object)) {
					info.observer[info.func](name, object, userInfo);
				}
			}
		}
	}
}


class ObserverInfo {
	
	public var observer:Object;
	public var func:String;
	public var name:String;
	public var object:Object;
	
	public function ObserverInfo(observer:Object, func:String, name:String, object:Object) {
		this.observer = observer;
		this.func = func;
		this.name = name;
		this.object = object;
	}
}