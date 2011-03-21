package sh.saqoo.net.detectface {


	/**
	 * @author Saqoosha
	 */
	public class PointNames {
		
		// Line is left to right, top to bottom.
		// Polygon is clockwise.
		
		public static function get FACE():Array { return ['F10', 'F9', 'F8', 'F7', 'F6', 'F5', 'F4', 'F3', 'F2', 'F1']; }
		
		public static function get LEFT_BROW():Array { return ['BL1', 'BL2', 'BL3', 'BL4', 'BL5', 'BL6']; }
		public static function get LEFT_BROW_UPPER_LINE():Array { return ['BL1', 'BL2', 'BL3', 'BL4', 'BL5']; }
		public static function get LEFT_BROW_LOWER_LINE():Array { return ['BL1', 'BL6', 'BL5']; }
		
		public static function get RIGHT_BROW():Array { return ['BR1', 'BR6', 'BR5', 'BR4', 'BR3', 'BR2']; }
		public static function get RIGHT_BROW_UPPER_LINE():Array { return ['BR5', 'BR4', 'BR3', 'BR2', 'BR1']; }
		public static function get RIGHT_BROW_BOTTOM_LINE():Array { return ['BR5', 'BR6', 'BR1']; }
		
		public static function get LEFT_EYE():Array { return ['EL1', 'EL2', 'EL3', 'EL4', 'EL5', 'EL6']; }
		public static function get LEFT_EYE_UPPER_LINE():Array { return ['EL1', 'EL2', 'EL3', 'EL4']; }
		public static function get LEFT_EYE_LOWER_LINE():Array { return ['EL1', 'EL6', 'EL5', 'EL4']; }
		
		public static function get RIGHT_EYE():Array { return ['ER1', 'ER6', 'ER5', 'ER4', 'ER3', 'ER2']; }
		public static function get RIGHT_EYE_UPPER_LINE():Array { return ['ER4', 'ER3', 'ER2', 'ER1']; }
		public static function get RIGHT_EYE_LOWER_LINE():Array { return ['ER4', 'ER5', 'ER1', 'ER1']; }
		
		public static function get NOSE_ALL():Array { return ['N1', 'N2', 'N3', 'N4', 'N5']; }
		public static function get NOSE_VERTICAL_LINE():Array { return ['N1', 'N5', 'N3']; }
		public static function get NOSE_BOTTOM_LINE():Array { return ['N2', 'N3', 'N4']; }
		public static function get NOSE_ROUND():Array { return ['N1', 'N4', 'N3', 'N2']; }
		
		public static function get MOUTH_ALL():Array { return ['M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8', 'M9']; }
		public static function get MOUTH_UPPER_LINE():Array { return ['M3', 'M2', 'M1', 'M8', 'M7']; }
		public static function get MOUTH_MIDDLE_LINE():Array { return ['M3', 'M9', 'M7']; }
		public static function get MOUTH_LOWER_LINE():Array { return ['M3', 'M4', 'M5', 'M6', 'M7']; }
		public static function get MOUTH_ROUND():Array { return ['M8', 'M7', 'M6', 'M5', 'M4', 'M3', 'M2', 'M1']; }
	}
}
