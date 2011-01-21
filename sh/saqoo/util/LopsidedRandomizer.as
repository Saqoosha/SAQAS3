package sh.saqoo.util {

	
	/**
	 * @author Saqoosha
	 */
	public class LopsidedRandomizer {
		
		
		private var _ratio:Array;
		private var _values:Array;
		private var _max:Number;

		
		public function LopsidedRandomizer(data:Array) {
			init(data);
		}
		
		
		public function init(data:Array):void {
			if (data.length & 1) throw new ArgumentError('data length must be multiplies of 2.');
			_ratio = [];
			_values = [];
			var t:Number = 0;
			var n:int = data.length;
			for (var i:int = 0; i < n; i += 2) {
				_ratio.push(t);
				t += data[i];
				_values.push(data[i + 1]);
			}
			_max = t;
		}
		
		
		public function getNext():* {
			var r:Number = Math.random() * _max;
			var idx:int = -1;
			for each (var t:Number in _ratio) {
				if (r < t) break;
				idx++;
			}
			return _values[idx];
		}
	}
}
