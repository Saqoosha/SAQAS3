package sh.saqoo.geom {
	import flash.geom.Point;

	
	/**
	 * @author Saqoosha
	 */
	public class HermiteCurvePoint {
		
		
		public var position:Point;
		public var velocity:Point;
		public var distance:Number;
		
		
		public function HermiteCurvePoint(position:Point = null, velocity:Point = null, distance:Number = 0) {
			this.position = position || new Point();
			this.velocity = velocity || new Point();
			this.distance = distance;
		}
		
		
		public function toString():String {
			return '[HermitCurvePoint position=' + position + ' velocity=' + velocity + ' distance=' + distance  + ']';
		}
	}
}
