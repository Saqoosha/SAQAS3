package net.saqoosha.midi.event {
	import flash.utils.ByteArray;

	/**
	 * @author hiko
	 */
	public class SMFSysExEvent extends SMFEvent {

		
		private var _data:ByteArray;
		
		
		public function SMFSysExEvent(deltaTime:int) {
			super(deltaTime, SMFEvent.TYPE_SYSEX);
		}
		
		
		public function get data():ByteArray {
			return _data;
		}
		
		
		public function set data(value:ByteArray):void {
			_data = value;
		}


		public override function toString():String {
			return '[SMFSysExEvent delta=' + deltaTime + ' length=' + _data.length + ']';
		}
	}
}
