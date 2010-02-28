package net.saqoosha.progression {
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;

	
	public class Pause extends Command {
		

		public function Pause(initObject:Object = null) {
			super(_executeFunction, null, initObject);
		}
		
		
		public function resume(...args):void {
			if (super.state > 1) {
				super.executeComplete();
			}
		}
		
		
		private function _executeFunction():void {
			// do nothing. just wait to call resume...
		}
		

		public override function clone():Command {
			return new Pause(this);
		}
		
		
		public override function toString():String {
			return ObjectUtil.formatToString(this, super.className, super.id ? "id" : null);
		}
	}
}
