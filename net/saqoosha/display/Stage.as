package net.saqoosha.display {
	import org.osflash.signals.natives.NativeRelaySignal;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	
	/**
	 * @author Saqoosha
	 */
	public class Stage {
		
		
		private static const ERROR_MSG:String = 'You need to init Stage class first.';

		
		private static var _ref:flash.display.Stage;
		private static var _width:int = 0;
		private static var _height:int = 0;
		private static var _qualityHistry:Vector.<String> = new Vector.<String>();
		
		private static var _sigResize:NativeRelaySignal;
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

		
		public static function get sigResize():NativeRelaySignal {
			_checkRef();
			return _sigResize;
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
