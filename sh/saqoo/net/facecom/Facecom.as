package sh.saqoo.net.facecom {

	import ru.inspirit.net.MultipartURLLoader;

	import com.adobe.images.JPGEncoder;
	import com.adobe.serialization.json.JSON;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;

	/**
	 * Face.com API wrapper.
	 * Requires inspirit's MultipartURLLoader. http://code.google.com/p/in-spirit/wiki/MultipartURLLoader
	 * @author Saqoosha
	 */
	public class Facecom {


		public static const API_ENDPOINT:String = 'http://api.face.com/';
		
		public static const DETECTOR_NORMAL:String = 'Normal';
		public static const DETECTOR_AGGRESSIVE:String = 'Aggressive';
		

		private var _apiKey:String;
		private var _apiSecret:String;
		
		private var _result:Object;
		private var _status:String;
		private var _usage:Usage;
		private var _photos:Vector.<PhotoInfo>;
		
		private var _errorCode:int;
		private var _errorMessage:String;
		
		
		public function Facecom(apiKey:String, apiSecret:String) {
			_apiKey = apiKey;
			_apiSecret = apiSecret;
		}
		
		
		public function detect(urlOrData:*, callback:Function, detector:String = DETECTOR_NORMAL):void {
			_result = null;
			_status = null;
			_usage = null;
			_photos = null;
			_errorCode = 0;
			_errorMessage = null;
			
			var width:Number = 0;
			var height:Number = 0;
			var loader:MultipartURLLoader = new MultipartURLLoader();
			switch (true) {
				case urlOrData is String:
					loader.addVariable('urls', urlOrData);
					break;
				case urlOrData is Array:
					loader.addVariable('urls', urlOrData.join(','));
					break;
				case urlOrData is BitmapData:
					var target:BitmapData = urlOrData;
					width = target.width;
					height = target.height;
					var encoder:JPGEncoder = new JPGEncoder(80);
					loader.addFile(encoder.encode(resizeImage(target)), 'image.jpg', 'imageFile', 'image/jpeg');
					break;
				case urlOrData is ByteArray:
					loader.addFile(urlOrData, 'image.jpg', 'imageFile', 'image/jpeg');
					break;
				default:
					throw new ArgumentError();
			}
			
			loader.addVariable('api_key', _apiKey);
			loader.addVariable('api_secret', _apiSecret);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function (e:Event):void {
				_result = JSON.decode(loader.loader.data);
				_status = _result.status;
				if (_status == 'success') {
					_usage = new Usage(_result.usage);
					_photos = new Vector.<PhotoInfo>();
					for each (var photo:Object in _result.photos) {
						_photos.push(new PhotoInfo(photo, width, height));
					}
				} else {
					_errorCode = _result.error_code;
					_errorMessage = _result.error_message;
				}
				callback(_status);
			});
			loader.load(API_ENDPOINT + 'faces/detect.json');
		}
		
		
		public function resizeImage(original:BitmapData):BitmapData {
			var width:int = original.width;
			var height:int = original.height;
			var t:BitmapData;
			if (width > 900 || height > 900) {
				var a:Number = Math.min(900 / width, 900 / height);
				t = new BitmapData(width * a, height * a, false, 0x0);
				t.draw(original, new Matrix(a, 0, 0, a, 1, 1), null, null, null, true);
				return t;
			} else {
				return original;
			}
		}
		
		
		public function drawDebugInfo(graphics:Graphics):void {
			for each (var photo:PhotoInfo in _photos) {
				photo.drawDebugInfo(graphics);
			}
		}
		
		
		public function get result():Object { return _result; }
		public function get status():String { return _status; }
		public function get usage():Usage { return _usage; }
		public function get photos():Vector.<PhotoInfo> { return _photos; }
		public function get numPhotos():uint { return _photos ? _photos.length : 0; }
		
		public function get errorCode():int { return _errorCode; }
		public function get errorMessage():String { return _errorMessage; }
	}
}
