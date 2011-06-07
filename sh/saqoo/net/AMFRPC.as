package sh.saqoo.net {

	import sh.saqoo.logging.dump;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	[Event(name="error", type="flash.events.ErrorEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * @author Saqoosha
	 */
	public class AMFRPC extends EventDispatcher {


		public static var DEFAULT_GATEWAY:String;
		public static var DEBUG_OUT:Boolean = false;
		private static var NEXT_RESPONSE_ID:int = 1;


		public static function call(gateway:String, method:String, args:Array, callback:Function):void {
			var rpc:AMFRPC = new AMFRPC(gateway);
			rpc.addEventListener(Event.COMPLETE, function(e:Event):void {
				rpc.removeEventListener(Event.COMPLETE, arguments.callee);
				callback(rpc.result);
			});
			rpc.call.apply(rpc, [method].concat(args));
		}


		//


		private var _gateway:String;
		private var _useNetConnection:Boolean;
		private var _loader:URLLoader;
		private var _isError:Boolean = false;
		protected var _result:Object;


		public function get gateway():String { return _gateway; }
		public function set gateway(value:String):void { _gateway = value; }
		public function get useNetConnection():Boolean { return _useNetConnection; }
		public function set useNetConnection(value:Boolean):void { _useNetConnection = value; }
		public function get result():Object { return _result; }


		public function AMFRPC(gateway:String = null, useNetConnection:Boolean = false) {
			_gateway = gateway || DEFAULT_GATEWAY;
			_useNetConnection = useNetConnection;
		}
		
		
		public function call(method:String, ...args):void {
			if (!_gateway) throw new ArgumentError('please specify gateway...');
			
			if (_useNetConnection) {
				var conn:NetConnection = new NetConnection();
				conn.connect(_gateway);
				conn.call.apply(conn, [method, new Responder(_onComplete0)].concat.apply(null, args));
				
			} else {
				var amf3:Boolean;
				var bodyByte:ByteArray = new ByteArray();
				bodyByte.objectEncoding = ObjectEncoding.AMF0; 
				bodyByte.writeByte(0x0A); // AMF0 array type
				bodyByte.writeInt(args.length); // length of AMF0 arguments array
				for each (var arg:* in args) {
					switch (true) {
						case arg is Object: amf3 = true; break;
						default: amf3 = false;
					}
					if (amf3) {
						bodyByte.writeByte(0x11); // AVM+ marker
						bodyByte.objectEncoding = ObjectEncoding.AMF3; 
					}
					bodyByte.writeObject(arg);
					bodyByte.objectEncoding = ObjectEncoding.AMF0;
				}
				
				var responseId:String = '/' + NEXT_RESPONSE_ID++; // responce ID
				
				var messageByte:ByteArray = new ByteArray();
				messageByte.objectEncoding = ObjectEncoding.AMF0; // should be AMF0
				messageByte.writeShort(0x03); // AMF version
				messageByte.writeShort(0x00); // Number of headers (No header)
				messageByte.writeShort(0x01); // Number of body
				messageByte.writeUTF(method); // remote method name
				messageByte.writeUTF(responseId); // responce id
				messageByte.writeInt(bodyByte.length); // size of serialized body
				messageByte.writeBytes(bodyByte); // serialized body data
	
				var request:URLRequest = new URLRequest(_gateway);
				request.method = URLRequestMethod.POST;
				request.data = messageByte;
				request.requestHeaders = [new URLRequestHeader('Content-Type', 'application/x-amf')];
	
				_isError = false;
				_loader = new URLLoader();
				_loader.dataFormat = URLLoaderDataFormat.BINARY;
				_loader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
				_loader.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
				_loader.addEventListener(Event.COMPLETE, _onComplete);
				_loader.load(request);
			}
		}
		
		
		private function _onComplete0(result:Object):void {
			dump(result);
		}


		private function _onComplete(event:Event):void {
			try {
				_parseResponse(_loader.data);
			} catch (e:Error) {
				_isError = true;
				trace(e.getStackTrace());
			}

			_loader.removeEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			_loader.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			_loader.removeEventListener(Event.COMPLETE, _onComplete);
			_loader = null;

			if (_isError) {
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, _result.description));
			} else {
				dispatchEvent(event);
			}
		}


		protected function _parseResponse(data:ByteArray):void {
			data.objectEncoding = ObjectEncoding.AMF0;
			data.readShort(); // AMF version
			var numHeaders:int = data.readShort();
			for (var i:int = 0; i < numHeaders; ++i) {
				_readHeader(data);
			}
			var numBodies:int = data.readShort(); // always 1?
			for (i = 0; i < numBodies; ++i) {
				_readBody(data);
			}
		}

		
		private function _readHeader(data:ByteArray):void {
			if (DEBUG_OUT) trace('_readHeader: from', data.position.toString(16));
			var name:String = data.readUTF();
			var required:Boolean = data.readBoolean();
			var length:int = data.readInt();
			var content:* = data.readObject();
			if (DEBUG_OUT) dump({
				name: name,
				required: required,
				length: length,
				content: content
			});
		}

		
		private function _readBody(data:ByteArray):void {
			if (DEBUG_OUT) trace('_readBody: from', data.position.toString(16));
			var target:String = data.readUTF();
			_isError = target.split('/')[2] != 'onResult';
			var response:String = data.readUTF();
			var length:int = data.readInt();
			if (data[data.position] == 0x11) { // AVM+ marker?
				data.position++;
				data.objectEncoding = ObjectEncoding.AMF3;
			}
			_result = data.readObject();
			if (DEBUG_OUT) dump({
				target: target,
				response: response,
				length: length,
				content: _result
			});
			data.objectEncoding = ObjectEncoding.AMF0;
		}
	}
}
