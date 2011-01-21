package sh.saqoo.filter {
	import flash.filters.ColorMatrixFilter;

	
	/**
	 * @author Saqoosha
	 * @see http://en.wikipedia.org/wiki/Luma_(video)
	 */
	public class LumaFilterFactory {

		
		public static function create():ColorMatrixFilter {
			return new ColorMatrixFilter([
				0.2126, 0.7152, 0.0722, 0, 0,
				0.2126, 0.7152, 0.0722, 0, 0,
				0.2126, 0.7152, 0.0722, 0, 0,
				0, 0, 0, 1, 0
			]);
		}
		
		
	}
}
