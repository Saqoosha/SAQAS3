package net.saqoosha.colorlog {
	
	public class SGR {
		
		public static const RESET:String 			= '0';
		
		public static const INTENSITY_BOLD:String 	= '1';
		public static const INTENSITY_FAINT:String 	= '2';
		public static const INTENSITY_NORMAL:String	= '22';
		
		public static const ITALIC_ON:String 		= '3'; // not supported
		
		public static const UNDERLINE_SINGLE:String = '4';
		public static const UNDERLINE_DOUBLE:String	= '21'; // not supported
		public static const UNDERLINE_NONE:String	= '24';
		
		public static const BLINK_SLOW:String		= '5';
		public static const BLINK_RAPID:String		= '6'; // not supported
		public static const BLINK_OFF:String		= '25';
		
		public static const IMAGE_NEGATIVE:String	= '7';
		public static const IMAGE_POSITIVE:String	= '27';
		
		public static const CONCEAL:String			= '8';
		public static const REVEAL:String			= '28';

		public static const FG_NORMAL_BLACK:String	= '30';
		public static const FG_NORMAL_RED:String	= '31';
		public static const FG_NORMAL_GREEN:String	= '32';
		public static const FG_NORMAL_YELLOW:String = '33';
		public static const FG_NORMAL_BLUE:String	= '34';
		public static const FG_NORMAL_MAGENTA:String = '35';
		public static const FG_NORMAL_CYAN:String	= '36';
		public static const FG_NORMAL_WHITE:String	= '37';
		public static const FG_NORMAL_RESET:String	= '39';

		public static const BG_NORMAL_BLACK:String	= '40';
		public static const BG_NORMAL_RED:String	= '41';
		public static const BG_NORMAL_GREEN:String	= '42';
		public static const BG_NORMAL_YELLOW:String = '43';
		public static const BG_NORMAL_BLUE:String	= '44';
		public static const BG_NORMAL_MAGENTA:String = '45';
		public static const BG_NORMAL_CYAN:String	= '46';
		public static const BG_NORMAL_WHITE:String	= '47';
		public static const BG_NORMAL_RESET:String	= '49';

		public static const FG_BRIGHT_BLACK:String	= '90';
		public static const FG_BRIGHT_RED:String	= '91';
		public static const FG_BRIGHT_GREEN:String	= '92';
		public static const FG_BRIGHT_YELLOW:String = '93';
		public static const FG_BRIGHT_BLUE:String	= '94';
		public static const FG_BRIGHT_MAGENTA:String = '95';
		public static const FG_BRIGHT_CYAN:String	= '96';
		public static const FG_BRIGHT_WHITE:String	= '97';

		public static const BG_BRIGHT_BLACK:String	= '100';
		public static const BG_BRIGHT_RED:String	= '101';
		public static const BG_BRIGHT_GREEN:String	= '102';
		public static const BG_BRIGHT_YELLOW:String = '103';
		public static const BG_BRIGHT_BLUE:String	= '104';
		public static const BG_BRIGHT_MAGENTA:String = '105';
		public static const BG_BRIGHT_CYAN:String	= '106';
		public static const BG_BRIGHT_WHITE:String	= '107';
	}
}