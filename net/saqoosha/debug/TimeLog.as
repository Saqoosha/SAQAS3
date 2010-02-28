package net.saqoosha.debug {
	import net.saqoosha.util.ArrayUtil;

	import flash.utils.getTimer;

	
	/**
	 * @author Saqoosha
	 */
	public class TimeLog {
		
		
		private static var _prev:int = -1;
		
		
		public static function log(...args):void {
			var now:int = getTimer();
			var d:int = _prev < 0 ? 0 : now - _prev;
			_prev = now;
			trace.apply(null, ['[Now:' + now + ', Delta:' + d + '] '].concat(ArrayUtil.fromArguments(args)));
		}

		
		public static function reset():void {
			_prev = getTimer();
		}
	}
}
