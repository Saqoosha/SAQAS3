package sh.saqoo.progression {
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;

	import sh.saqoo.util.EnterFrameBeacon;

	import flash.events.Event;

	
	public class WaitFrames extends Command {
		
		
		private var _waitFrames:int = 1;
		private var _count:int = 0;
		
		
		public function WaitFrames(waitFrames:int = 1, initObject:Object = null) {
			_waitFrames = waitFrames;
			super(_executeFunction, _interruptFunction, initObject);
		}
		
		
		private function _executeFunction():void {
			if (_waitFrames) {
				_count = 0;
				EnterFrameBeacon.add(_onEnterFrame);
			} else {
				super.executeComplete();
			}
		}

		
		private function _onEnterFrame(event:Event):void {
			if (++_count == _waitFrames) {
				EnterFrameBeacon.remove(_onEnterFrame);
				super.executeComplete();
			}
		}

		
		private function _interruptFunction():void {
			EnterFrameBeacon.remove(_onEnterFrame);
		}
		

		public override function clone():Command {
			return new WaitFrames(_waitFrames, this);
		}
		

		public override function toString():String {
			return ObjectUtil.formatToString(this, super.className, super.id ? "id" : null, "waitFrames");
		}


		public function get waitFrames():Number {
			return _waitFrames;
		}
		
		
		public function set waitFrames(value:Number):void {
			_waitFrames = value;
		}
	}
}
