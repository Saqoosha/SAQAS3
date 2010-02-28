package net.saqoosha.util {

	
	public class FlashVars {

		
		private static var _parameters:Object = {};

		
		public static function init(parameters:Object):void {
			for (var key:* in parameters) {
				_parameters[key] = parameters[key];
			}
//			ObjectDumper.dump(_parameters);
		}

		
		public static function getString(id:String):String {
			return _parameters ? _parameters[id] as String : null;
		}

		
		public static function getNumber(id:String):Number {
			return _parameters ? parseFloat(_parameters[id]) : NaN;
		}

		
		public static function getInt(id:String):int {
			return _parameters ? parseInt(_parameters[id]) : NaN;
		}
	}
}
