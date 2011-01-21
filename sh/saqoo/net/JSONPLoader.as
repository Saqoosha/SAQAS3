package sh.saqoo.net {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]

	
	/**
	 * @author Saqoosha
	 * @see http://d.hatena.ne.jp/secondlife/20070918/1190119420
	 * @see http://d.hatena.ne.jp/yuushimizu/20090128/1233146321
	 */
	public class JSONPLoader extends EventDispatcher {

		
		public static var callbackObjects:Dictionary;
		public static var inited:Boolean = false;


		public static function allowCurrentDomain():void {
			var domain:String = _execExternalInterface('return location.host.split(":", 2)[0]');
			Security.allowDomain(domain);
		}

		
		protected static function _init():void {
			inited = true;
			ExternalInterface.addCallback('jsonpCallbacks', _jsonpCallbacks);
			_execExternalInterface(<![CDATA[
window._JSONPLoader = function (url, callback, error) {
	url += (url.indexOf('?') == -1 ? '?' : '&') + 'callback=hoge';
	var f = document.createElement('iframe');
	f.style.display = 'none';
	document.body.appendChild(f);
	var d = f.contentWindow.document;
	var onload = function() {
		if (d["__JSONPResult"] != undefined) {
			callback(d["__JSONPResult"]);
		} else if (error != undefined) {
			error();
		}
		//document.body.removeChild(f);
    };
    if (f.readyState) {
		f.onreadystatechange = function() {
			if (this.readyState == 'complete') onload();
		};
	} else {
		f.onload = onload;
	}
	d.open();
	d.write(
		'<' + 'script type="text/javascript">' +
			'function hoge(v) {' +
				'document["__JSONPResult"] = v;' +
			'};' +
		'</' + 'script>' +
		'<' + 'script type="text/javascript" src="' + url + '"></' + 'script>'
	);
	d.close();
}
			]]>);
		}

		
		protected static function _addJSCallback(callbackFuncName:String, func:Function):void {
			callbackObjects ||= new Dictionary();
			callbackObjects[callbackFuncName] = func;
			_execExternalInterface(
				'if (!window._JSONPLoaderCallbacks) window._JSONPLoaderCallbacks = {};' +
				'window._JSONPLoaderCallbacks["' + callbackFuncName + '"] = function (obj) {' +
				'	document.getElementsByName("' + ExternalInterface.objectID + '")[0].jsonpCallbacks("' + callbackFuncName + '", obj)' +
				'};'
			);
		}

		
		protected static function _removeJSCallback(callbackFuncName:String):void {
			_execExternalInterface(
				'if (window._JSONPLoaderCallbacks) window._JSONPLoaderCallbacks["' + callbackFuncName + '"] = function() {};'
			);
		}


		protected static function _jsonpCallbacks(callbackFuncName:String, obj:*):void {
			var func:Function = callbackObjects[callbackFuncName] as Function;
			if (func is Function) {
				func(obj);
			} else {
				new Error('Cannot find callback(' + callbackFuncName + ').');
			}
		}

		
		protected static function _execExternalInterface(cmd:String):* {
			cmd = "(function() {" + cmd + ";})";
//			dump('_execExternalInterface', cmd);
			return ExternalInterface.call(cmd);
		}

		
		//
		
		
		public var data:Object;
		public var timeout:Number = 10;
		
		protected var _callbackFuncName:String;
		protected var _timerId:int = 0;


		public function JSONPLoader():void {
			if (!ExternalInterface.available) throw new IllegalOperationError('ExternalInterface.available should be true.');
			if (!inited) _init();
		}

		
		public function load(url:String):void {
			_cleanup();
			
			var cb:String = _callbackFuncName = '_' + (new Date()).getTime().toString();
			_addJSCallback(cb, _onLoadComplete);
			_addJSCallback(cb + '_error', _onLoadError);

			_execExternalInterface(
				'window._JSONPLoader("' + url + '", _JSONPLoaderCallbacks.' + cb + ', _JSONPLoaderCallbacks.' + cb + '_error)'
			);
			
			_timerId = setTimeout(_onTimeout, timeout * 1000);
		}

		
		private function _cleanup():void {
			_removeJSCallback(_callbackFuncName);
			_removeJSCallback(_callbackFuncName + '_error');
			if (_timerId) {
				clearTimeout(_timerId);
				_timerId = 0;
			}
		}

		
		private function _onTimeout():void {
			_cleanup();
			data = null;
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, 'Request timeout'));
		}

		
		private function _onLoadError(data:*):void {
			_cleanup();
			data = null;
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, 'Unknown Error...(HTTP status isn\'t 200?)'));
		}

		
		private function _onLoadComplete(data:*):void {
			_cleanup();
			this.data = data;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
