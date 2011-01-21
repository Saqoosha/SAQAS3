package sh.saqoo.util {

	
	/**
	 * @author Saqoosha
	 */
	dynamic public class RandomArray extends Array {

		
		public function RandomArray(...args) {
			super(args.length == 1 && args[0] is int ? args.shift() : 0);
			for each (var hoge:* in args) {
				push(hoge);
			}
		}
		
		
		public function getOne(remove:Boolean = false):* {
			if (!length) return undefined;

			var i:uint = int(Math.random() * length);
			return remove ? splice(i, 1)[0] : this[i];
		}
	}
}
