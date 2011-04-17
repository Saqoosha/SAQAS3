package sh.saqoo.util {

	import sh.saqoo.net.navigateToURL;

	import flash.net.URLVariables;

	/**
	 * @author Saqoosha
	 */
	public class ShareUtil {
		
		
		public static function onTwitter(text:String):void {
			navigateToURL('http://twitter.com/?status=' + encodeURIComponent(text));
		}
		
		
		public static function onFacebook(url:String, text:String = ''):void {
			var v:URLVariables = new URLVariables();
			v.u = url;
			v.t = text;
			navigateToURL('http://www.facebook.com/sharer.php?' + v);
		}
		
		
		public static function onMixiCheck(key:String, url:String):void {
			var v:URLVariables = new URLVariables();
			v.k = key;
			v.u = url;
			navigateToURL('http://mixi.jp/share.pl?' + v);
		}
		
		
		public static function onDelicious(url:String, title:String = '', notes:String = ''):void {
			var v:URLVariables = new URLVariables();
			v.url = url;
			v.title = title;
			v.notes = notes;
			navigateToURL('http://www.delicious.com/save?' + v);
		}
		
		
		public static function onMail(subject:String, body:String, to:String = ''):void {
			var v:URLVariables = new URLVariables();
			v.subject = subject;
			v.body = body;
			v.to = to;
			navigateToURL('mailto:?' + v);
		}
	}
}
