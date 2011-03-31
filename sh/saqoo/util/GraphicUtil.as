package sh.saqoo.util {

	import sh.saqoo.geom.LineSegment;
	import sh.saqoo.math.MathUtil;

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


		/**
		 * @see http://code.google.com/p/leebrimelow/source/browse/trunk/as3/com/theflashblog/drawing/Arc.as
		 */
		public static function drawArc(graphics:Graphics, center:Point, radius:Number, startAngle:Number, endAngle:Number):void {
			var segAngle:Number;
			var angle:Number;
			var angleMid:Number;
			var numOfSegs:Number;
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var cx:Number;
			var cy:Number;
		
			var arc:Number = Math.min(Math.abs(endAngle - startAngle), 360);
			if (endAngle < startAngle) startAngle = endAngle;
		
			numOfSegs = Math.ceil(Math.abs(arc) / 45);
			segAngle = arc / numOfSegs * MathUtil.toRadian;
			angle = startAngle * MathUtil.toRadian;

			ax = center.x;
			ay = center.y;
			
//			graphics.moveTo(ax + Math.cos(angle) * radius, ay + Math.sin(angle) * radius);
		
			for (var i:int = 0; i < numOfSegs; i++) {
				// Increment the angle
				angle += segAngle;
		
				// The angle halfway between the last and the new
				angleMid = angle - (segAngle / 2);
		
				// Calculate the end point
				bx = ax + Math.cos(angle) * radius;
				by = ay + Math.sin(angle) * radius;
		
				// Calculate the control point
				cx = ax + Math.cos(angleMid) * (radius / Math.cos(segAngle / 2));
				cy = ay + Math.sin(angleMid) * (radius / Math.cos(segAngle / 2));
		
				// Draw out the segment
				graphics.curveTo(cx, cy, bx, by);
			}
		}
		
		
		public static function drawRoundedCorner(graphics:Graphics, p0:Point, p1:Point, p2:Point, radius:Number, moveToStart:Boolean = true):Point {
			var l0:LineSegment = new LineSegment(p0, p1).getOffsetLineSegment(radius);
			var l1:LineSegment = new LineSegment(p1, p2).getOffsetLineSegment(radius);
			var c:Point = l0.getIntersectionPoint(l1);
			var v0:Point = l0.p1.subtract(l0.p0);
			var a0:Number = Math.atan2(-v0.x, v0.y);
			var cp0:Point = new Point(Math.cos(a0) * radius + c.x, Math.sin(a0) * radius + c.y);
			if (moveToStart) {
				graphics.moveTo(cp0.x, cp0.y);
			} else {
				graphics.lineTo(cp0.x, cp0.y);
			}
			var v1:Point = l1.p1.subtract(l1.p0);
			var a1:Number = Math.atan2(-v1.x, v1.y);
			if (a1 < a0) a1 += Math.PI * 2;
			GraphicUtil.drawArc(graphics, c, radius, a0 * MathUtil.toDegree, a1 * MathUtil.toDegree);
			return new Point(Math.cos(a1) * radius + c.x, Math.sin(a1) * radius + c.y);
		}
	}
}
