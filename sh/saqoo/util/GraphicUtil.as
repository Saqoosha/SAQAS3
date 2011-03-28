package sh.saqoo.util {

	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.geom.Point;

	/**
	 * @author Saqoosha
	 */
	public class GraphicUtil {
		
		
		public static function drawPolygon(graphics:Graphics, points:Vector.<Point>, close:Boolean = true, winding:String = 'evenOdd'):void {
			var n:int = points.length;
			var commands:Vector.<int> = new Vector.<int>(n);
			var data:Vector.<Number> = new Vector.<Number>(n * 2);
			for (var i:int = 0; i < n; i++) {
				commands[i] = GraphicsPathCommand.LINE_TO;
				data[i * 2] = points[i].x;
				data[i * 2 + 1] = points[i].y;
			}
			if (close) {
				commands.push(GraphicsPathCommand.LINE_TO);
				data.push(points[0].x, points[0].y);
			}
			commands[0] = GraphicsPathCommand.MOVE_TO;
			graphics.drawPath(commands, data, winding);
		}
	}
}
