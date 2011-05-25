package sh.saqoo.net {

	import com.adobe.serialization.json.JSON;

	import org.osflash.signals.Signal;

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
	/**
	 * @author Saqoosha
	 */
	public class JSONEngine {
		
		
		public var server:String;
		
		private var _reqId:int = 0;
		private var _sigComplete:Signal = new Signal(int);
		
		
		public function get sigComplete():Signal { return _sigComplete; }
		
		
		public function JSONEngine(server:String) {
			this.server = server;
		}
		
		
		public function get(docType:String, docId:String = null):int {
			var url:String = server + docType;
			if (docId) url += '/' + docId;
			return _request(url, URLRequestMethod.GET);
		}
		
		
		public function put(docType:String, doc:Object, docId:String = null, checkUpdatesAfter:Boolean = false):int {
			var vars:URLVariables = new URLVariables();
			vars._doc = JSON.encode(doc);
			if (checkUpdatesAfter) vars._checkUpdatesAfter = 1;
			var url:String = server + docType;
			if (docId) url += '/' + docId;
			return _request(url, URLRequestMethod.POST, vars);
		}
		
		
		public function del(docType:String, docId:String, checkUpdatesAfter:Boolean = false):int {
			var vars:URLVariables = new URLVariables();
			vars._ = '';
			if (checkUpdatesAfter) vars._checkUpdatesAfter = 1;
			var url:String = server + docType + '/' + docId + '?_method=delete';
			return _request(url, URLRequestMethod.POST, vars);
		}
		
		
		private function _request(url:String, method:String, vars:URLVariables = null):int {
			var reqid:int = _reqId++;
			var req:URLRequest = new URLRequest(url);
			req.method = method;
			if (vars) req.data = vars;
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				var res:* = loader.data;
				try {
					res = JSON.decode(loader.data);
				} catch (e:Error) {
				}
				_sigComplete.dispatch(reqid, res);
			});
			loader.load(req);
			return reqid;
		}
	}
}
