package sh.saqoo.audio {
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	
	/**
	 * @author Saqoosha
	 */
	public class SoundDataPlayer extends Sound {
		
		
		private var _data:ByteArray;
		private var _numSamples:int;
		private var _buffLen:int;
		
		
		public function SoundDataPlayer(data:ByteArray, bufferLen:int = 4096) {
			_data = data;
			_numSamples = _data.length / (4 * 2);
			_buffLen = Math.max(2048, Math.min(8192, bufferLen)) * 4 * 2;
			addEventListener(SampleDataEvent.SAMPLE_DATA, _onSampleData);
		}
	
	
		private function _onSampleData(event:SampleDataEvent):void {
			var idx:int = event.position * 4 * 2;
			var len:int = Math.min(_data.length - idx, _buffLen);
			if (len > 0) {
				event.data.writeBytes(_data, idx, len);
			}
		}
	}
}
