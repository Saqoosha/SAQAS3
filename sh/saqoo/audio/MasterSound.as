package sh.saqoo.audio {

	import fl.motion.easing.Circular;

	import de.polygonal.ds.DLL;
	import de.polygonal.ds.DLLNode;

	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;

	
	/**
	 * @author Saqoosha
	 */
	public class MasterSound extends Sound {

		
		public static const SAMPLES_PER_MSEC:Number = 44.1;
		public static const BUFFER_SAMPLES:int = 8192;
		public static const BUFFER_MSECS:Number = BUFFER_SAMPLES / SAMPLES_PER_MSEC;
		public static const BUFFER_BYTES:int = BUFFER_SAMPLES * 8;
		public static const SILENCE_DATA:ByteArray = new ByteArray();
		{
			SILENCE_DATA.length = BUFFER_BYTES;
		}


		private var _channel:SoundChannel;
		private var _sounds:DLL;
		private var _latency:Number = 0;
		private var _mute:Boolean = false;


		public function MasterSound() {
			addEventListener(SampleDataEvent.SAMPLE_DATA, _onSampleData);
			_sounds = new DLL();
		}
	
		
		public override function play(time:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel {
			_channel = super.play(time, loops, sndTransform);
			_mute = false;
			return _channel;
		}
		
		
		public function stop():void {
			_channel.stop();
		}

		
		public function addSound(sound:*, startTime:Number = 0, inPoint:Number = 0, duration:Number = 0, fadeInTime:Number = 0, fadeOutTime:Number = 0):MixInfo {
			var ip:Number = Math.max(0, inPoint);
			if (!duration) {
				if (sound is Sound) {
					duration = sound.length - ip;
				} else if (sound is ByteArray) {
					duration = sound.length / (SAMPLES_PER_MSEC * 8) - ip;
				}
			}
			var info:MixInfo = new MixInfo(sound, startTime, ip, duration, fadeInTime, fadeOutTime);
			_sounds.append(info);
			return info;
		}

		
		public function addMixInfo(info:MixInfo):void {
			_sounds.append(info);
		}
		
		
		public function removeAll():void {
			_sounds.clear();
		}

		
		private function _onSampleData(event:SampleDataEvent):void {
			var currentTime:Number = event.position / SAMPLES_PER_MSEC;
			if (_channel) {
				_latency = currentTime - _channel.position;
			}
			
			var tracks:Vector.<ByteArray> = new Vector.<ByteArray>();
			var node:DLLNode = _sounds.head;
			while (node) {
				var loop:MixInfo = MixInfo(node.val);
				if (loop.startTime + loop.duration <= currentTime) {
					node = _sounds.unlink(node);
					continue;
					
				} else if (loop.startTime < currentTime + BUFFER_MSECS) {
					var samples:ByteArray = new ByteArray();
					samples.length = BUFFER_BYTES;
					var startSamplePos:int = Math.max(0, (loop.startTime - currentTime) * SAMPLES_PER_MSEC);
					samples.position = startSamplePos * 8;
					var samplesNeeded:int = BUFFER_SAMPLES - startSamplePos
											 - Math.max(0, int((currentTime + BUFFER_MSECS - (loop.startTime + loop.duration)) * SAMPLES_PER_MSEC));
					var startPosInSound:int = int((loop.inPoint + Math.max(0, currentTime - loop.startTime)) * SAMPLES_PER_MSEC);
					if (loop.sound is Sound) {
						Sound(loop.sound).extract(samples, samplesNeeded, startPosInSound);
					} else if (loop.sound is ByteArray) {
						startPosInSound *= 8;
						samplesNeeded *= 8;
						trace([int(loop.sound.length * 1000) / 1000, startPosInSound, samplesNeeded, Math.min(samplesNeeded, loop.sound.length - startPosInSound)]);
						if (startPosInSound < loop.sound.length) {
							samples.writeBytes(loop.sound, startPosInSound, Math.min(samplesNeeded, loop.sound.length - startPosInSound));
						}
					}
					var i:int;
					var vol:Number;
					var val:Number;
					if (loop.fadeInTime > 0 && currentTime - loop.startTime < loop.fadeInTime) {
						samples.position = 0;
						for (i = 0; i < BUFFER_SAMPLES; i++) {
							vol = ((event.position + i) / SAMPLES_PER_MSEC - loop.startTime) / loop.fadeInTime;
							vol = vol > 1.0 ? 1.0 : vol < 0 ? 0 : vol;
							vol = Circular.easeIn(vol, 0, 1, 1);
							val = samples.readFloat();
							samples.position -= 4;
							samples.writeFloat(val * vol);
							val = samples.readFloat();
							samples.position -= 4;
							samples.writeFloat(val * vol);
						}
					}
//					trace(currentTime, loop.startTime + loop.duration - currentTime);
					if (loop.fadeOutTime > 0 && loop.startTime + loop.duration - (currentTime + BUFFER_MSECS) < loop.fadeOutTime) {
						samples.position = 0;
//						trace((loop.startTime + loop.duration - (event.position) / SAMPLES_PER_MSEC) / loop.fadeOutTime, '-', (loop.startTime + loop.duration - (event.position + BUFFER_SAMPLES) / SAMPLES_PER_MSEC) / loop.fadeOutTime);
						for (i = 0; i < BUFFER_SAMPLES; i++) {
							vol = (loop.startTime + loop.duration - (event.position + i) / SAMPLES_PER_MSEC) / loop.fadeOutTime;
							vol = vol > 1.0 ? 1.0 : vol < 0 ? 0 : vol;
							vol = Circular.easeIn(vol, 0, 1, 1);
							val = samples.readFloat();
							samples.position -= 4;
							samples.writeFloat(val * vol);
							val = samples.readFloat();
							samples.position -= 4;
							samples.writeFloat(val * vol);
						}
					}
					tracks.push(samples);
				}
				node = node.next;
			}
			
			if (tracks.length) {
				event.data.writeBytes(SimpleAudioMixer.mix(null, BUFFER_SAMPLES, tracks));
			} else {
				event.data.writeBytes(SILENCE_DATA);
			}
		}
		
		
		public function get volume():Number {
			return _channel.soundTransform.volume;
		}
		
		
		public function set volume(value:Number):void {
			var s:SoundTransform = _channel.soundTransform;
			s.volume = value;
			_channel.soundTransform = s;
		}
		
		
		public function get mute():Boolean {
			return _mute;
		}
		
		
		public function set mute(mute:Boolean):void {
			_mute = mute;
		}
		
		
		public function get playPosition():Number {
			return _channel ? _channel.position : 0;
		}
		
		
		/**
		 * @return current data position in milliseconds.
		 */
		public function get dataPosition():Number {
			return _channel ? _channel.position + _latency : 0;
		}
	
		
		/**
		 * @return current play latency in milliseconds.
		 */
		public function get latency():Number {
			return _latency;
		}
	}
}
