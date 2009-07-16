package net.saqoosha.geom {
	
	public class Range {
		
		public static function isValueInRange(value:Number, min:Number, max:Number):Boolean {
			return min <= value && value <= max;
		}
		
		public static function limitValueInRange(value:Number, min:Number, max:Number):Number {
			return value < min ? min : max < value ? max : value;
//			return Math.max(min, Math.min(max, value));
		}
		
	}
	
}