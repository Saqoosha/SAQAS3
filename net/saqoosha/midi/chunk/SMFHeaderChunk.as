package net.saqoosha.midi.chunk {

	
	/**
	 * @author hiko
	 */
	public class SMFHeaderChunk extends SMFChunk {
		
		
		private var _format:int;
		private var _numTracks:int;
		private var _resolution:int;

		
		public function SMFHeaderChunk() {
			super(TYPE_HEADER);
		}
		
		
		public function get format():int {
			return _format;
		}
		
		
		public function set format(value:int):void {
			_format = value;
		}

		
		public function get numTracks():int {
			return _numTracks;
		}
		
		
		public function set numTracks(value:int):void {
			_numTracks = value;
		}

		
		public function get resolution():int {
			return _resolution;
		}
		
		
		public function set resolution(value:int):void {
			_resolution = value;
		}
		
		
		public override function toString():String {
			return '[SMFHeaderChunk format=' + _format + ' numTracks=' + _numTracks + ' resolution=' + _resolution + ']';
		}
	}
}
