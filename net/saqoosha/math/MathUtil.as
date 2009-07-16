package net.saqoosha.math {
	
	public class MathUtil {
		
		public static function randomInRange(low:Number, high:Number):Number {
			return low + (high - low) * Math.random();
		}
	}
}