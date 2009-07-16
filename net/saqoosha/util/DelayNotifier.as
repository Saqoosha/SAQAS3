package net.saqoosha.util {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name='change', type='flash.events.Event')]
	
	public class DelayNotifier extends EventDispatcher {
		
		private var _timer:Timer;
		private var _value:*;
		private var _prev:*;
		private var _next:*;
		
		public function DelayNotifier(delay:int, init:*) {
			this._timer = new Timer(delay, 1);
			this._timer.addEventListener(TimerEvent.TIMER, this._onTimer);
			this._value = this._prev = init;
		}
		
		private function _onTimer(e:TimerEvent):void {
			this._value = this._next;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get value():* {
			return this._value;
		}
		
		public function set value(val:*):void {
			if (val != this._prev) {
				this._prev = val;
				if (this._timer.running) {
					this._timer.stop();
					this._timer.reset();
				}
				if (this._value != val) {
					this._next = val;
					this._timer.delay = this._next ? 500 : 1000;
					this._timer.start();
				}
			}
		}
	}
}