package sh.saqoo.net {

	import com.adobe.serialization.json.JSON;

	import org.osflash.signals.Signal;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * @author Saqoosha
	 */
	public class JSONLoader {


		public static function load(url:String, onComplete:Function, onError:Function = null):void {
			var loader:JSONLoader = new JSONLoader();
			loader.sigComplete.add(onComplete);
			if (onError is Function) loader.sigError.add(onError);
			loader.load(new URLRequest(url));
		}

		//

		private var _loader:URLLoader;
		private var _data:Object;
		private var _sigComplete:Signal = new Signal(Object);
		private var _sigError:Signal = new Signal(String);

		//

		public function get data():Object { return _data; }
		public function get sigComplete():Signal { return _sigComplete; }
		public function get sigError():Signal { return _sigError; }

		//

		public function JSONLoader() {
		}


		public function load(request:URLRequest):void {
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, _onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _onError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onError);
			_loader.load(request);
		}


		public function cleanup():void {
			_loader.removeEventListener(Event.COMPLETE, _onComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onError);
			_loader = null;
			_data = null;
			_sigComplete.removeAll();
			_sigError.removeAll();
		}


		private function _onComplete(e:Event):void {
			try {
				_data = JSON.decode(_loader.data);
			} catch (e:Error) {
				_sigError.dispatch('JSON parse error.');
				return;
			}
			_sigComplete.dispatch(_data);
		}


		private function _onError(e:ErrorEvent):void {
			if (_sigError.numListeners) {
				_sigError.dispatch(e.text);
			} else {
				throw e;
			}
		}
	}
}
