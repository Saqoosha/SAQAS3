package sh.saqoo.util {
	
	
	public class FlashVars {


		private static var _parameters:Object = {};


		public static function init(parameters:Object):void {
			for (var key:* in parameters) {
				_parameters[key] = parameters[key];
			}
		}


		public static function getString(key:String, def:String = null):String {
			return hasKey(key) ? String(_parameters[key]) : def;
		}


		public static function getNumber(key:String, def:Number = NaN):Number {
			return hasKey(key) ? parseFloat(_parameters[key]) : def;
		}


		public static function getInt(key:String, def:int = 0):int {
			return hasKey(key) ? parseInt(_parameters[key]) : def;
		}


		public static function hasKey(key:String):Boolean {
			return _parameters && key in _parameters;
		}


		public static function setValue(key:String, value:*):void {
			_parameters[key] = value;
		}


		public static function deleteKey(key:String):void {
			if (hasKey(key)) delete _parameters[key];
		}
	}
}
