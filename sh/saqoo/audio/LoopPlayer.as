package sh.saqoo.audio {
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;

	
	/**
	 * Play loop sound seemlessly.
	 * @author Saqoosha
	 */
	public class LoopPlayer {


		private var _master:MasterSound;
		private var _channel:SoundChannel;
		
		private var _sound:Sound;
		private var _length:Number;
		private var _nextTime:Number;
		private var _timer:Timer;

		
		/**
		 * @param sound Sound object.
		 * @param loopLength Loop length in milliseconds.
		 */
		public function LoopPlayer(sound:Sound, loopLength:int = 0) {
			_sound = sound;
			_length = Math.min(_sound.length, loopLength) || _sound.length;
		}

		
		public function play(soundTransform:SoundTransform = null):void {
			_master = new MasterSound();
			_master.addSound(_sound);
			_channel = _master.play(0, 0, soundTransform);
			_nextTime = _length;
			_timer = new Timer(_nextTime - 1000, 1);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
		}

		
		public function stop():void {
			_master.stop();
			_master = null;
			_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
			_timer = null;
		}

		
		private function _onTimer(event:TimerEvent):void {
			_master.addSound(_sound, _nextTime);
			_timer.stop();
			_timer.reset();
			_timer.delay = _length - (1000 - (_nextTime - _master.dataPosition));
			_timer.start();
			_nextTime += _length;
		}
		
		
		public function get masterSound():MasterSound { return _master; }
		
		
	}
}
