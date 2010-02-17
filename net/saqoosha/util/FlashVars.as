package net.saqoosha.util {

	public class FlashVars {

		private static var _parameters:Object;

		public static function init(parameters:Object):void {
			_parameters = parameters;
			trace('[FlashVars');
			for (var key:String in _parameters) {
				trace('\t' + key + ' -> ' + _parameters[key]);
			}
			trace(']');
		}

		public static function getString(key:String, def:String=null):String {
			return hasKey(key) ? String(_parameters[key]) : def;
		}

		public static function getNumber(key:String, def:Number=NaN):Number {
			return hasKey(key) ? parseFloat(_parameters[key]) : def;
		}

		public static function getInt(key:String, def:int=0):int {
			return hasKey(key) ? parseInt(_parameters[key]) : def;
		}

		public static function hasKey(key:String):Boolean {
			return _parameters && key in _parameters;
		}
	}
}
