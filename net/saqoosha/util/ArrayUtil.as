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

		
		public static function fromArguments(arg:Object):Array {
			var arr:Array = [];
			var n:int = arg.length;
			for (var i:int = 0; i < n; i++) {
				arr.push(arg[i]);
			}
			return arr;
		}
		
		
		public static function fromVector(vector:*):Array {
			return fromArguments(vector);
		}
	}
}
