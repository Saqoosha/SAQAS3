package sh.saqoo.math {
	import flash.geom.Point;

	
	/**
	 * @author Saqoosha
	 */
	public class HomographyMatrix {

		
		private var h:Array;

		
		public function HomographyMatrix(param:Array) {
			h = param;
		}
		
		
		public function transformPoint(point:Point):Point {
			var z:Number = 1.0 / (h[6] * point.x + h[7] * point.y + h[8]);
			var pt:Point = new Point();
			pt.x = (h[0] * point.x + h[1] * point.y + h[2]) * z;
			pt.y = (h[3] * point.x + h[4] * point.y + h[5]) * z;
			return pt;
		}
		
		
		public function transformPoints(points:Vector.<Point>):void {
			var n:int = points.length;
			var p:Point;
			var x:Number;
			var z:Number;
			for (var i:int = 0; i < n; i++) {
				p = points[i];
				z = 1.0 / (h[6] * p.x + h[7] * p.y + h[8]);
				x = (h[0] * p.x + h[1] * p.y + h[2]) * z;
				p.y = (h[3] * p.x + h[4] * p.y + h[5]) * z;
				p.x = x;
			}
		}
	}
}
