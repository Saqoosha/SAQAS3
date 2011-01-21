package sh.saqoo.util {
	import sh.saqoo.display.Stage;

	import flash.display.LoaderInfo;
	import flash.net.LocalConnection;
	import flash.system.System;

	
	public class SystemUtil {

		
		public static function gc():void {
			try {
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			} catch (e:*) {
			}
			trace("System.totalMemory: ", System.totalMemory);
		}
		
		
		public static function getSWFDirName():String {
			var info:LoaderInfo = Stage.ref.loaderInfo;
			if (!info) return '';
			var path:Array = info.url.split('/');
			path.pop();
			return path.join('/');
		}
	}
}
