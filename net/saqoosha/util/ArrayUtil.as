package net.saqoosha.util {
	
	
	public class ArrayUtil {

		
		public static function shuffle(arrayOrVector:*):* {
			var n:int = arrayOrVector.length;
			var i:int;
			var tmp:*;
			while (n) {
				i = Math.random() * n;
				tmp = arrayOrVector[--n];
				arrayOrVector[n] = arrayOrVector[i];
				arrayOrVector[i] = tmp;
			}
			return arrayOrVector;
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
