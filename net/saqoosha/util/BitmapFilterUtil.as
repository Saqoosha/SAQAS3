package net.saqoosha.util {
	
	import flash.filters.ColorMatrixFilter;
	
	public class BitmapFilterUtil {
		
		public static const MONO_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0.2989, 0.5866, 0.1145, 0, 0,
			0.2989, 0.5866, 0.1145, 0, 0,
			0.2989, 0.5866, 0.1145, 0, 0,
			0, 0, 0, 1, 0
		]);
	}
}