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
				callback(JSON.decode(loader.loader.data));
			});
			loader.load(API_ENDPOINT + 'faces/detect.json');
		}
		
		
		//
		
		
		public static function convertToPixelSize(tag:Object, width:Number, height:Number):void {
			if (tag['photos']) {
				for each (var photo:Object in tag.photos) {
					for each (var t:Object in photo.tags) {
						_convertToPixelSize(t, width, height);
					}
				}
			} else {
				_convertToPixelSize(tag, width, height);
			}
		}
		
		
		private static function _convertToPixelSize(tag:Object, width:Number, height:Number):void {
			var w:Number = width / 100;
			var h:Number = height / 100;
			tag.width *= w;
			tag.height *= h;
			for each (var key:String in SIZE_NAME) {
				var p:Object = tag[key];
				if (p) tag[key] = new Point(p.x * w, p.y * h);
			}
		}
		
		
		public static function extractFace(image:BitmapData, tag:Object, mtx:Matrix = null):BitmapData {
			mtx ||= new Matrix();
			mtx.identity();
			mtx.translate(-tag.center.x, -tag.center.y);
			mtx.rotate(-tag.roll * Math.PI / 180);
			mtx.translate(tag.width / 2, tag.height / 2);
			var face:BitmapData = new BitmapData(tag.width, tag.height);
			face.draw(image, mtx, null, null, null, true);
			return face;
		}
		
		
		public static function extractMouth(image:BitmapData, tag:Object, mtx:Matrix = null):BitmapData {
			mtx ||= new Matrix();
			mtx.identity();
			mtx.translate(-tag.mouth_center.x, -tag.mouth_center.y);
			var p:Point = tag.mouth_right.subtract(tag.mouth_left);
			mtx.rotate(-Math.atan2(p.y, p.x));
			var left:Point = mtx.transformPoint(tag.mouth_left);
			var right:Point = mtx.transformPoint(tag.mouth_right);
			var len:Number = p.length;
			var mouth:BitmapData = new BitmapData(len * 1.3, len * 0.66 * 1.3);
			mtx.translate(-(right.x + left.x) * 0.5 + mouth.width * 0.5, mouth.height * 0.5);
			mouth.draw(image, mtx, null, null, null, true);
			return mouth;
		}
		
		
		public static function extractEye(image:BitmapData, tag:Object, right:Boolean = true, mtx:Matrix = null):BitmapData {
			mtx ||= new Matrix();
			mtx.identity();
			var e:Point = right ? tag.eye_right : tag.eye_left;
			mtx.translate(-e.x, -e.y);
			var p:Point = tag.eye_right.subtract(tag.eye_left);
			mtx.rotate(-Math.atan2(p.y, p.x));
			var len:Number = Point.distance(tag.mouth_left, tag.mouth_right);
			var eye:BitmapData = new BitmapData(len, len * 0.66);
			mtx.translate(eye.width * 0.5, eye.height * 0.5);
			eye.draw(image, mtx, null, null, null, true);
			return eye;
		}
		
		
		public static function extractNose(image:BitmapData, tag:Object, mtx:Matrix = null):BitmapData {
			mtx ||= new Matrix();
			mtx.identity();
			mtx.translate(-tag.nose.x, -tag.nose.y);
			mtx.rotate(-tag.roll * Math.PI / 180);
			var len:Number = Point.distance(tag.mouth_right, tag.mouth_left);
			var nose:BitmapData = new BitmapData(len, len * 0.8);
			mtx.translate(len * 0.5, len * 0.6);
			nose.draw(image, mtx, null, null, null, true);
			return nose;
		}
	}
}
