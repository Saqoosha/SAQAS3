package sh.saqoo.util {

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
		
		
		/**
		 * roman -> hiragana
		 * @see http://d.hatena.ne.jp/Kureduki_Maari/20100330/1269906760
		 * @param (String) roman:
		 * @return (String): hiragana
		 */
		public static function roman2hiragana(roman:String):String {
			var hiragana:String = '',
				table:Object = _r2hTable,
				regex:RegExp = _r2hRx,
				result:Array,
				i:int, l:int;
			for (i = 0, l = roman.length; i < l; ++i) {
				if ((result = roman.slice(i).match(regex))) {
					if (result[0] === 'n') {
						hiragana += 'ん';
					} else if ((/^([^n])\1$/).test(result[0])) {
						hiragana += 'っ';
						--i;
					} else {
						hiragana += table[result[0]];
					}
					i += result[0].length - 1;
				} else {
					hiragana += roman.charAt(i);
				}
			}
			return hiragana;
		}
		
		private static const _r2hTable:Object = {
			'a':'あ', 'i':'い', 'u':'う', 'e':'え', 'o':'お',
			'ka':'か', 'ki':'き', 'ku':'く', 'ke':'け', 'ko':'こ',
			'sa':'さ', 'si':'し', 'su':'す', 'se':'せ', 'so':'そ',
			'ta':'た', 'ti':'ち', 'tu':'つ', 'te':'て', 'to':'と', 'chi':'ち', 'tsu':'つ',
			'na':'な', 'ni':'に', 'nu':'ぬ', 'ne':'ね', 'no':'の',
			'ha':'は', 'hi':'ひ', 'hu':'ふ', 'he':'へ', 'ho':'ほ', 'fu':'ふ',
			'ma':'ま', 'mi':'み', 'mu':'む', 'me':'め', 'mo':'も',
			'ya':'や', 'yi':'い', 'yu':'ゆ', 'ye':'いぇ', 'yo':'よ',
			'ra':'ら', 'ri':'り', 'ru':'る', 're':'れ', 'ro':'ろ',
			'wa':'わ', 'wyi':'ゐ', 'wu':'う', 'wye':'ゑ', 'wo':'を',
			'nn':'ん',
			'ga':'が', 'gi':'ぎ', 'gu':'ぐ', 'ge':'げ', 'go':'ご',
			'za':'ざ', 'zi':'じ', 'zu':'ず', 'ze':'ぜ', 'zo':'ぞ', 'ji':'じ',
			'da':'だ', 'di':'ぢ', 'du':'づ', 'de':'で', 'do':'ど',
			'ba':'ば', 'bi':'び', 'bu':'ぶ', 'be':'べ', 'bo':'ぼ',
			'pa':'ぱ', 'pi':'ぴ', 'pu':'ぷ', 'pe':'ぺ', 'po':'ぽ',
			'kya':'きゃ', 'kyu':'きゅ', 'kyo':'きょ',
			'sya':'しゃ', 'syu':'しゅ', 'syo':'しょ',
			'tya':'ちゃ', 'tyi':'ちぃ', 'tyu':'ちゅ', 'tye':'ちぇ', 'tyo':'ちょ', 'cha':'ちゃ', 'chu':'ちゅ', 'che':'ちぇ', 'cho':'ちょ',
			'nya':'にゃ', 'nyi':'にぃ', 'nyu':'にゅ', 'nye':'にぇ', 'nyo':'にょ',
			'hya':'ひゃ', 'hyi':'ひぃ', 'hyu':'ひゅ', 'hye':'ひぇ', 'hyo':'ひょ',
			'mya':'みゃ', 'myi':'みぃ', 'myu':'みゅ', 'mye':'みぇ', 'myo':'みょ',
			'rya':'りゃ', 'ryi':'りぃ', 'ryu':'りゅ', 'rye':'りぇ', 'ryo':'りょ',
			'gya':'ぎゃ', 'gyi':'ぎぃ', 'gyu':'ぎゅ', 'gye':'ぎぇ', 'gyo':'ぎょ',
			'zya':'じゃ', 'zyi':'じぃ', 'zyu':'じゅ', 'zye':'じぇ', 'zyo':'じょ',
			'ja':'じゃ', 'ju':'じゅ', 'je':'じぇ', 'jo':'じょ', 'jya':'じゃ', 'jyi':'じぃ', 'jyu':'じゅ', 'jye':'じぇ', 'jyo':'じょ',
			'dya':'ぢゃ', 'dyi':'ぢぃ', 'dyu':'ぢゅ', 'dye':'ぢぇ', 'dyo':'ぢょ',
			'bya':'びゃ', 'byi':'びぃ', 'byu':'びゅ', 'bye':'びぇ', 'byo':'びょ',
			'pya':'ぴゃ', 'pyi':'ぴぃ', 'pyu':'ぴゅ', 'pye':'ぴぇ', 'pyo':'ぴょ',
			'fa':'ふぁ', 'fi':'ふぃ', 'fe':'ふぇ', 'fo':'ふぉ',
			'fya':'ふゃ', 'fyu':'ふゅ', 'fyo':'ふょ',
			'xa':'ぁ', 'xi':'ぃ', 'xu':'ぅ', 'xe':'ぇ', 'xo':'ぉ', 'la':'ぁ', 'li':'ぃ', 'lu':'ぅ', 'le':'ぇ', 'lo':'ぉ',
			'xya':'ゃ', 'xyu':'ゅ', 'xyo':'ょ',
			'xtu':'っ', 'xtsu':'っ',
			'wi':'うぃ', 'we':'うぇ',
			'va':'ヴぁ', 'vi':'ヴぃ', 'vu':'ヴ', 've':'ヴぇ', 'vo':'ヴぉ'
		};
		private static const _r2hRx:RegExp = new RegExp((function():String {
			var s:String = '^(?:', key:String;
			for (key in _r2hTable) {
				s += key + '|';
			}
			return s + '(?:n(?![aiueo]|y[aiueo]|$))|' + '([^aiueon])\\1' + ')';
		})());
	}
}
