package net.saqoosha.colorlog {
	
	public class ColorLog {
		
		private static var _buffer:Array = [];
		
		public static function clearScreen():void {
			_buffer.push(ESCCodes.ED(2));
			moveTo(1, 1);
		}
		
		public static function moveTo(row:int = 1, column:int = 1):void {
			_buffer.push(ESCCodes.CUP(row, column));
		}
		
		public static function setColor(...colorCodes):void {
			var n:int = colorCodes.length;
			for (var i:int = 0; i < n; i++) {
				_buffer.push(ESCCodes.SGR(colorCodes[i]));
			}
		}
		
		public static function resetColor():void {
			_buffer.push(ESCCodes.SGR());
		}
		
		public static function hideCursor():void {
			_buffer.push(ESCCodes.HideCursor);
		}
		
		public static function showCursor():void {
			_buffer.push(ESCCodes.ShowCursor);
		}
		
		public static function flush():void {
			resetColor();
			trace(_buffer.join(''));
			_buffer = [];
		}
		
		public static function out(...args):void {
			_buffer.push(args.join(' '));
		}
	}
}