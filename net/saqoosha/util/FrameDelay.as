package net.saqoosha.util {
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FrameDelay {
		
		public function FrameDelay() {
			throw new ArgumentError('Cannot create FrameDelay instance.');
		}
		
		private static var _enterFrame:Sprite;
		
		public static function delay(target:Object, func:Function, ...args):void {
			if (!_enterFrame) {
				_enterFrame = new Sprite();
			}
			_enterFrame.addEventListener(Event.ENTER_FRAME, function (e:Event):void {
				_enterFrame.removeEventListener(Event.ENTER_FRAME, arguments.callee);
				func.apply(target, args);
			});
		}
	}
}
