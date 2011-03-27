package sh.saqoo.net.facecom {
	/**
	 * @author Saqoosha
	 */
	public class Usage {
		
		
		private var _limit:uint;
		private var _used:uint;
		private var _remaining:uint;
		private var _resetTime:Date;
		
		
		public function Usage(data:Object) {
			_limit = data.limit;
			_used = data.used;
			_remaining = data.remaining;
			_resetTime = new Date(data.reset_time * 1000);
		}
		
		
		public function get limit():uint { return _limit; }
		public function get used():uint { return _used; }
		public function get remaining():uint { return _remaining; }
		public function get resetTime():Date { return _resetTime; }
	}
}
