package sh.saqoo.debug {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Saqoosha
	 */
	public class DisplayObjectDumper {
		
		
		public static function dump(object:DisplayObject):void {
			if (object is DisplayObjectContainer) {
				_dumpContainer(DisplayObjectContainer(object), []);
			} else {
				_dumpObject(object);
			}
		}
		
		
		private static function _dumpContainer(object:DisplayObjectContainer, padding:Array, index:int = 0, isLast:Boolean = false):void {
			trace(padding.join('') + index + ':'  + object + ' (' + object.name + ')');
			var pad:Array = padding.concat();
			pad[pad.length - 1] = isLast ? '    ' : '│   ';
			var n:int = object.numChildren - 1;
			for (var i:int = 0; i <= n; i++) {
				var p:String = i == n ? '└───' : '├───';
				var c:DisplayObject = object.getChildAt(i);
				var cc:DisplayObjectContainer = c as DisplayObjectContainer;
				if (cc && cc.numChildren) {
					_dumpContainer(cc, pad.concat(p), i, i == n);
				} else {
					_dumpObject(c, pad.join('') + p, i);
				}
			}
		}
		
		
		private static function _dumpObject(object:DisplayObject, padding:String = '', index:int = 0):void {
			trace(padding + index + ':' + object + ' (' + object.name + ')');
		}
	}
}
