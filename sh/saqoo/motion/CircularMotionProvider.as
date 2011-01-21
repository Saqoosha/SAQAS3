package sh.saqoo.motion {
	import flash.utils.getTimer;
	
	
	public class CircularMotionProvider implements IMotionProvider {
		
		public static const RADIAN:Number = Math.PI / 180;
		
		private var _radius:Number;
		private var _speed:Number;
		private var _phase:Number;
		private var _start:Number;
		private var _time:Number;
		private var _offsetX:Number;
		private var _offsetY:Number;
		private var _syncStart:Boolean;
		
		public function CircularMotionProvider(radius:Number, anglesPerSec:Number = 6, phase:Number = 0) {
			this._radius = radius;
			this._speed = anglesPerSec * RADIAN * 0.001;
			this._phase = phase;
			this._time = 0;
			this._offsetX = 0;
			this._offsetY = 0;
			this._syncStart = true;
		}
		
		public function start(now:Number = 0):void {
			this._start = now || getTimer();
		}

		public function get time():Number {
			return this._time;
		}
		
		public function set time(t:Number):void {
			this._time = t;
			this._start = getTimer() - t;
		}
		
		public function get x():Number {
			var a:Number = this._speed * (getTimer() - this._start) + this._phase;
			return Math.cos(a) * this._radius + this._offsetX;
		}
		
		public function get y():Number {
			var a:Number = this._speed * (getTimer() - this._start) + this._phase;
			return Math.sin(a) * this._radius + this._offsetY;
		}
		
		public function get radius():Number {
			return this._radius;
		}
		
		public function set radius(val:Number):void {
			this._radius = val;
		}
		
		public  function get speed():Number {
			return this._speed;
		}
		
		public function set speed(val:Number):void {
			this._speed = val;
		}
		
		public function get offsetX():Number {
			return this._offsetX;
		}
		
		public function set offsetX(val:Number):void {
			this._offsetX = val;
		}
		
		public function get offsetY():Number {
			return this._offsetY;
		}
		
		public function set offsetY(val:Number):void {
			this._offsetY = val;
		}
		
		public function get syncStart():Boolean {
			return this._syncStart;
		}
		
		public function set syncStart(val:Boolean):void {
			this._syncStart = val;
		}
		
	}
	
}