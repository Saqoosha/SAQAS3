package net.saqoosha.util {

	
	/**
	 * @author hiko
	 */
	public class RandomArray extends Array {

		
		public function RandomArray(...args) {
			super(args.length == 1 && args[0] is int ? args[0] : 0);
			for each (var hoge:* in args) {
				push(hoge);
			}
trace(args);
trace(this);
//	        var n:uint = args.length;
//	        var len:int;
//	        var push:Boolean = false;
//	        if (n == 1 && (args[0] is int)) {
//				len = args[0];
//			} else {
//				len = n;
//				push = true;
//	        }
//	        super(len);
//	        if (push) {
//		        this.length = len;
//	            for (var i:int = 0; i < n; i++) {
//	                this[i] = args[i];
//				}
//	        }
		}
		
		
		public function getOne(remove:Boolean = false):* {
			if (length == 0) {
				return null;
			} else {
				return this[int(Math.random() * length)];
			}
		}
	}
}
