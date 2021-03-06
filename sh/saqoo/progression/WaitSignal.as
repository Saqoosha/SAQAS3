﻿package sh.saqoo.progression {

	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;

	import org.osflash.signals.Signal;

	/**
	 * @author Saqoosha
	 */
	public class WaitSignal extends Command {


		private var _signal:Signal;
		private var _func:Function;
		private var _args:Array;
		private var _callback:Function;


		public function WaitSignal(signal:Signal, func:Function = null, args:Array = null, initObject:Object = null) {
			_signal = signal;
			_func = func;
			_args = args;
			super(_executeFunction, _interruptFunction, initObject);
		}
		
		
		private function _executeFunction():void {
			switch (_signal.valueClasses.length) {
				case 0: _callback = super.executeComplete; break;
				case 1: _callback = _callback1; break;
				case 2: _callback = _callback2; break;
				default: throw new Error('Signal dispatched with too many arguments.');
			}
			_signal.addOnce(_callback);
			if (_func is Function) _func.apply(this, _args);
		}


		private function _callback1(arg0:*):void {
			latestData = arg0;
			super.executeComplete();
		}


		private function _callback2(arg0:*, arg1:*):void {
			latestData = [arg0, arg1];
			super.executeComplete();
		}


		private function _interruptFunction():void {
			_signal.remove(super.executeComplete);
		}


		public override function clone():Command {
			return new WaitSignal(_signal, _func, _args, this);
		}


		public override function toString():String {
			return ObjectUtil.formatToString(this, super.className, super.id ? 'id' : null);
		}
	}
}
