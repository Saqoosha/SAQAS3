package net.saqoosha.midi.event {

	
	/**
	 * @author Saqoosha
	 */
	public class SMFEvent {
		
		
		public static const TYPE_MIDI:int = 1;
		public static const TYPE_SYSEX:int = 2;
		public static const TYPE_META:int = 3;
		
		private static var TYPE_NAME_TABLE:Object = {};
		
		{
			TYPE_NAME_TABLE[TYPE_MIDI] = 'MIDI';
			TYPE_NAME_TABLE[TYPE_SYSEX] = 'SYSEX';
			TYPE_NAME_TABLE[TYPE_META] = 'META';
		}
		
		
		//
		
		
		private var _deltaTime:int;
		private var _type:int;
		
		
		public function SMFEvent(deltaTime:int, type:int) {
			_deltaTime = deltaTime;
			_type = type;
		}
		
		
		public function get deltaTime():int {
			return _deltaTime;
		}
		
		
		public function set deltaTime(value:int):void {
			_deltaTime = value;
		}

		
		public function get type():int {
			return _type;
		}
		
		
		public function set type(value:int):void {
			_type = value;
		}
		
		
		public function toString():String {
			return '[SMFEvent delta=' + _deltaTime + ' type=' + TYPE_NAME_TABLE[_type] + '(' + _type + ')]';
		}
	}
}
