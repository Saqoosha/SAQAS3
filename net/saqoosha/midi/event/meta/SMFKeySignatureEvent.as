package net.saqoosha.midi.event.meta {
	import net.saqoosha.midi.event.SMFMetaEvent;

	/**
	 * @author Saqoosha
	 */
	public class SMFKeySignatureEvent extends SMFMetaEvent {
		
		
		private var _numSigns:int;
		private var _isMinor:Boolean;

		
		public function SMFKeySignatureEvent(deltaTime:int, numSigns:int = 0, isMinor:Boolean = false) {
			super(deltaTime, SMFMetaEvent.TYPE_KEY_SIGNATURE);
			_numSigns = numSigns;
			_isMinor = isMinor;
		}

		
		public function get numSigns():int {
			return _numSigns;
		}
		
		
		public function set numSigns(value:int):void {
			_numSigns = value;
		}
		
		
		public function get isMinor():Boolean {
			return _isMinor;
		}
		
		
		public function set isMinor(value:Boolean):void {
			_isMinor = value;
		}
		
		
		public override function toString():String {
			return '[SMFKeySignatureEvent delta=' + deltaTime + ' numSigns=' + _numSigns + ' isMinor=' + (_isMinor ? 'true' : 'false') + ']';
		}
	}
}
