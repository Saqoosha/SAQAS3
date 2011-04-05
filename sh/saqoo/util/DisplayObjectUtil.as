package sh.saqoo.util {

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
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


		public static function changeParent(target:DisplayObject, newParent:DisplayObjectContainer):DisplayObject {
			// TODO: Support rotation and other transform props. (matrix or so)
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


		public static function inactivate(object:InteractiveObject):void {
			object.mouseEnabled = false;
			object.tabEnabled = false;
			if (object is Sprite) {
				Sprite(object).mouseChildren = false;
				Sprite(object).tabChildren = false;
			}
			if (object is MovieClip) {
				MovieClip(object).enabled = false;
			}
		}
	}
}
