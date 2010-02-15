package net.saqoosha.util {
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	public class LayoutUtil {
		
//		public static var stage:Stage;
		
		public static function alignVertical(px:Number, py:Number, sp:Number, objects:Array):void {
			for each (var obj:DisplayObject in objects) {
				obj.x = px;
				obj.y = py;
				py += obj.height + sp;
			} 
		}

	}
	
}