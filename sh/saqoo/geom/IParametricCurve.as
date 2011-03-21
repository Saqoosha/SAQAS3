package sh.saqoo.geom {

	import flash.geom.Point;
	
	/**
	 * @author Saqoosha
	 */
	public interface IParametricCurve {
		function getLength(n:uint = 2):Number;
		function getPointAt(t:Number, out:Point = null):Point;
		function getTangentAt(t:Number, out:Point = null):Point;
	}
}
