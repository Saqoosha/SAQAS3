package sh.saqoo.geom {
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	
	/**
	 * @author Saqoosha
	 */
	public dynamic class CubicBezier extends Proxy {
		
		
		public var _p0:Point;
		public var _p1:Point;
		public var _p2:Point;
		public var _p3:Point;
		
		private var _points:Vector.<Point>;
		
		
		public function CubicBezier(p0:Point = null, p1:Point = null, p2:Point = null, p3:Point = null) {
			_p0 = p0 || new Point();
			_p1 = p1 || new Point();
			_p2 = p2 || new Point();
			_p3 = p3 || new Point();
			_points = Vector.<Point>([_p0, _p1, _p2, _p3]);
		}
		
		
		public function getPointAt(t:Number, out:Point = null):Point {
			out ||= new Point();
			var t2:Number = t * t;
			var t3:Number = t2 * t;
			var c1:Number, c2:Number, c3:Number, c4:Number;
			c1 = (_p3.x - (3.0 * _p2.x) + (3.0 * _p1.x) - _p0.x);
			c2 = ((3.0 * _p2.x) - (6.0 * _p1.x) + (3.0 * _p0.x));
			c3 = ((3.0 * _p1.x) - (3.0 * _p0.x));
			c4 = _p0.x;
			out.x = c1 * t3 + c2 * t2 + c3 * t + c4;
			c1 = (_p3.y - (3.0 * _p2.y) + (3.0 * _p1.y) - _p0.y);
			c2 = ((3.0 * _p2.y) - (6.0 * _p1.y) + (3.0 * _p0.y));
			c3 = ((3.0 * _p1.y) - (3.0 * _p0.y));
			c4 = _p0.y;
			out.y = c1 * t3 + c2 * t2 + c3 * t + c4;
			return out;
		}
		
		
		public function getTangentAt(t:Number, out:Point = null):Point {
			out ||= new Point();
			var t2:Number = t * t;
			var c1:Number, c2:Number, c3:Number;
			c1 = (_p3.x - (3.0 * _p2.x) + (3.0 * _p1.x) - _p0.x);
			c2 = ((3.0 * _p2.x) - (6.0 * _p1.x) + (3.0 * _p0.x));
			c3 = ((3.0 * _p1.x) - (3.0 * _p0.x));
			out.x = (3.0 * c1 * t2) + (2.0 * c2 * t) + c3;
			c1 = (_p3.y - (3.0 * _p2.y) + (3.0 * _p1.y) - _p0.y);
			c2 = ((3.0 * _p2.y) - (6.0 * _p1.y) + (3.0 * _p0.y));
			c3 = ((3.0 * _p1.y) - (3.0 * _p0.y));
			out.y = (3.0 * c1 * t2) + (2.0 * c2 * t) + c3;
			return out;
		}

		
		public function draw(graphics:Graphics):void {
			DrawImpl1.draw(graphics, _p0, _p1, _p2, _p3);
		}
		
		
		public function draw2(graphics:Graphics):void {
			DrawImpl2.draw(graphics, _p0, _p1, _p2, _p3);
		}
		
		
		public function draw3(graphics:Graphics):void {
			DrawImpl3.draw(graphics, _p0, _p1, _p2, _p3);
		}
		
		
		public function debugDraw(graphics:Graphics):void {
			graphics.lineStyle(0, 0x0, 0.2);
			graphics.moveTo(_p0.x, _p0.y);
			graphics.lineTo(_p1.x, _p1.y);
			graphics.moveTo(_p2.x, _p2.y);
			graphics.lineTo(_p3.x, _p3.y);
			graphics.lineStyle();
			graphics.beginFill(0xff0000);
			graphics.drawCircle(_p0.x, _p0.y, 3);			graphics.drawCircle(_p3.x, _p3.y, 3);
			graphics.endFill();
			graphics.beginFill(0x0000ff);
			graphics.drawCircle(_p1.x, _p1.y, 3);
			graphics.drawCircle(_p2.x, _p2.y, 3);
			graphics.endFill();
		}

		
		public function setPoints(points:Vector.<Point>):void {
			p0 = points[0];
			p1 = points[1];
			p2 = points[2];
			p3 = points[3];
		}

		
		public function get p0():Point { return _p0; }
		public function set p0(value:Point):void {
			_p0.x = value.x;
			_p0.y = value.y;
		}
		
		
		public function get p1():Point { return _p1; }
		public function set p1(value:Point):void {
			_p1.x = value.x;
			_p1.y = value.y;
		}
		
		
		public function get p2():Point { return _p2; }
		public function set p2(value:Point):void {
			_p2.x = value.x;
			_p2.y = value.y;
		}
		
		
		public function get p3():Point { return _p3; }
		public function set p3(value:Point):void {
			_p3.x = value.x;
			_p3.y = value.y;
		}

		
		flash_proxy override function getProperty(name:*):* {
			var index:int = int(name);
			if (index < 0 || 3 < index || !(name is String)) throw new ArgumentError('Prop name must be int in range 0 to 3.');
			return _points[index];
		}

		
		flash_proxy override function setProperty(name:*, value:*):void {
			var index:int = int(name);
			if (index < 0 || 3 < index || !(name is String)) throw new ArgumentError('Prop name must be int in range 0 to 3.');
			if (!(value is Point)) throw new ArgumentError('Value must be instance of flash.geom.Point.');
			_points[index].x = value.x;			_points[index].y = value.y;
		}
		
		
		public function toString():String {
			return '[CubicBezier p0=' + _p0 + ' p1=' + _p1 + ' p2=' + _p2 + ' p3=' + _p3 + ']';
		}
	}
}

import flash.display.Graphics;
import flash.geom.Point;


/**
 * Draw the cubic bezier with approximation by quadratic curves using fixed mid-point approach.
 * @see http://www.timotheegroleau.com/Flash/articles/cubic_bezier_in_flash.htm
 */
class DrawImpl1 {
	
	
	public static function draw(graphics:Graphics, p0:Point, p1:Point, p2:Point, p3:Point):void {
		// calculates the useful base points
		var PA:Point = Point.interpolate(p1, p0, 3 / 4);
		var PB:Point = Point.interpolate(p2, p3, 3 / 4);
		
		// get 1/16 of the [P3, P0] segment
		var dx:Number = (p3.x - p0.x) / 16;
		var dy:Number = (p3.y - p0.y) / 16;
		
		// calculates control point 1
		var Pc_1:Point = Point.interpolate(p1, p0, 3 / 8);
		
		// calculates control point 2
		var Pc_2:Point = Point.interpolate(PB, PA, 3 / 8);
		Pc_2.x -= dx;
		Pc_2.y -= dy;
		
		// calculates control point 3
		var Pc_3:Point = Point.interpolate(PA, PB, 3 / 8);
		Pc_3.x += dx;
		Pc_3.y += dy;
		
		// calculates control point 4
		var Pc_4:Point = Point.interpolate(p2, p3, 3 / 8);
		
		// calculates the 3 anchor points
		var Pa_1:Point = Point.interpolate(Pc_2, Pc_1, 0.5);
		var Pa_2:Point = Point.interpolate(PB, PA, 0.5);
		var Pa_3:Point = Point.interpolate(Pc_4, Pc_3, 0.5);
	
		// draw the four quadratic subsegments
		graphics.curveTo(Pc_1.x, Pc_1.y, Pa_1.x, Pa_1.y);
		graphics.curveTo(Pc_2.x, Pc_2.y, Pa_2.x, Pa_2.y);
		graphics.curveTo(Pc_3.x, Pc_3.y, Pa_3.x, Pa_3.y);
		graphics.curveTo(Pc_4.x, Pc_4.y, p3.x, p3.y);
	}
}


/**
 * Draw the cubic bezier with approximation by quadratic curves using tangent approach.
 * @see http://www.timotheegroleau.com/Flash/articles/cubic_bezier_in_flash.htm
 */
class DrawImpl2 {
	
	
	public static function draw(graphics:Graphics, p0:Point, p1:Point, p2:Point, p3:Point, nSegment:int = 4):void {
		//define the local variables
		var curT:Object; // holds the current Tangent object
		var nextT:Object; // holds the next Tangent object
		var total:int = 0; // holds the number of slices used
		
		// make sure nSegment is within range (also create a default in the process)
		if (nSegment < 2) nSegment = 4;
		
		// get the time Step from nSegment
		var tStep:Number = 1 / nSegment;
		
		// get the first tangent Object
		curT = new Object();
		curT.P = p0;
		curT.l = Line.getLine(p0, p1);
		
		// move to the first point
		// this.moveTo(P0.x, P0.y);
		
		// get tangent Objects for all intermediate segments and draw the segments
		for (var i:int = 1; i <= nSegment; i++) {
			// get Tangent Object for next point
			nextT = getCubicTgt(p0, p1, p2, p3, i * tStep);
			// get segment data for the current segment
			total += sliceCubicBezierSegment(graphics, p0, p1, p2, p3, (i - 1) * tStep, i * tStep, curT, nextT, 0);
			// prepare for next round
			curT = nextT;
		}
	}


	private static function sliceCubicBezierSegment(graphics:Graphics, P0:Point, P1:Point, P2:Point, P3:Point, u1:Number, u2:Number, Tu1:Object, Tu2:Object, recurs:int):int {
		// prevents infinite recursion (no more than 10 levels)
		// if 10 levels are reached the latest subsegment is 
		// approximated with a line (no quadratic curve). It should be good enough.
		if (recurs > 20) {
			graphics.lineTo(Tu2.P.x, Tu2.P.y);
			return 1;
		}
	
		// recursion level is OK, process current segment
		var ctrlPt:Point = Line.getCrossPoint(Tu1.l, Tu2.l);
		var d:Number = 0;
		
		// A control point is considered misplaced if its distance from one of the anchor is greater 
		// than the distance between the two anchors.
		if ((ctrlPt == null) || 
			(Point.distance(Tu1.P, ctrlPt) > (d = Point.distance(Tu1.P, Tu2.P))) ||
			(Point.distance(Tu2.P, ctrlPt) > d) ) {
	
			// total for this subsegment starts at 0			
			var tot:int = 0;
	
			// If the Control Point is misplaced, slice the segment more
			var uMid:Number = (u1 + u2) / 2;
			var TuMid:Object = getCubicTgt(P0, P1, P2, P3, uMid);
			tot += sliceCubicBezierSegment(graphics, P0, P1, P2, P3, u1, uMid, Tu1, TuMid, recurs + 1);
			tot += sliceCubicBezierSegment(graphics, P0, P1, P2, P3, uMid, u2, TuMid, Tu2, recurs + 1);
			
			// return number of sub segments in this segment
			return tot;
	
		} else {
			// if everything is OK draw curve
			graphics.curveTo(ctrlPt.x, ctrlPt.y, Tu2.P.x, Tu2.P.y);
			return 1;
		}
	}
	

	private static function getCubicTgt(P0:Point, P1:Point, P2:Point, P3:Point, t:Number):Object {
	
		// calculates the position of the cubic bezier at t
		var P:Point = new Point();
		P.x = getCubicPt(P0.x, P1.x, P2.x, P3.x, t);
		P.y = getCubicPt(P0.y, P1.y, P2.y, P3.y, t);
		
		// calculates the tangent values of the cubic bezier at t
		var V:Point = new Point();
		V.x = getCubicDerivative(P0.x, P1.x, P2.x, P3.x, t);
		V.y = getCubicDerivative(P0.y, P1.y, P2.y, P3.y, t);
	
		// calculates the line equation for the tangent at t
		var l:Line = Line.getLine2(P, V);
		
		// return the Point/Tangent object 
		var o:Object = {};
		o.P = P;
		o.l = l;
		
		return o;
	}


	private static function getCubicPt(c0:Number, c1:Number, c2:Number, c3:Number, t:Number):Number {
		var ts:Number = t * t;
		var g:Number = 3 * (c1 - c0);
		var b:Number = (3 * (c2 - c1)) - g;
		var a:Number = c3 - c0 - b - g;
		return (a * ts * t + b * ts + g * t + c0);
	}
	

	private static function getCubicDerivative(c0:Number, c1:Number, c2:Number, c3:Number, t:Number):Number {
		var g:Number = 3 * (c1 - c0);
		var b:Number = (3 * (c2 - c1)) - g;
		var a:Number = c3 - c0 - b - g;
		return (3 * a * t * t + 2 * b * t + g);
	}
}

class Line {

	
	public var a:Number = NaN;
	public var b:Number = NaN;
	public var c:Number = NaN;


	public function Line() {
	}


	public static function getLine(P0:Point, P1:Point):Line {
		var l:Line = new Line();
		var x0:Number = P0.x;
		var y0:Number = P0.y;
		var x1:Number = P1.x;
		var y1:Number = P1.y;
		
		if (x0 == x1) {
			if (y0 == y1) {
				// P0 and P1 are same point, return null
				l = null;
			} else {
				// Otherwise, the line is a vertical line
				l.c = x0;
			}
		} else {
			l.a = (y0 - y1) / (x0 - x1);
			l.b = y0 - (l.a * x0);
		}
		// returns the line object
		return l;
	}


	public static function getLine2(P0:Point, v0:Point):Line {
		var l:Line = new Line();
		var x0:Number = P0.x;
		var vx0:Number = v0.x;
		if (vx0 == 0) {
			// the line is vertical
			l.c = x0;
		} else {
			l.a = v0.y / vx0;
			l.b = P0.y - (l.a * x0);
		}
		// returns the line object
		return l;
	}


	public static function getCrossPoint(l0:Line, l1:Line):Point {
		// Make sure both line exists
		if ((l0 == null) || (l1 == null)) return null;
	
		// define local variables
		var a0:Number = l0.a;
		var b0:Number = l0.b;
		var c0:Number = l0.c;
		var a1:Number = l1.a;
		var b1:Number = l1.b;
		var c1:Number = l1.c;
		var u:Number;
	
		// checks whether both lines are vertical
		if (isNaN(c0) && isNaN(c1)) {
			// lines are not verticals but parallel, intersection does not exist
			if (a0 == a1) return null; 
			// calculate common x value.
			u = (b1 - b0) / (a0 - a1);		
			// return the new Point
			return new Point(u, a0 * u + b0);
	
		} else {
			if (!isNaN(c0)) {
				if (!isNaN(c1)) {
					// both lines vertical, intersection does not exist
					return null;
				} else {
					// return the point on l1 with x = c0
					return new Point(c0, a1 * c0 + b1);
				}
			} else if (!isNaN(c1)) {//c1 != undefined) {
				// no need to test c0 as it was tested above
				// return the point on l0 with x = c1
				return new Point(c1, a0 * c1 + b0);
			}
		}
		
		return null;
	}
}


/**
 * Draw the cubic bezier with approximation by quadratic curves using generic mid-point approach by Robert Penner.
 * @see http://www.robertpenner.com/scripts/bezier_draw_cubic.txt
 */
class DrawImpl3 {


	public static function draw(graphics:Graphics, p0:Point, p1:Point, p2:Point, p3:Point, tolerance:Number = 5):void {
		$cBez(graphics, p0, p1, p2, p3, tolerance * tolerance);
	}
	
	
	private static function $cBez(graphics:Graphics, a:Point, b:Point, c:Point, d:Point, k:Number):void {
		// find intersection between bezier arms
		var s:Point = intersect2Lines(a, b, c, d);
		// find distance between the midpoints
		var dx:Number = (a.x + d.x + s.x * 4 - (b.x + c.x) * 3) * .125;
		var dy:Number = (a.y + d.y + s.y * 4 - (b.y + c.y) * 3) * .125;
		// split curve if the quadratic isn't close enough
		if (dx*dx + dy*dy > k) {
			var halves:Object = bezierSplit(a, b, c, d);
			var b0:Object = halves.b0;
			var b1:Object = halves.b1;
			// recursive call to subdivide curve
			$cBez(graphics, a, b0.b, b0.c, b0.d, k);
			$cBez(graphics, b1.a, b1.b, b1.c, d, k);
		} else {
			// end recursion by drawing quadratic bezier
			graphics.curveTo(s.x, s.y, d.x, d.y);
		}
	}


	private static function intersect2Lines(p1:Point, p2:Point, p3:Point, p4:Point):Point {
		var x1:Number = p1.x;
		var y1:Number = p1.y;
		var x4:Number = p4.x;
		var y4:Number = p4.y;
	
		var dx1:Number = p2.x - x1;
		var dx2:Number = p3.x - x4;
		if (!(dx1 || dx2)) return null;
		
		var m1:Number = (p2.y - y1) / dx1;
		var m2:Number = (p3.y - y4) / dx2;
		
		if (!dx1) {
			// infinity
			return new Point(x1, m2 * (x1 - x4) + y4);
		} else if (!dx2) {
			// infinity
			return new Point(x4, m1 * (x4 - x1) + y1);
		}
		var xInt:Number = (-m2 * x4 + y4 + m1 * x1 - y1) / (m1 - m2);
		var yInt:Number = m1 * (xInt - x1) + y1;
		return new Point(xInt, yInt);
	}


	private static function bezierSplit(p0:Point, p1:Point, p2:Point, p3:Point):Object {
		var p01:Point = Point.interpolate(p0, p1, 0.5);
		var p12:Point = Point.interpolate(p1, p2, 0.5);
		var p23:Point = Point.interpolate(p2, p3, 0.5);
		var p02:Point = Point.interpolate(p01, p12, 0.5);
		var p13:Point = Point.interpolate(p12, p23, 0.5);
		var p03:Point = Point.interpolate(p02, p13, 0.5);
		return {
			b0:{a:p0,  b:p01, c:p02, d:p03},
			b1:{a:p03, b:p13, c:p23, d:p3 }	 
		};
	};
}
