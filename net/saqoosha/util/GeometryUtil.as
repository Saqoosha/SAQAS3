package net.saqoosha.util {
	import flash.display.DisplayObject;
	import flash.geom.Point;

	
	public class GeometryUtil {
		
		
		private static const _tmpPoint:Point = new Point();
		
		
		public static function localXToGlobalX(local:DisplayObject, x:Number):Number {
			_tmpPoint.x = x;
			return local.localToGlobal(_tmpPoint).x;
		}
		
		
		public static function localYToGlobalY(local:DisplayObject, y:Number):Number {
			_tmpPoint.y = y;
			return local.localToGlobal(_tmpPoint).y;
		}
		
		
		public static function globalXToLocalX(local:DisplayObject, x:Number):Number {
			_tmpPoint.x = x;
			return local.globalToLocal(_tmpPoint).x;
		}
		
		
		public static function globalYToLocalY(local:DisplayObject, y:Number):Number {
			_tmpPoint.y = y;
			return local.globalToLocal(_tmpPoint).y;
		}
	}
}
