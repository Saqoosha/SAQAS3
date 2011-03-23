package sh.saqoo.filter {

	import flash.filters.ColorMatrixFilter;
	
	/**
	 * @author Saqoosha
	 */
	public class ColorMatrixFilterFactory {

		
		/**
		 * @see http://en.wikipedia.org/wiki/Luma_(video)
		 */
		public static function luma():ColorMatrixFilter {
			return new ColorMatrixFilter([
				0.2126, 0.7152, 0.0722, 0, 0,
				0.2126, 0.7152, 0.0722, 0, 0,
				0.2126, 0.7152, 0.0722, 0, 0,
				0, 0, 0, 1, 0
			]);
		}
		
		
		public static function invert():ColorMatrixFilter {
			return new ColorMatrixFilter([
				-1,  0,  0, 0, 255,
				 0, -1,  0, 0, 255,
				 0,  0, -1, 0, 255,
				 0,  0,  0, 1, 0
			]);
		}
	}
}
