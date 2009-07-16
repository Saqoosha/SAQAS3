package net.saqoosha.util {
	
	import flash.net.LocalConnection;
	import flash.system.System;
	
	public class SystemUtil {
		
		public static function gc():void {
			try {
			   new LocalConnection().connect('foo');
			   new LocalConnection().connect('foo');
			} catch (e:*) {}
			trace("System.totalMemory: ", System.totalMemory);
		}
		
	}
	
}