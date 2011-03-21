package sh.saqoo.net.detectface {

	import flash.geom.Point;

	/**
	 * @author Saqoosha
	 */
	public class FeaturePoint extends Point {


		public var id:String;
		public var s:Number;


		public function FeaturePoint(id:String, x:Number, y:Number, s:Number) {
			super(x, y);
			this.id = id;
			this.s = s;
		}


		override public function toString():String {
			return '[Feature id=' + id + ' x=' + (int(x * 1000) / 1000) + ' y=' + (int(y * 1000) / 1000) + ' s=' + s + ']';
		}
	}
}
