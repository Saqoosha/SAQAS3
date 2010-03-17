package net.saqoosha.display {
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeRelaySignal;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	
	/**
	 * @author Saqoosha
	 */
	public class Stage {
		
		
		private static const ERROR_MSG:String = 'You need to init Stage class first.';

		
		private static var _ref:flash.display.Stage;
		private static var _width:int = 0;
		private static var _height:int = 0;
		private static var _qualityHistry:Vector.<String> = new Vector.<String>();
		private static var _timer:Timer;
		
		private static var _sigResize:NativeRelaySignal;
		private static var _sigResizeDelayed:Signal;
		private static var _sigClick:NativeRelaySignal;
		private static var _sigMouseDown:NativeRelaySignal;
		private static var _sigMouseUp:NativeRelaySignal;
		private static var _sigMouseMove:NativeRelaySignal;

		
		public static function init(stage:flash.display.Stage):void {
			if (!_ref) {
				_ref = stage;
				_sigResize = new NativeRelaySignal(stage, Event.RESIZE);
				_sigResize.add(_onResize);
				_onResize();
			}
		}

		
		public static function pushQuality(quality:String):void {
			_qualityHistry.push(_ref.quality);
			_ref.quality = quality;
		}
		
		
		public static function popQuality():void {
			if (_qualityHistry.length > 0) {
				_ref.quality = _qualityHistry.pop();
			}
		}
		
		
		public static function doInQuality(quality:String, func:Function):void {
			pushQuality(quality);
			func();
			popQuality();
		}

		
		private static function _checkRef():void {
			if (!_ref) {
				throw new Error(ERROR_MSG);
			}
		}

		
		private static function _onResize(event:Event = null):void {
			_width = _ref.stageWidth;
			_height = _ref.stageHeight;
			if (_timer) {
				_timer.reset();
				_timer.start();
			}
		}

		
		private static function _onTimer(event:TimerEvent):void {
			_sigResizeDelayed.dispatch();
		}

		
		public static function get ref():flash.display.Stage {
			return _ref;
		}

		
		public static function get width():int {
			return _width;
		}
		
		
		public static function get height():int {
			return _height;
		}
		
		
		public static function get mouseX():Number {
			var x:Number = _ref.mouseX;
			return x < 0 ? 0 : _width < x ? _width : x;
		}
		
		
		public static function get mouseY():Number {
			var y:Number = _ref.mouseY;
			return y < 0 ? 0 : _height < y ? _height : y;
		}
		
		
		public static function get mouseXFromCenter():Number {
			var hw:Number = _width * 0.5;
			var x:Number = _ref.mouseX - hw;
			return x < -hw ? -hw : hw < x ? hw : x;
		}
		
		
		public static function get mouseYFromCenter():Number {
			var hh:Number = _height * 0.5;
			var y:Number = _ref.mouseY - hh;
			return y < -hh ? -hh : hh < y ? hh : y;
		}
		
		
		public static function get mouseXPercentFromCenter():Number {
			var hw:Number = _width * 0.5;
			var p:Number = (_ref.mouseX - hw) / hw;
			return p < -1 ? -1 : 1 < p ? 1 : p;		}
		
		
		public static function get mouseYPercentFromCenter():Number {
			var hh:Number = _height * 0.5;
			var p:Number = (_ref.mouseY - hh) / hh;
			return p < -1 ? -1 : 1 < p ? 1 : p;
		}

		
		public static function get sigResize():NativeRelaySignal {
			_checkRef();
			return _sigResize;
		}
		
		
		static public function get sigResizeDelayed():Signal {
			_checkRef();
			if (!_sigResizeDelayed) {
				_sigResizeDelayed = new Signal();
				_timer = new Timer(500, 1);
				_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			}
			return _sigResizeDelayed;
		}
		
		
		public static function get sigClick():NativeRelaySignal {
			_checkRef();
			return _sigClick ||= new NativeRelaySignal(_ref, MouseEvent.CLICK, MouseEvent);
		}

		
		public static function get sigMouseDown():NativeRelaySignal {
			_checkRef();
			return _sigMouseDown ||= new NativeRelaySignal(_ref, MouseEvent.MOUSE_DOWN, MouseEvent);
		}

		
		public static function get sigMouseUp():NativeRelaySignal {
			_checkRef();
			return _sigMouseUp ||= new NativeRelaySignal(_ref, MouseEvent.MOUSE_UP, MouseEvent);
		}
		
		
		public static function get sigMouseMove():NativeRelaySignal {
			_checkRef();
			return _sigMouseMove ||= new NativeRelaySignal(_ref, MouseEvent.MOUSE_MOVE, MouseEvent);
		}
	}
}
