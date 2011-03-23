package sh.saqoo.util {

	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.geom.Point;

	/**
	 * @author Saqoosha
	 */
	public class GraphicUtil {
		
		
		public static function drawPolygon(graphics:Graphics, points:Vector.<Point>, winding:String = 'evenOdd'):void {
			var n:int = points.length;
			var commands:Vector.<int> = new Vector.<int>(n, true);
			var data:Vector.<Number> = new Vector.<Number>(n * 2, true);
			for (var i:int = 0; i < n; i++) {
				commands[i] = GraphicsPathCommand.LINE_TO;
				data[i * 2] = points[i].x;
				data[i * 2 + 1] = points[i].y;
			}
			commands[0] = GraphicsPathCommand.MOVE_TO;
			graphics.drawPath(commands, data, winding);
		}
	}
}
