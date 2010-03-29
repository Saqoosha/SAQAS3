package net.saqoosha.util {

	
	/**
	 * @author Saqoosha
	 */
	public class StringUtil {
		
		
		public static function trim(str:String):String {
			 return str.match(/^\s*(.*)\s*$/)[1];
		}
		
		
		public static function stripTags(str:String):String {
			return new XML('<a>' + str + '</a>').text();
		}
		
		
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
