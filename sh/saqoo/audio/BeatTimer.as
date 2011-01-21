package sh.saqoo.audio {
	import flash.media.SoundChannel;

	
	/**
	 * Modified version of org.libspark.media.utils.BeatTimer.
	 * This version uses SoundChannel#position prop to get current time.
	 * (Original version uses getTimer().)
	 * (I think this way is more acculate than original...)
	 * @see org.libspark.media.utils.BeatTimer
	 */
	public class BeatTimer {


		private var _bpm:Number;
		private var _beatPosition:Number;
		private var _phase:Number;
		private var _isOnBeat:Boolean = false;
		private var _channel:SoundChannel;
		
		
		public function BeatTimer() {
		}

		
		public function start(channel:SoundChannel, bpm:Number):void {
			_channel = channel;
			_bpm = bpm;
			update();
		}

		
		public function stop():void {
			if (_channel) _channel.stop();
		}

		
		public function update():Boolean {
			if (!_channel) return false;
			
			var currentTime:Number = _channel.position;
			var beatInterval:Number = (60 * 1000) / _bpm;
			var oldPosition:Number = _beatPosition;
			
			_beatPosition = currentTime / beatInterval;
			_phase = _beatPosition - int(_beatPosition);
			return _isOnBeat = int(oldPosition) != int(_beatPosition);
		}

		
		public function get bpm():Number { return _bpm; }
		public function get beatPosition():Number { return _beatPosition; }
		public function get phase():Number { return _phase; }
		public function get isOnBeat():Boolean { return _isOnBeat; }
		public function get soundChannel():SoundChannel { return _channel; }
		public function set soundChannel(value:SoundChannel):void { _channel = value; }
	}
}