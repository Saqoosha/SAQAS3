package sh.saqoo.geom {
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public interface IPathSegment {
		
		virtual function draw(g:Graphics):void;
		virtual function getPointAt(t:Number):Point;
		virtual function get length():Number;
		virtual function get start():Point;
		virtual function get end():Point;
		
	}
	
}