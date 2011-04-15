package sh.saqoo.debug {

	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * @author Saqoosha
	 */
	public class Stopwatch {


		private static var _start:Dictionary = new Dictionary();
		private static var _section:Vector.<String> = new Vector.<String>();


		public static function startSection(name:String, stopCurrSect:Boolean = false):void {
			if (stopCurrSect) stopCurrentSection();
			if (_start.hasOwnProperty(name)) throw new ArgumentError('[Stopwatch] Section already started: ' + name);
			trace(_getPad(_section.length) + 'Section start: "' + name + '"');
			_start[name] = getTimer();
			_section.push(name);
		}


		public static function stopCurrentSection():void {
			if (_section.length == 0) throw new Error('[Stopwatch] No section started yet.');
			var name:String = _section.pop();
			var d:int = getTimer() - _start[name];
			delete _start[name];
			trace(_getPad(_section.length) + 'Section finish: "' + name + '" in ' + (int(d) / 1000) + 'secs');
		}


		public static function clearAll():void {
			_start = new Dictionary();
			_section = new Vector.<String>();
		}


		private static function _getPad(level:uint):String {
			return '                                                                           '.substr(0, level * 4);
		}
	}
}
