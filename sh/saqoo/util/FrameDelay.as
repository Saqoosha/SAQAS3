package sh.saqoo.util {

	import flash.events.Event;

	public class FrameDelay {


		public function FrameDelay() {
			throw new Error('Cannot create FrameDelay instance.');
		}


		public static function set(numFrames:uint, callback:Function):void {
			if (numFrames == 0) {
				callback();
			} else {
				EnterFrameBeacon.add(function(event:Event):void {
					if (--numFrames <= 0) {
						EnterFrameBeacon.remove(arguments.callee);
						callback();
					}
				});
			}
		}
	}
}
