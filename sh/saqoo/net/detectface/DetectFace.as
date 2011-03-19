package sh.saqoo.net.detectface {

	import ru.inspirit.net.MultipartURLLoader;

	import com.adobe.images.JPGEncoder;

	import org.osflash.signals.Signal;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	
	/**
	 * Wrapper class for using detectFace(); service.
	 * @author Saqoosha
	 * @see http://detectface.com/
	 */
	public class DetectFace {
		
		
		private var _sigComplete:Signal = new Signal();
		public function get sigComplete():Signal { return _sigComplete; }
		private var _sigError:Signal = new Signal();
		public function get sigError():Signal { return _sigError; }
		
		public var muriyariLevel:int = 0;
		
		private var _loader:MultipartURLLoader;
		private var _response:XML;
		public function get responseXML():XML { return _response; }
		private var _facesInfo:Array;
		public function get facesInfo():Array { return _facesInfo; }
		
		
		public function DetectFace() {
		}
		
		
		public function detect(image:BitmapData):void {
			_loader = new MultipartURLLoader();
			var encoder:JPGEncoder = new JPGEncoder(80);
			_loader.addFile(encoder.encode(image), 'image.jpg', 'imageFile', 'image/jpeg');
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, _onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _onError);
			_loader.load('http://detectface.com/api/detect?f=' + muriyariLevel);
		}


		private function _onComplete(event:Event):void {
			var loader:MultipartURLLoader = MultipartURLLoader(event.target);
			_response = new XML(loader.loader.data);
			trace(_response.toXMLString());
			_facesInfo = [];
			for each (var face:XML in _response.face) {
				_facesInfo.push(new FaceInfo(face));
			}
			_facesInfo.sort(function (a:FaceInfo, b:FaceInfo):int {
				return a.bounds.width * a.bounds.height * (int(a.rightEye) + int(a.leftEye)) - b.bounds.width * b.bounds.height * (int(b.rightEye) + int(b.leftEye));
			});
			_sigComplete.dispatch();
		}


		private function _onError(event:Event):void {
			_sigError.dispatch();
		}
		
		
		public function debugDraw(graphics:Graphics, scale:Number = 1):void {
			for each (var face:FaceInfo in _facesInfo) {
				face.debugDraw(graphics, scale);
			}
		}
	}
}
