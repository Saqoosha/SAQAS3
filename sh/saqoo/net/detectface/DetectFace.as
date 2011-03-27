package sh.saqoo.net.detectface {

	import flash.geom.Matrix;
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
		private var _faceInfo:Vector.<FaceInfo>;
		public function get faceInfo():Vector.<FaceInfo> { return _faceInfo; }
		public function get numFaces():uint { return _faceInfo.length; }
		
		private var _scale:Number;
		
		
		public function DetectFace() {
		}
		
		
		public function detect(image:BitmapData, scale:Number = 1.0):void {
			_scale = scale;
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
			parseResponse(loader.loader.data, _scale);
			_sigComplete.dispatch();
		}
		
		
		public function parseResponse(response:String, scale:Number = 1.0):void {
			_response = new XML(response);
			var tmp:Vector.<FaceInfo> = new Vector.<FaceInfo>();
			for each (var face:XML in _response.face) {
				tmp.push(new FaceInfo(face, scale));
			}
			_faceInfo = tmp.sort(function (a:FaceInfo, b:FaceInfo):int {
				var sa:int = 0;
				if (a.rightEye) sa++;
				if (a.leftEye) sa++;
				sa *= a.bounds.width * a.bounds.height;
//				var sa:int = a.bounds.width * a.bounds.height * (int(!!a.rightEye) + int(!!a.leftEye));
				var sb:int = 0;
				if (b.rightEye) sb++;
				if (b.leftEye) sb++;
				sb *= b.bounds.width * b.bounds.height;
//				var sb:int = b.bounds.width * b.bounds.height * (int(!!b.rightEye) + int(!!b.leftEye));
				return sb - sa;
			});
		}


		private function _onError(event:Event):void {
			_sigError.dispatch();
		}
		
		
		public function transform(mtx:Matrix):void {
			for each (var face:FaceInfo in _faceInfo) {
				face.transform(mtx);
			}
		}
		
		
		public function drawDebugInfo(graphics:Graphics, scale:Number = 1):void {
			for each (var face:FaceInfo in _faceInfo) {
				face.drawDebugInfo(graphics, scale);
			}
		}
	}
}
