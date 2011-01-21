package sh.saqoo.util {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class DelayNotifier extends EventDispatcher {
		
		private var _timer:Timer;
		private var _value:*;
		private var _prev:*;
		private var _next:*;
		
		public function DelayNotifier(delay:int, init:*) {
			_timer = new Timer(delay, 1);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_value = _prev = init;
		}
		
		private function _onTimer(e:TimerEvent):void {
			_value = _next;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get value():* {
			return _value;
		}
		
		public function set value(val:*):void {
			if (val != _prev) {
				_prev = val;
				if (_timer.running) {
					_timer.stop();
					_timer.reset();
				}
				if (_value != val) {
					_next = val;
//					_timer.delay = _next ? 500 : 1000;
					_timer.start();
				}
			}
		}
		
		public function get delay():Number {
			return _timer.delay;
		}
		
		public function set delay(value:Number):void {
			_timer.delay = value;
		}
	}
}
