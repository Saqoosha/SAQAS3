package sh.saqoo.math {

	
	public class MathUtil {


		public static const toRadian:Number = Math.PI / 180;
		public static const toDegree:Number = 180 / Math.PI;

		
		public static function randomInRange(low:Number, high:Number):Number {
			return low + (high - low) * Math.random();
		}
	}
}
