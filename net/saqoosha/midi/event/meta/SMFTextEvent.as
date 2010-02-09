package net.saqoosha.midi.event.meta {
	import net.saqoosha.midi.event.SMFMetaEvent;
	import net.saqoosha.util.StringUtil;

	/**
	 * @author Saqoosha
	 */
	public class SMFTextEvent extends SMFMetaEvent {
		
		
		private var _text:String;

		
		public function SMFTextEvent(deltaTime:int, type:int, text:String = null) {
			super(deltaTime, type);
			_text = text;
		}

		
		public function get text():String {
			return _text;
		}
		
		
		public function set text(value:String):void {
			_text = value;
		}


		public override function toString():String {
			return '[SMFTextEvent delta=' + deltaTime + ' metaType=' + TYPE_NAME_TABLE[metaType] + '(0x' + StringUtil.toHex(metaType, 2) + ') text="' + _text + '" length=' + _text.length + ']';
		}
	}
}
