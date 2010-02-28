package net.saqoosha.util {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	
	public class DisplayObjectUtil {
		
		
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
		
		
		public static function convertCoord(point:Point, from:DisplayObject, to:DisplayObject):Point {
			return to.globalToLocal(from.localToGlobal(point));
		}
		
		
		public static function changeParentTo(target:DisplayObject, newParent:DisplayObjectContainer):DisplayObject {
			// TODO: Support rotation and other transform prprs. (matrix or so)
			var gp:Point = convertCoord(new Point(target.x, target.y), target.parent, newParent);
			target.x = gp.x;
			target.y = gp.y;
			target.parent.removeChild(target);
			return newParent.addChild(target);
		}
		
		
		public static function removeAllChildren(container:DisplayObjectContainer):void {
			var n:int = container.numChildren;
			while (n--) {
				container.removeChildAt(n);
			}
		}
	}
}
