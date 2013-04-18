package sh.saqoo.geom
{

import sh.saqoo.util.GeometryUtil;

import flash.display.Graphics;
import flash.geom.Point;

/**
 * @author Saqoosha
 */
public class LineSegment
{
    private var _p0:Point;
    private var _p1:Point;

    public function LineSegment(start:Point, end:Point)
    {
        _p0 = start;
        _p1 = end;
    }

    public function getPointAt(t:Number):Point
    {
        return Point.interpolate(_p1, _p0, t);
    }

    public function getOffsetLineSegment(offset:Number):LineSegment
    {
        var v:Point = _p1.subtract(_p0);
        v.normalize(offset);
        return new LineSegment(new Point(_p0.x - v.y, _p0.y + v.x), new Point(_p1.x - v.y, _p1.y + v.x));
    }

    public function getIntersectionPoint(segment:LineSegment):Point
    {
        return GeometryUtil.getIntersectionPoint(_p0, _p1, segment.p0, segment.p1);
    }

    public function draw(graphics:Graphics):void
    {
        graphics.moveTo(_p0.x, _p0.y);
        graphics.lineTo(_p1.x, _p1.y);
    }

    public function get p0():Point
    {
        return _p0;
    }

    public function get p1():Point
    {
        return _p1;
    }

    public function get length():Number
    {
        return Point.distance(_p0, _p1);
    }
}
}
