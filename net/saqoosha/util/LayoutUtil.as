package net.saqoosha.util {
	import flash.display.DisplayObject;

	
	public class LayoutUtil {

		
		public static function alignVertical(px:Number, py:Number, sp:Number, objects:Array):void {
			for each (var obj:DisplayObject in objects) {
				obj.x = px;
				obj.y = py;
				py += obj.height + sp;
			} 
		}


		public static function alignHorizontal(px:Number, py:Number, sp:Number, objects:Array):void {
			for each (var obj:DisplayObject in objects) {
				obj.x = px;
				obj.y = py;
				px += obj.height + sp;
			}
		}
	}
}
