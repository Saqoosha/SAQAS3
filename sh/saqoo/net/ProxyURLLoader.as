package sh.saqoo.net {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	
	/**
	 * @author Saqoosha
	 * Avoid cross domain security. Use with proxy.php.
	 * Additionally, you can send any http header which is not supported standard URLRequest class.
	 */
	public class ProxyURLLoader extends EventDispatcher {

		
		private var _gateway:String;
		private var _loader:URLLoader;

		
		public function ProxyURLLoader(gateway:String = 'proxy.php') {
			_gateway = gateway;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, dispatchEvent);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
		}
	
		
		public function load(url:String, method:String = 'GET', data:* = null, header:* = null):void {
			var vars:URLVariables = new URLVariables();
			vars._url = url;
			vars._method = method;
			if (data is String) {
				vars._data = data;
			} else if (data is Object) {
				vars._data = _toURLVars(data);
			}
			if (header is String) {
				vars._header = header;
			} else if (header is Object) {
				vars._header = _toURLVars(header);
			}
			
			var request:URLRequest = new URLRequest(_gateway);
			request.method = URLRequestMethod.POST;
			request.data = vars;

			_loader.load(request);
		}
	
		
		private function _toURLVars(object:Object):URLVariables {
			if (object is URLVariables) return object as URLVariables;
			var v:URLVariables = new URLVariables();
			for (var key:String in object) {
				v[key] = object[key];
			}
			return v;				
		}
		
		
		public function get dataFormat():String { return _loader.dataFormat; }
		public function set dataFormat(value:String):void { _loader.dataFormat = value; }
		
		public function get data():* { return _loader.data; }
		
		
	}
}
