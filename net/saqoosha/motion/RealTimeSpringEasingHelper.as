package net.saqoosha.motion {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	[Event(type="flash.events.Event", name="change")]
	
	public class RealTimeSpringEasingHelper extends SpringEasingHelper implements IEventDispatcher {
		
		private var _dt:Number = 0;
		private var _frameTime:Number;
		private var _lastTime:int;
		private var _beacon:Sprite = new Sprite();
		private var _eventDispatcher:EventDispatcher = new EventDispatcher();
		private var _changeEvent:Event = new Event(Event.CHANGE);
		private var _enabled:Boolean = false;
		
		public function RealTimeSpringEasingHelper(inival:Number, factor:Number=20, decay:Number=0.8, fps:int = 60) {
			this._dt = 0;
			this._frameTime = 1000 / fps;
			this._lastTime = getTimer();
			super(inival, factor, decay);
		}
		
		private function _onEnterFrame(e:Event):void {
			this.update();
		}
		
		public override function update(newVal:Number=NaN):void {
			var now:int = getTimer();
			this._dt += now - this._lastTime;
			this._lastTime = now;
			this._dt = this._dt > 100 ? 100 : this._dt;
			
			while (this._dt > this._frameTime) {
				super.update(newVal);
				this._dt -= this._frameTime;
			}
			this.dispatchEvent(this._changeEvent);
			
			if (Math.abs(this.target - this.current) < 0.1 && Math.abs(this.velocity) < 0.1) {
				this.enabled = false;
			}
		}
		
		public function reset():void {
			this._dt = 0;
			this._lastTime = getTimer();
		}
		
		public override function set target(newVal:Number):void {
			super.target = newVal;
			if (!(Math.abs(this.target - this.current) < 0.1 && Math.abs(this.velocity) < 0.1)) {
				this.enabled = true;
			}
		}
		
		public function get enabled():Boolean {
			return this._enabled;
		}
		
		public function set enabled(value:Boolean):void {
			if (this._enabled != value) {
				trace('set enabled: ', value);
				this._enabled = value;
				if (this._enabled) {
					this._beacon.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
				} else {
					this._beacon.removeEventListener(Event.ENTER_FRAME, this._onEnterFrame);
				}
			}
		}
		
		//
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			this._eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return this._eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return this._eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			return this._eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return this._eventDispatcher.willTrigger(type);
		}
		
		//
		
		public override function toString():String {
			return '[RealTimeSpringEasingHelper: current=' + this._current + ', factor=' + this._factor + ']';
		}
	}
}