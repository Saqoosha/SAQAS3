package sh.saqoo.motion {
	
	import caurina.transitions.Equations;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import sh.saqoo.geom.Path;
	
	public class PathMotionProvider implements IMotionProvider {
		
		private var _path:Path;
		private var _duration:Number;
		private var _delay:Number;
		private var _easing:Function;
		private var _start:Number;
		private var _time:Number;
		private var _syncStart:Boolean;
		
		public function PathMotionProvider(path:Path, duration:Number = 1, delay:Number = 0, easing:Function = null) {
			super();
			this._path = path;
			this._duration = duration;
			this._delay = delay;
			this._easing = easing || Equations.easeNone;
			this._syncStart = false;
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
		
		// TODO: optimize
		public function get x():Number {
			var t:Number = ((getTimer() - this._start) * 0.001 - this._delay) / this._duration;
			var p:Point = this._path.getPointAt(this._easing(t, 0, 1, 1));
			return p.x;
		}
		
		// TODO: optimize
		public function get y():Number {
			var t:Number = ((getTimer() - this._start) * 0.001 - this._delay) / this._duration;
			var p:Point = this._path.getPointAt(this._easing(t, 0, 1, 1));
			return p.y;
		}
		
		public function get syncStart():Boolean {
			return this._syncStart;
		}
		
		public function set syncStart(val:Boolean):void {
			this._syncStart = val;
		}
		
		public function get path():Path {
			return this._path;
		}
		
	}
	
}