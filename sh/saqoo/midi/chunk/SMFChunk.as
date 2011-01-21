package sh.saqoo.midi.chunk {

	
	/**
	 * @author Saqoosha
	 */
	public class SMFChunk {
		
		
		public static const TYPE_HEADER:int = 0x4d546864;
		public static const TYPE_TRACK:int = 0x4d54726b;
		
		
		protected var _type:int;
		
		
		public function SMFChunk(type:uint):void {
			_type = type;
		}
		
		
		public function get type():int {
			return _type;
		}
		
		
		public function set type(value:int):void {
			_type = value;
		}
		
		
		public function toString():String {
			return '[SMFChunk type=' + _type + ']';
		}
	}
}
