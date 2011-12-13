package sh.saqoo.signal {

	import sh.saqoo.display.Stage;

	import org.osflash.signals.Signal;

	import flash.events.KeyboardEvent;

	/**
	 * @author Saqoosha
	 */
	public class SigKonamiCommand {


		private static const KONAMI_COMMAND:Vector.<uint> = Vector.<uint>([38, 38, 40, 40, 37, 39, 37, 39, 98, 97]);

		private static var _histroy:Vector.<uint> = new Vector.<uint>();
		private static var _signal:Signal = new Signal();


		public static function init(listener:Function = null):void {
			Stage.keyDowned.add(_onKeyDown);
			if (listener is Function) _signal.add(listener);
		}


		public static function get numListeners():uint {
			return _signal.numListeners;
		}


		public static function add(listener:Function):Function {
			return _signal.add(listener);
		}


		public static function addOnce(listener:Function):Function {
			return _signal.addOnce(listener);
		}


		public static function remove(listener:Function):Function {
			return _signal.remove(listener);
		}


		public static function removeAll():void {
			_signal.removeAll();
		}


		private static function _onKeyDown(e:KeyboardEvent):void {
			_histroy.push(e.charCode || e.keyCode);
			if (_histroy.length > 10) {
				_histroy.shift();
			} else if (_histroy.length < 10) {
				return;
			}
			for (var i:int = 0; i < 10; i++) {
				if (_histroy[i] != KONAMI_COMMAND[i]) return;
			}
			_signal.dispatch();
		}
	}
}
