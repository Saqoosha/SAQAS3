package net.saqoosha.air {
	
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	import mx.core.IWindow;
	import mx.core.Window;
	import mx.core.WindowedApplication;
	
	
	public class WindowSizeManager {
		
		private static const WINDOW_SIZE_KEY:String = '__windowSize';
		
		private static var _so:SharedObject;
		private static var _windows:Dictionary;
		
		public static function init(storeName:String):void {
			_so = SharedObject.getLocal(storeName);
			if (!_so.data[WINDOW_SIZE_KEY]) {
				_so.data[WINDOW_SIZE_KEY] = {};
			}
			_windows = new Dictionary();
		}
		
		public static function register(window:IWindow, name:String = null):void {
			if (!name) {
				name = window.title;
			}
			if (_windows[name]) {
				throw new Error('Window[' + name + '] is already registered.');
			}
			_restoreWindowSize(window, name);
			if (window is Window) {
				Window(window).addEventListener(Event.CLOSING, _onClosing);
			} else if (window is WindowedApplication) {
				WindowedApplication(window).addEventListener(Event.CLOSING, _onClosing);
			}
			_windows[window] = name;
		}
		
		private static function _restoreWindowSize(window:IWindow, name:String):void {
			var rect:* = _so.data[WINDOW_SIZE_KEY][name];
			if (rect) {
				var win:NativeWindow;
				if (window is Window) {
					win = Window(window).nativeWindow;
				} else if (window is WindowedApplication) {
					win = WindowedApplication(window).nativeWindow;
				} else {
					throw new Error();
				}
				win.x = rect.x;
				win.y = rect.y;
				win.width = rect.width;
				win.height = rect.height;
			} else {
				_saveWindowSize(window, name);
			}
		}
		
		private static function _saveWindowSize(window:IWindow, name:String):void {
			var rect:* = {};
			var win:NativeWindow;
			if (window is Window) {
				win = Window(window).nativeWindow;
			} else if (window is WindowedApplication) {
				win = WindowedApplication(window).nativeWindow;
			} else {
				throw new Error();
			}
			rect.x = win.x;
			rect.y = win.y;
			rect.width = win.width;
			rect.height = win.height;
			_so.data[WINDOW_SIZE_KEY][name] = rect;
			_so.flush();
		}
		
		private static function _onClosing(e:Event):void {
			if (_windows[e.target]) {
				_saveWindowSize(IWindow(e.target), _windows[e.target]);
			}
		}
		
		public function WindowSizeManager() {
			throw new Error('WindowSizeManager cannot instansiate directly.');
		}
	}
}