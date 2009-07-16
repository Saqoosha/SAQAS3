package net.saqoosha.util {
	
	public class ArrayUtil {

		public static function shuffle(ar:Array):Array {
			var n:int = ar.length;
			var i:int;
			var tmp:*;
			while (n) {
				i = Math.random() * n;
				tmp = ar[--n];
				ar[n] = ar[i];
				ar[i] = tmp;
			}
			return ar;
		}

	}
	
}