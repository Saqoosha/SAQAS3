package net.saqoosha.util {
	
	public class DateUtil {
		
		public static var dayNamesShort:Array = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
		public static var monthNamesShort:Array = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct','Nov', 'Dec'];
		
		public static function toRFC822(d:Date):String {
			var date:Number = d.getDate();
			var hours:Number = d.getHours();
			var minutes:Number = d.getMinutes();
			var seconds:Number = d.getSeconds();
			var sb:String = new String();
			sb += dayNamesShort[d.getDay()];
			sb += ', ';
			sb += ('0' + date).substr(-2);
			sb += ' ';
			sb += monthNamesShort[d.getMonth()];
			sb += ' ';
			sb += d.getFullYear();
			sb += ' ';
			if (hours < 10) {			
				sb += '0';
			}
			sb += hours;
			sb += ':';
			if (minutes < 10) {
				sb += '0';
			}
			sb += minutes;
			sb += ':';
			if (seconds < 10) {
				sb += '0';
			}
			sb += seconds;
			sb += ' ';
			var offset:Number = d.timezoneOffset;
			if (offset < 0) {
				sb += '+';
				offset *= -1;
			} else {
				sb += '-';
			}
			var ofh:int = offset / 60;
			if (ofh < 10) {
				sb += '0';
			}
			sb += ofh;
			var ofm:int = offset % 60;
			if (ofm < 10) {
				sb += '0';
			}
			sb += ofm;
			return sb;
		}
	}
}