package net.saqoosha.util {

	
	/**
	 * @author hiko
	 */
	public class ObjectUtil {
		
		
		public static function copyProps(source:Object, target:Object):Object {
			for (var key:* in source) {
				target[key] = source[key];
			}
			return target;
		}
	}
}
