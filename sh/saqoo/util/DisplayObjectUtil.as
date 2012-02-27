package sh.saqoo.util {

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
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
			var m:Matrix = target.transform.concatenatedMatrix;
			var n:Matrix = newParent.transform.concatenatedMatrix;
			n.invert();
			m.concat(n);
			target.transform.matrix = m;
			return newParent.addChild(target);
		}


		public static function removeAllChildren(container:DisplayObjectContainer):void {
			var n:int = container.numChildren;
			while (n--) {
				container.removeChildAt(n);
			}
		}


		public static function inactivate(object:InteractiveObject, ...objs):void {
			function f(o:InteractiveObject):void {
				o.mouseEnabled = false;
				o.tabEnabled = false;
				if (object is Sprite) {
					Sprite(o).mouseChildren = false;
					Sprite(o).tabChildren = false;
				}
				if (object is MovieClip) {
					MovieClip(o).enabled = false;
				}
			}
			f(object);
			for each (var o:InteractiveObject in objs) f(o);
		}
		
		
		public static function setSmoothingAll(container:DisplayObjectContainer, smoothing:Boolean):void {
			for (var i:int = 0, n:int = container.numChildren; i < n; ++i) {
				var obj:DisplayObject = container.getChildAt(i);
				if (obj is Bitmap) {
					Bitmap(obj).smoothing = smoothing;
				} else if (obj is DisplayObjectContainer) {
					setSmoothingAll(DisplayObjectContainer(obj), smoothing);
				}
			}
		}
		
		
		public static function dumpTree(container:DisplayObjectContainer, padding:String = ''):void {
			for (var i:int = 0, n:int = container.numChildren; i < n; ++i) {
				var obj:DisplayObject = container.getChildAt(i);
				trace(padding + obj);
				if (obj is DisplayObjectContainer) {
					dumpTree(DisplayObjectContainer(obj), padding + '    ');
				}
			}
		}
	}
}
