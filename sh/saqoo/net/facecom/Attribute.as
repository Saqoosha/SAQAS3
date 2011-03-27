package sh.saqoo.net.facecom {


	/**
	 * @author Saqoosha
	 */
	public class Attribute {
		
		
		public static const GENDER:String = 'gender';
		public static const GLASSES:String = 'glasses';
		public static const SMILING:String = 'smiling';
		public static const FACE:String = 'face';
		
		
		private var _kind:String;
		private var _value:Boolean;
		private var _confidence:int;
		
		
		public function Attribute(kind:String, value:Boolean, confidence:int) {
			_kind = kind;
			_value = value;
			_confidence = confidence;
		}
		
		
		public function get kind():String { return _kind; }
		public function get value():Boolean { return _value; }
		public function get confidence():int { return _confidence; }
	}
}
