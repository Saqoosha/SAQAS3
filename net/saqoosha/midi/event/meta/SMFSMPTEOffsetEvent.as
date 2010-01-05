package net.saqoosha.midi.event.meta {
	import net.saqoosha.midi.event.SMFMetaEvent;

	/**
	 * @author hiko
	 */
	public class SMFSMPTEOffsetEvent extends SMFMetaEvent {

		
		private var _hour:int;
		private var _minute:int;
		private var _second:int;
		private var _frame:int;
		
		
		public function SMFSMPTEOffsetEvent(deltaTime:int, hour:int = 0, minute:int = 0, second:int = 0, frame:int = 0) {
			super(deltaTime, SMFMetaEvent.TYPE_SMPTE_OFFSET);
			_hour = hour;
			_minute = minute;
			_second = second;
			_frame = frame;
		}

		
		public function get hour():int {
			return _hour;
		}
		
		
		public function set hour(value:int):void {
			_hour = value;
		}
		
		
		public function get minute():int {
			return _minute;
		}

		
		public function set minute(value:int):void {
			_minute  = value;
		}
		
		
		public function get second():int {
			return _second;
		}
		
		
		public function set second(value:int):void {
			_second = value;
		}
		
		
		public function get frame():int {
			return _frame;
		}
		
		
		public function set frame(value:int):void {
			_frame = value;
		}
		
		
		public override function toString():String {
			return '[SMFSMPTEOffsetEvent delta=' + deltaTime + ' hour=' + _frame + ' minute=' + _minute + ' second=' + _second + ' frame=' + _frame + ']';
		}
	}
}
