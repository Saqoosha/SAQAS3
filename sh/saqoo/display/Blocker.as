package sh.saqoo.display {

	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * @author Saqoosha
	 */
	public class Blocker extends Sprite {
		
		
		public static var DEBUG_MODE:Boolean = false;

		
		private static var _blocking:Boolean = false;
		private static var _blocker:Sprite;

		
		public static function block():void {
			if (!_blocker) {
				_blocker = new Sprite();
				_blocker.focusRect = false;
				_blocker.graphics.beginFill(0xff0000, 0.2);
				_blocker.graphics.drawRect(0, 0, 1000, 1000);
				_blocker.graphics.endFill();
				_blocker.graphics.lineStyle(0, 0xff0000, 0.8, false, LineScaleMode.NONE);
				_blocker.graphics.moveTo(0, 0);
				_blocker.graphics.lineTo(1000, 1000);
				_blocker.graphics.moveTo(1000, 0);
				_blocker.graphics.lineTo(0, 1000);
			}
			_blocker.alpha = DEBUG_MODE ? 1 : 0;
			Stage.ref.addChild(_blocker);
			Stage.ref.focus = _blocker;
			Stage.ref.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown, false, int.MAX_VALUE);
			Stage.resized.add(_onStageResize);
			_onStageResize();
			_blocking = true;
		}

		
		private static function _onKeyDown(event:KeyboardEvent):void {
			event.stopImmediatePropagation();
		}

		
		private static function _onStageResize(event:Event = null):void {
			_blocker.width = Stage.width;
			_blocker.height = Stage.height;
		}

		
		public static function unblock():void {
			Stage.resized.remove(_onStageResize);
			Stage.ref.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown, false);
			Stage.ref.focus = null;
			if (_blocking) {
				_blocker.parent.removeChild(_blocker);
				_blocking = false;
			}
		}

		
		public static function get blocking():Boolean {
			return _blocking;
		}
		
		
		public static function set blocking(blocking:Boolean):void {
			if (_blocking != blocking) {
				if (blocking) {
					block();
				} else {
					unblock();
				}
			}
		}
	}
}
