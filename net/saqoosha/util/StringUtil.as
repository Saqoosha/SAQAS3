package net.saqoosha.util {
	import flash.utils.ByteArray;

	
	/**
	 * @author Saqoosha
	 */
	public class StringUtil {
		
		
		public static function encodeURLWithEncoding(data:String, encoding:String):String {
			var b:ByteArray = new ByteArray();
			b.writeMultiByte(data, encoding);
			b.position = 0;
			var encoded:String = '';
			var n:int = b.length;
			while (n--) {
				var val:int = b.readByte() & 0xff;
				if (val < 0x80) {
					encoded += encodeURIComponent(String.fromCharCode(val));
				} else {
					encoded += '%' + val.toString(16);
				}
			}
			return encoded;
		}

		
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
