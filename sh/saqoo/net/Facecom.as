package sh.saqoo.net {

	import ru.inspirit.net.MultipartURLLoader;

	import com.adobe.images.JPGEncoder;
	import com.adobe.serialization.json.JSON;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
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
		
		private static const SIZE_NAME:Array = ['center', 'eye_right', 'eye_left', 'nose', 'mouth_right', 'mouth_center', 'mouth_left', 'ear_right', 'ear_left'];


		private var _apiKey:String;
		private var _apiSecret:String;
		
		
		public function Facecom(apiKey:String, apiSecret:String) {
			_apiKey = apiKey;
			_apiSecret = apiSecret;
		}
		
		
		public function detect(urlOrData:*, callback:Function, detector:String = DETECTOR_NORMAL):void {
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
					var t:BitmapData;
					if (target.width > 900 || target.height > 900) {
						var a:Number = Math.min(900 / target.width, 900 / target.height);
						t = new BitmapData(target.width * a, target.height * a, false, 0x0);
						t.draw(target, new Matrix(a, 0, 0, a, 1, 1), null, null, null, true);
						target = t;
					}
					var encoder:JPGEncoder = new JPGEncoder(80);
					loader.addFile(encoder.encode(target), 'image.jpg', 'imageFile', 'image/jpeg');
					if (t) {
						t.dispose();
					}
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
				var data:Object = JSON.decode(loader.loader.data);
				for each (var photo:Object in data.photos) {
					var width:Number = photo.width;
					var height:Number = photo.height;
					for each (var tag:Object in photo.tags) {
						convertToPixelSize(tag, width, height);
					}
				}
				callback(data);
			});
			loader.load(API_ENDPOINT + 'faces/detect.json');
		}
		
		
		public function convertToPixelSize(tag:Object, width:Number, height:Number):void {
			var w:Number = width / 100;
			var h:Number = height / 100;
			tag.width *= w;
			tag.height *= h;
			for each (var key:String in SIZE_NAME) {
				var p:Object = tag[key];
				if (p) tag[key] = new Point(p.x * w, p.y * h);
			}
		}
	}
}
