package sh.saqoo.event {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	
	/**
	 * @author Saqoosha
	 */
	public class StaticEventDispatcher {
		
		
		protected static const _dispatcher:EventDispatcher = new EventDispatcher();

		
		public static function dispatchEvent(event:Event):Boolean {
			return _dispatcher.dispatchEvent(event);
		}

		
		public static function hasEventListener(type:String):Boolean {
			return _dispatcher.hasEventListener(type);
		}

		
		public static function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}

		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_dispatcher.removeEventListener(type, listener, useCapture);
		}

		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}
