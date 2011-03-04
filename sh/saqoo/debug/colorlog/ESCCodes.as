package sh.saqoo.debug.colorlog {


	public class ESCCodes {


		public static const ESC:String = '\x1b';
		public static const CSI:String = ESC + '[';


		/**
		 * Moves the cursor n (default 1) cells in the given direction.
		 * If the cursor is already at the edge of the screen, this has no effect.
		 */
		public static function CUU(n:int = 1):String {
			return CSI + n + 'A';
		}


		public static function CursorUp(n:int = 1):String {
			return CUU(n);
		}


		public static function CUD(n:int = 1):String {
			return CSI + n + 'B';
		}


		public static function CursorDown(n:int = 1):String {
			return CUD(n);
		}


		public static function CUF(n:int = 1):String {
			return CSI + n + 'C';
		}


		public static function CursorForward(n:int = 1):String {
			return CUF(n);
		}


		public static function CUB(n:int = 1):String {
			return CSI + n + 'D';
		}


		public static function CursorBack(n:int = 1):String {
			return CUB(n);
		}


		/**
		 * Moves cursor to beginning of the line n (default 1) lines down. 
		 */
		public static function CNL(n:int = 1):String {
			return CSI + n + 'E';
		}


		public static function CursorNextLine(n:int = 1):String {
			return CNL(n);
		}


		/**
		 * Moves cursor to beginning of the line n (default 1) lines up.
		 */
		public static function CPL(n:int = 1):String {
			return CSI + n + 'F';
		}


		public static function CursorPreviousLine(n:int = 1):String {
			return CPL(n);
		}


		/**
		 * Moves the cursor to column n.
		 */
		public static function CHA(n:int = 1):String {
			return CSI + n + 'G';
		}


		public static function CursolHorizontalAbsolute(n:int = 1):String {
			return CHA(n);
		}


		/**
		 * Moves the cursor to row n, column m. The values are 1-based, and default to 1 (top left corner)
		 */
		public static function CUP(row:int = 1, column:int = 1):String {
			return CSI + row + ';' + column + 'H';
		}


		public static function CursorPosition(row:int = 1, column:int = 1):String {
			return CUP(row, column);
		}


		public static function HVP(row:int = 1, column:int = 1):String {
			return CUP(row, column);
		}


		public static function HorizontalAndVerticalPosition(row:int = 1, column:int = 1):String {
			return CUP(row, column);
		}


		/**
		 * Clears part of the screen. 
		 * If n is zero (or missing), clear from cursor to end of screen. 
		 * If n is one, clear from cursor to beginning of the screen.
		 * If n is two, clear entire screen.
		 */
		public static function ED(n:int = 0):String {
			return CSI + n + 'J';
		}


		public static function EraseData(n:int = 0):String {
			return ED(n);
		}


		/**
		 *Erases part of the line.
		 * If n is zero (or missing), clear from cursor to the end of the line.
		 * If n is one, clear from cursor to beginning of the line.
		 * If n is two, clear entire line. Cursor position does not change.
		 */
		public static function EL(n:int = 0):String {
			return CSI + n + 'K';
		}


		public static function EraseLine(n:int = 0):String {
			return EL(n);
		}


		/**
		 * Scroll whole page up by n (default 1) lines. New lines are added at the bottom.
		 */
		public static function SU(n:int = 1):String {
			return CSI + n + 'S';
		}


		public static function ScrollUp(n:int = 1):String {
			return SU(n);
		}


		/**
		 * Scroll whole page down by n (default 1) lines. New lines are added at the top.
		 */
		public static function SD(n:int = 1):String {
			return CSI + n + 'T';
		}


		public static function ScrollDown(n:int = 1):String {
			return SD(n);
		}


		/**
		 * Sets SGR parameters.
		 * After CSI can be zero or more parameters separated with ;. With no parameters,
		 * CSI m is treated as CSI 0 m (reset / normal)
		 */
		public static function SGR(...args):String {
			return CSI + args.join(';') + 'm';
		}


		public static function SelectGraphicRendition(...args):String {
			return SGR.apply(null, args);
		}


		public static const SCP:String = CSI + 's';
		public static const SaveCursorPosition:String = SCP;
		public static const RCP:String = CSI + 'u';
		public static const RestoreCursorPosition:String = RCP;
		public static const HideCursor:String = CSI + '?25l';
		public static const ShowCursor:String = CSI + '?25h';
	}
}
