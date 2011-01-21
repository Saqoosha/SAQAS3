package sh.saqoo.midi.chunk {
	import sh.saqoo.midi.event.SMFEvent;

	/**
	 * @author Saqoosha
	 */
	public class SMFTrackChunk extends SMFChunk {


		private var _event:Array;
		private var _duration:int;

		
		public function SMFTrackChunk() {
			super(TYPE_TRACK);
			_event = [];
			_duration = 0;
		}

		
		public function pushEvent(event:SMFEvent):void {
//			trace(event);
			_event.push(event);
			_duration += event.deltaTime;
		}

		
		public function get events():Array {
			return _event;
		}
		
		
		public function get duration():int {
			return _duration;
		}
	}
}
