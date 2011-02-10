package sh.saqoo.geom {
	import flash.geom.Point;

	
	/**
	 * @author Saqoosha
	 */
	public class HermiteCurvePoint {
		
		
		public var position:Point;
		public var velocity:Point;
		
		
		public function HermiteCurvePoint(position:Point = null, velocity:Point = null) {
			this.position = position || new Point();
			this.velocity = velocity || new Point();
		}
		
		
		public function toString():String {
			return '[HermitCurvePoint position=' + position + ' velocity=' + velocity + ']';
		}
	}
}
