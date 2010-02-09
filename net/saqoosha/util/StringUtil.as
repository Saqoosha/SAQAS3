package net.saqoosha.util {

	
	/**
	 * @author Saqoosha
	 */
	public class StringUtil {
		
		public static function toHex(value:*, width:int = 0):String {
			return ('00000000' + value.toString(16)).substr(-width);
		}
	}
}
