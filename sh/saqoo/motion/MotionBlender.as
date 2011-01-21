package sh.saqoo.motion {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class MotionBlender {
		
		private var _target:DisplayObject;
		private var _motion1:IMotionProvider;
		private var _motion2:IMotionProvider;
		private var _start:Number;
		private var _time:Number;
		private var _ratio:Number;
		private var _autoUpdate:Boolean;
		
		public function MotionBlender(target:DisplayObject, m1:IMotionProvider, m2:IMotionProvider, time:Number = 0, ratio:Number = 0) {
			this._target = target;
			this._motion1 = m1;
			this._motion2 = m2;
			this._ratio = ratio;
			this._autoUpdate = true;
			this.time = time;
		}
		
		public function start():void {
			this._start = getTimer();
			if (this._motion1.syncStart) {
				this._motion1.start();
			}
			if (this._motion2.syncStart) {
				this._motion2.start();
			}
			this._target.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
		}
		
		private function _onEnterFrame(e:Event):void {
			this.time = getTimer() - this._start;
		}
		
		public function reset():void {
			this._target.removeEventListener(Event.ENTER_FRAME, this._onEnterFrame);
			this.time = 0;
		}
		
		public function update():void {
			this._target.x = this.x;
			this._target.y = this.y;
		}
		
		public function get ratio():Number {
			return this._ratio;
		}
		
		public function set ratio(r:Number):void {
			this._ratio = r;
		}
		
		public function get time():Number {
			return this._time;
		}
		
		public function set time(t:Number):void {
			this._time = t;
			this._motion1.time = t;
			this._motion2.time = t;
			if (this._autoUpdate) {
				this.update();
			}
		}
		
		public function get t():Number {
			return this.time;
		}
		
		public function set t(val:Number):void {
			this.time = val;
		}
		
		public function get x():Number {
			return this._motion1.x * (1 - this._ratio) + this._motion2.x * this._ratio;
		}
		
		public function get y():Number {
			return this._motion1.y * (1 - this._ratio) + this._motion2.y * this._ratio;
		}
		
		public function get motion1():IMotionProvider {
			return this._motion1;
		}
		
		public function get motion2():IMotionProvider {
			return this._motion2;
		}
		
		public function get autoUpdate():Boolean {
			return this._autoUpdate;
		}
		
		public function set autoUpdate(val:Boolean):void {
			this._autoUpdate = val;
		}

	}
	
}
