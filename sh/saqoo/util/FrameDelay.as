package sh.saqoo.util {
	import flash.events.Event;

	
	public class FrameDelay {
		
		
		public function FrameDelay() {
			throw new Error('Cannot create FrameDelay instance.');
		}
		
		
//		private static var _enterFrame:Sprite;
//		
//		public static function delay(target:Object, func:Function, ...args):void {
//			if (!_enterFrame) {
//				_enterFrame = new Sprite();
//			}
//			_enterFrame.addEventListener(Event.ENTER_FRAME, function (e:Event):void {
//				_enterFrame.removeEventListener(Event.ENTER_FRAME, arguments.callee);
//				func.apply(target, args);
//			});
//		}


		public static function set(numFrames:uint, callback:Function):void {
			if (numFrames == 0) {
				callback();
			} else {
				EnterFrameBeacon.add(function (event:Event):void {
					if (--numFrames <= 0) {
						EnterFrameBeacon.remove(arguments.callee);
						callback();
					}
				});
			}
		}
	}
}
