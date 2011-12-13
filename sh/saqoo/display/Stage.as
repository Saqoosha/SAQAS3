package sh.saqoo.display {

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeRelaySignal;

	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
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
		
		private static var _resized:NativeRelaySignal;
		private static var _delayResized:Signal;
		private static var _clicked:NativeRelaySignal;
		private static var _doubleClicked:NativeRelaySignal;
		private static var _mouseDowned:NativeRelaySignal;
		private static var _mouseUpped:NativeRelaySignal;
		private static var _mouseMoved:NativeRelaySignal;
		private static var _mouseWheeled:NativeRelaySignal;
		private static var _mouseLeft:NativeRelaySignal;
		private static var _keyDowned:NativeRelaySignal;
		private static var _keyUpped:NativeRelaySignal;

		
		public static function init(stage:flash.display.Stage, scaleMode:String = StageScaleMode.NO_SCALE, align:String = StageAlign.TOP_LEFT, quality:String = StageQuality.HIGH):void {
			if (!_ref) {
				_ref = stage;
				_ref.scaleMode = scaleMode;
				_ref.align = align;
				_ref.quality = quality;
				_resized = new NativeRelaySignal(stage, Event.RESIZE);
				_resized.add(_onResize);
				_onResize();
			}
		}


		public static function switchToFullscreen():void {
			_ref.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		
		public static function switchToWindowed():void {
			_ref.displayState = StageDisplayState.NORMAL;
		}


		public static function toggleFullscreen():void {
			_ref.displayState = _ref.displayState == StageDisplayState.NORMAL ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
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
			if (!_ref) throw new Error(ERROR_MSG);
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
			_delayResized.dispatch();
		}

		
		public static function get ref():flash.display.Stage { return _ref; }
		
		public static function get scaleMode():String { return _ref.scaleMode; }
		public static function set scaleMode(value:String):void { _ref.scaleMode = value; }
		
		public static function get align():String { return _ref.align; }
		public static function set align(value:String):void { _ref.align = value; }
		
		public static function get quality():String { return _ref.quality; }
		public static function set quality(value:String):void { _ref.quality = value; }
		
		public static function get frameRate():Number { return _ref.frameRate; }
		public static function set frameRate(value:Number):void { _ref.frameRate = value; }
		
		public static function get focus():InteractiveObject { return _ref.focus; }
		public static function set focus(value:InteractiveObject):void { _ref.focus = value; }

		public static function get width():int { return _width; }
		public static function get height():int { return _height; }
		
		public static function get center():Point { return new Point(_width / 2, _height / 2); }
		
		
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
			return p < -1 ? -1 : 1 < p ? 1 : p;
		}
		
		
		public static function get mouseYPercentFromCenter():Number {
			var hh:Number = _height * 0.5;
			var p:Number = (_ref.mouseY - hh) / hh;
			return p < -1 ? -1 : 1 < p ? 1 : p;
		}

		
		public static function get resized():NativeRelaySignal {
			_checkRef();
			return _resized;
		}
		
		
		static public function get delayResized():Signal {
			_checkRef();
			if (!_delayResized) {
				_delayResized = new Signal();
				_timer = new Timer(500, 1);
				_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			}
			return _delayResized;
		}
		
		
		public static function get clicked():NativeRelaySignal {
			_checkRef();
			return _clicked ||= new NativeRelaySignal(_ref, MouseEvent.CLICK, MouseEvent);
		}

		
		public static function get doubleClicked():NativeRelaySignal {
			_checkRef();
			_ref.doubleClickEnabled = true;
			return _doubleClicked ||= new NativeRelaySignal(_ref, MouseEvent.DOUBLE_CLICK, MouseEvent);
		}

		
		public static function get mouseDowned():NativeRelaySignal {
			_checkRef();
			return _mouseDowned ||= new NativeRelaySignal(_ref, MouseEvent.MOUSE_DOWN, MouseEvent);
		}

		
		public static function get mouseUpped():NativeRelaySignal {
			_checkRef();
			return _mouseUpped ||= new NativeRelaySignal(_ref, MouseEvent.MOUSE_UP, MouseEvent);
		}
		
		
		public static function get mouseMoved():NativeRelaySignal {
			_checkRef();
			return _mouseMoved ||= new NativeRelaySignal(_ref, MouseEvent.MOUSE_MOVE, MouseEvent);
		}
		
		
		public static function get mouseWheeled():NativeRelaySignal {
			_checkRef();
			return _mouseWheeled ||= new NativeRelaySignal(_ref, MouseEvent.MOUSE_WHEEL, MouseEvent);
		}
		
		
		public static function get mouseLeft():NativeRelaySignal {
			_checkRef();
			return _mouseLeft ||= new NativeRelaySignal(_ref, Event.MOUSE_LEAVE, Event);
		}
		
		
		public static function get keyDowned():NativeRelaySignal {
			_checkRef();
			return _keyDowned ||= new NativeRelaySignal(_ref, KeyboardEvent.KEY_DOWN, KeyboardEvent);
		}
		
		
		public static function get keyUpped():NativeRelaySignal {
			_checkRef();
			return _keyUpped ||= new NativeRelaySignal(_ref, KeyboardEvent.KEY_UP, KeyboardEvent);
		}
	}
}
