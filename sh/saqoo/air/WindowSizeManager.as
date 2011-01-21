package sh.saqoo.air {

	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;

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

		public static function register(window:*, name:String = null):void {
			if (!name) {
				name = window.title;
			}
			if (_windows[name]) {
				throw new Error('Window[' + name + '] is already registered.');
			}
			_restoreWindowSize(window, name);
			switch (true) {
				case window is NativeWindow: window.addEventListener(Event.CLOSING, _onClosing); break;
				case window is Window: Window(window).addEventListener(Event.CLOSING, _onClosing); break;
				case window is WindowedApplication: WindowedApplication(window).addEventListener(Event.CLOSING, _onClosing); break;
				default: throw new Error();
			}
			_windows[window] = name;
		}

		private static function _restoreWindowSize(window:*, name:String):void {
			var rect:* = _so.data[WINDOW_SIZE_KEY][name];
			if (rect) {
				var win:NativeWindow;
				switch (true) {
					case window is NativeWindow: win = window; break;
					case window is Window: win = Window(win).nativeWindow; break;
					case window is WindowedApplication: WindowedApplication(win).nativeWindow; break;
					default: throw new Error();
				}
				win.x = rect.x;
				win.y = rect.y;
				win.width = rect.width;
				win.height = rect.height;
			} else {
				_saveWindowSize(window, name);
			}
		}

		private static function _saveWindowSize(window:*, name:String):void {
			var rect:* = {};
			var win:NativeWindow;
			switch (true) {
				case window is NativeWindow: win = window; break;
				case window is Window: win = Window(win).nativeWindow; break;
				case window is WindowedApplication: WindowedApplication(win).nativeWindow; break;
				default: throw new Error();
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
				_saveWindowSize(e.target, _windows[e.target]);
			}
		}

		public function WindowSizeManager() {
			throw new Error('WindowSizeManager cannot instansiate directly.');
		}
	}
}
