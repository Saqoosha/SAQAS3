package net.saqoosha.midi.event.meta {
	import net.saqoosha.midi.event.SMFMetaEvent;
	import net.saqoosha.util.StringUtil;

	/**
	 * @author hiko
	 */
	public class SMFNumberEvent extends SMFMetaEvent {
		
		
		private var _value:Number;

		
		public function SMFNumberEvent(deltaTime:int, type:int, value:Number = 0) {
			super(deltaTime, type);
			_value = value;
		}

		
		public function get value():Number {
			return _value;
		}
		
		
		public function set value(val:Number):void {
			_value = val;
		}
		
		
		public override function toString():String {
			return '[SMFNumberEvent delta=' + deltaTime + ' metaType=' + TYPE_NAME_TABLE[metaType] + '(0x' + StringUtil.toHex(metaType, 2) + ') value=' + _value + ']';
		}
	}
}
