package net.saqoosha.util {
	
	
	public class DateUtil {
		
		
		public static const MILLISECOND:Number = 1;
		public static const SECOND:Number = MILLISECOND * 1000;
		public static const MINUTE:Number = SECOND * 60;
		public static const HOUR:Number = MINUTE * 60;
		public static const DAY:Number = HOUR * 24;

		public static const DAY_NAME_SHORT:Array = [
			'Sun',
			'Mon',
			'Tue',
			'Wed',
			'Thu',
			'Fri',
			'Sat'
		];

		public static const MONTH_NAME_SHORT:Array = [
			'Jan',
			'Feb',
			'Mar',
			'Apr',
			'May',
			'Jun',
			'Jul',
			'Aug',
			'Sep',
			'Oct',
			'Nov',
			'Dec'
		];

        public static const MONTH_NAME_LONG:Array = [
			'January',
			'Febrary',
			'March',
			'April',
			'May',
			'June',
			'July',
			'August',
			'September',
			'October',
			'November',
			'December'
		];

        public static const TIMEZONE:Object = {
            'ADT': -3 * HOUR,
            'AST': -4 * HOUR,
            'CDT': -5 * HOUR,
            'CST': -6 * HOUR,
            'EDT': -4 * HOUR,
            'EST': -5 * HOUR,
            'GMT': 0,
            'MDT': -6 * HOUR,
            'MST': -7 * HOUR,
            'PDT': -7 * HOUR,
            'PST': -8 * HOUR,
            'UT': 0,
            'UTC': 0,
            'Z': 0,
            'A': -1 * HOUR,
            'M': -12 * HOUR,
            'N': 1 * HOUR,
            'Y': 12 * HOUR
        };
		
		
        public static function fromRFC822(dateString:String):Date {
            var parts:Array = dateString.split(/\s+/);
            var dayNames:Array = DAY_NAME_SHORT.map(function (...a):* {
				return a[0].toLowerCase();
			});

            var dn:String = parts[0].toLowerCase();
            var dl:int = dn.length - 1;
            if ([',', '.'].indexOf(dn.charAt(dl)) !== -1 ||
				dayNames.indexOf(dn) !== -1) {
                parts.shift();
            }

            var Y:int, m:int, d:int;
            d = int(parts.shift());
            m = MONTH_NAME_SHORT.indexOf(parts.shift());
            Y = int(parts.shift());

            var H:int, M:int, S:int, times:Array, tzInfo:String;
            //  check format.
            if (parts.length) {
                times = parts.shift().split(':');
                H = int(times.shift());
                M = int(times.shift());
                S = int(times.shift());
            }
            else {
                H = 0;
                M = 0;
                S = 0;
            }
            tzInfo = parts.shift() || 'GMT';

            var op:int = 1, offset:Number = 0, utc:Number = Date.UTC(Y, m, d, H, M, S);
            
            if (tzInfo.search(/\d/) === -1) {
                offset = TIMEZONE[tzInfo];
            }
            else {
                if (tzInfo.length > 4) {
                    if (tzInfo.charAt(0) == '-') {
                        op = -1;
                    }
                    tzInfo = tzInfo.substr(1, 4);
                }
                offset = (int(tzInfo.substr(0, 2)) * HOUR + int(tzInfo.substr(2, 2)) * MINUTE) * op;
            }
            return new Date(utc - offset);
        }


		public static function toRFC822(d:Date):String {
			var date:Number = d.getDate();
			var hours:Number = d.getHours();
			var minutes:Number = d.getMinutes();
			var seconds:Number = d.getSeconds();
			var sb:String = new String();
			sb += DAY_NAME_SHORT[d.getDay()];
			sb += ', ';
			sb += ('0' + date).substr(-2);
			sb += ' ';
			sb += MONTH_NAME_SHORT[d.getMonth()];
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


        public static function fromW3C(dateString:String):Date {
            var parts:Array = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})([-+](\d{2})(?::?(\d{2}))|Z)$/.exec(dateString);
            var utc:Number = Date.UTC(parts[1], int(parts[2])-1, parts[3], parts[4], parts[5], parts[6]);

            var offset:Number = 0;
            var tzInfo:String = parts[7];
            var hour:int = int(parts[8]);
            var minutes:int = int(parts[9]);

            if (tzInfo && tzInfo != 'Z') {
                offset = hour * HOUR + minutes * MINUTE;
                if (tzInfo.charAt(0) == '-') {
                    offset *= -1;
                }
            }
            return new Date(utc - offset);
        }
    }
}
