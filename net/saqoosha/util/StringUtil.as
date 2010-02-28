package net.saqoosha.util {

	
	/**
	 * @author Saqoosha
	 */
	public class StringUtil {
		
		
		public static function toHex(value:*, width:int = 0):String {
			return ('00000000' + value.toString(16)).substr(-width);
		}
		

		/**
		 * @see http://1ka2ka.com/archives/200808/27_122039.html
		 */
		public static function intToStringWithComma(value:int):String {
			return value.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
		}
	}
}
