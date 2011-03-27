package sh.saqoo.net.facecom {

	import flash.geom.Matrix;
	import sh.saqoo.math.MathUtil;

	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	
	/**
	 * @author Saqoosha
	 */
	public class Tag {
		
		
		private var _width:Number;
		private var _height:Number;
		
		private var _pitch:Number;
		private var _roll:Number;
		private var _yaw:Number;
		
		private var _center:Point;
		private var _earLeft:Point;
		private var _earRight:Point;
		private var _eyeLeft:Point;
		private var _eyeRight:Point;
		private var _nose:Point;
		private var _mouthCenter:Point;
		private var _mouthRight:Point;
		private var _mouthLeft:Point;
//		private var _chin:Point;

		private var _gid:String;
		private var _tid:String;
		private var _uids:Vector.<String>;
		
		private var _recognizable:Boolean;
		private var _threshold:int;
		private var _label:String;
		private var _confirmed:Boolean;
		private var _manual:Boolean;
		
		private var _attributes:Dictionary;
		
		
		public function Tag(data:Object, photoWidth:Number, photoHeight:Number) {
			_width = data.width / 100 * photoWidth;
			_height = data.height / 100 * photoHeight;
			_pitch = data.pitch * MathUtil.toRadian;
			_roll = data.roll * MathUtil.toRadian;
			_yaw = data.yaw * MathUtil.toRadian;
			_center = _convertToPixelSize(data.center, photoWidth, photoHeight);
			_earLeft = _convertToPixelSize(data.ear_left, photoWidth, photoHeight);
			_earRight = _convertToPixelSize(data.ear_right, photoWidth, photoHeight);;
			_eyeLeft = _convertToPixelSize(data.eye_left, photoWidth, photoHeight);;
			_eyeRight = _convertToPixelSize(data.eye_right, photoWidth, photoHeight);;
			_nose = _convertToPixelSize(data.nose, photoWidth, photoHeight);
			_mouthCenter = _convertToPixelSize(data.mouth_center, photoWidth, photoHeight);;
			_mouthLeft = _convertToPixelSize(data.mouth_left, photoWidth, photoHeight);;
			_mouthRight = _convertToPixelSize(data.mouth_right, photoWidth, photoHeight);;
			_gid = data.gid;
			_tid = data.tid;
			_uids = Vector.<String>(data.uids);
			_recognizable = data.recognizable;
			_threshold = data.threshold;
			_label = data.label;
			_confirmed = data.confirmed;
			_manual = data.manual;
			_attributes = new Dictionary();
			for (var kind:String in data.attributes) {
				var att:Object = data.attributes[kind];
				_attributes[kind] = new Attribute(kind, att.value, att.confidence);
			}
		}
		
		
		private static function _convertToPixelSize(tag:Object, photoWidth:Number, photoHeight:Number):Point {
			return tag ? new Point(tag.x / 100 * photoWidth, tag.y / 100 * photoHeight) : null;
		}
		
		
		public function transform(mtx:Matrix):void {
			if (_center) _center = mtx.transformPoint(_center);
			if (_earLeft) _earLeft = mtx.transformPoint(_earLeft);
			if (_earRight) _earLeft = mtx.transformPoint(_earRight);
			if (_eyeLeft) _eyeLeft = mtx.transformPoint(_eyeLeft);
			if (_eyeRight) _eyeRight = mtx.transformPoint(_eyeRight);
			if (_nose) _nose = mtx.transformPoint(_nose);
			if (_mouthCenter) _mouthCenter = mtx.transformPoint(_mouthCenter);
			if (_mouthLeft) _mouthLeft = mtx.transformPoint(_mouthLeft);
			if (_mouthRight) _mouthRight = mtx.transformPoint(_mouthRight);
		}
		
		
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }

		public function get pitch():Number { return _pitch; }
		public function get roll():Number { return _roll; }
		public function get yaw():Number { return _yaw; }

		public function get center():Point { return _center; }
		public function get earLeft():Point { return _earLeft; }
		public function get earRight():Point { return _earRight; }
		public function get eyeLeft():Point { return _eyeLeft; }
		public function get eyeRight():Point { return _eyeRight; }
		public function get nose():Point { return _nose; }
		public function get mouthCenter():Point { return _mouthCenter; }
		public function get mouthLeft():Point { return _mouthLeft; }
		public function get mouthRight():Point { return _mouthRight; }

		public function get gid():String { return _gid; }
		public function get tid():String { return _tid; }
		public function get uids():Vector.<String> { return _uids; }

		public function get recognizable():Boolean { return _recognizable; }
		public function get threshold():int { return _threshold; }
		public function get label():String { return _label; }
		public function get confirmed():Boolean { return _confirmed; }
		public function get manual():Boolean { return _manual; }
		
		public function get gender():Attribute { return _attributes[Attribute.GENDER]; }
		public function get glasses():Attribute { return _attributes[Attribute.GLASSES]; }
		public function get smiling():Attribute { return _attributes[Attribute.SMILING]; }
		public function get face():Attribute { return _attributes[Attribute.FACE]; }
	}
}
