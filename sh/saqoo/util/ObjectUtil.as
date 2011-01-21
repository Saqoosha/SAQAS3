package sh.saqoo.util {

	
	/**
	 * @author Saqoosha
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
