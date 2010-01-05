package net.saqoosha.midi {
	import net.saqoosha.midi.chunk.SMFChunk;
	import net.saqoosha.midi.chunk.SMFHeaderChunk;
	import net.saqoosha.midi.chunk.SMFTrackChunk;
	import net.saqoosha.midi.event.SMFEvent;
	import net.saqoosha.midi.event.SMFMIDIEvent;
	import net.saqoosha.midi.event.SMFMetaEvent;
	import net.saqoosha.midi.event.SMFSysExEvent;
	import net.saqoosha.midi.event.meta.SMFKeySignatureEvent;
	import net.saqoosha.midi.event.meta.SMFNumberEvent;
	import net.saqoosha.midi.event.meta.SMFSMPTEOffsetEvent;
	import net.saqoosha.midi.event.meta.SMFTextEvent;
	import net.saqoosha.midi.event.meta.SMFTimeSignatureEvent;
	import net.saqoosha.util.StringUtil;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author hiko
	 */
	public class SMFParser {
		
		
		private var _header:SMFHeaderChunk;
		private var _tracks:Array;
		private var _currentTrack:SMFTrackChunk;
		
		
		public function SMFParser():void {
		}
		
		
		public function parse(data:ByteArray):void {
			data.endian = Endian.BIG_ENDIAN;
			
			var type:uint;
			var len:uint;
			
			type = data.readUnsignedInt();
			if (type != SMFChunk.TYPE_HEADER) {
				throw new Error('This data maybe not SMF.');
			}
			len = data.readUnsignedInt();
			_header = _parseHeaderChunk(data);
//			trace(_header);
			
			_tracks = [];
			for (var i:int = 0; i < _header.numTracks; ++i) {
//			trace('\nTrack:', i);
				type = data.readUnsignedInt();
				len = data.readUnsignedInt();
				if (type == SMFChunk.TYPE_TRACK) {
					_tracks.push(_parseTrackChunk(data, len));
				} else {
					throw new Error('Unknown track type appeared: 0x' + StringUtil.toHex(type, 2));
				}
			}
		}

		
		private function _parseHeaderChunk(data:ByteArray):SMFHeaderChunk {
			var header:SMFHeaderChunk = new SMFHeaderChunk();
			header.format = data.readUnsignedShort();
			header.numTracks = data.readUnsignedShort();
			header.resolution = data.readUnsignedShort();
			return header;
		}
		
		
		private function _parseTrackChunk(data:ByteArray, len:uint):SMFTrackChunk {
//		trace('Track Chunk: position=', data.position, ', length=', len);
			var start:uint = data.position;
			var track:SMFTrackChunk = new SMFTrackChunk();
			_currentTrack = track;
			var delta:int;
			var status:int;
			var lastStatus:int;
			var channel:int;
			var p:uint;
			var ev:SMFEvent;
			while (data.position - start < len) {
				p = data.position;
				delta = _readVarInt(data);
				status = data.readUnsignedByte();
//			trace('\n*position:', p.toString(16), ', delta:', delta, ', status:', status.toString(16));
				switch (status) {
					case 0xf0: // sysex
						_currentTrack.pushEvent(_parseSysExEvent(delta, 0xf0, data));
						break;
					case 0xf7: // sysex
						_currentTrack.pushEvent(_parseSysExEvent(delta, 0xf7, data));
						break;
					case 0xff: // meta event
						_currentTrack.pushEvent(_parseMetaEvent(delta, data));
						break;
					default:
						if (status & 0x80) {
							channel = status & 0x0f;
						} else {
//							trace('-- running status:', lastStatus.toString(16));
							status = lastStatus;
							data.position -= 1;
						}
						switch (status & 0xf0) {
							case SMFMIDIEvent.TYPE_NOTE_OFF:
								_currentTrack.pushEvent(new SMFMIDIEvent(delta, SMFMIDIEvent.TYPE_NOTE_OFF, channel, data.readUnsignedByte(), data.readUnsignedByte()));
								break;
							case SMFMIDIEvent.TYPE_NOTE_ON:
								_currentTrack.pushEvent(new SMFMIDIEvent(delta, SMFMIDIEvent.TYPE_NOTE_ON, channel, data.readUnsignedByte(), data.readUnsignedByte()));
								break;
							case SMFMIDIEvent.TYPE_POLYPHONIC_AFTERTOUCH:
								_currentTrack.pushEvent(new SMFMIDIEvent(delta, SMFMIDIEvent.TYPE_POLYPHONIC_AFTERTOUCH, channel, data.readUnsignedByte(), data.readUnsignedByte()));
								break;
							case SMFMIDIEvent.TYPE_CONTROL_CHANGE:
//								_parseControlChange(channel, data);
								_currentTrack.pushEvent(new SMFMIDIEvent(delta, SMFMIDIEvent.TYPE_CONTROL_CHANGE, channel, data.readUnsignedByte(), data.readUnsignedByte()));
								break;
							case SMFMIDIEvent.TYPE_PROGRAM_CHANGE:
								_currentTrack.pushEvent(new SMFMIDIEvent(delta, SMFMIDIEvent.TYPE_PROGRAM_CHANGE, channel, data.readUnsignedByte()));
								break;
							case SMFMIDIEvent.TYPE_CHANNEL_AFTERTOUCH:
								_currentTrack.pushEvent(new SMFMIDIEvent(delta, SMFMIDIEvent.TYPE_CHANNEL_AFTERTOUCH, data.readUnsignedByte()));
								break;
							case SMFMIDIEvent.TYPE_PITCH_WHEEL_CONTROL:
								_currentTrack.pushEvent(new SMFMIDIEvent(delta, SMFMIDIEvent.TYPE_PITCH_WHEEL_CONTROL, channel, data.readUnsignedByte(), data.readUnsignedByte()));
								break;
						}
						break;
				}
				lastStatus = status;
			}
			_currentTrack = null;
			return track;
		}

		
		//		private function _parseControlChange(channel:int, data:ByteArray):void {
//			var ctrl:int = data.readUnsignedByte();
//			var value:int = data.readUnsignedByte();
//			switch (ctrl) {
//				case 0x00:
//					trace('Bank select:', value, '(MSB)');
//					break;
//				case 0x01:
//					trace('Modulation depth:', value, '(MSB)');
//					break;
//				case 0x02:
//					trace('Breath control:', value, '(MSB)');
//					break;
//				case 0x04:
//					trace('Foot control:', value, '(MSB)');
//					break;
//				case 0x05:
//					trace('Portament time:', value, '(MSB)');
//					break;
//				case 0x06:
//					trace('Data entry:', value, '(MSB)');
//					break;
//				case 0x07:
//					trace('Main volume:', value, '(MSB)');
//					break;
//				case 0x08:
//					trace('Balance control:', value, '(MSB)');
//					break;
//				case 0x0a:
//					trace('Panpot:', value, '(MSB)');
//					break;
//				case 0x0b:
//					trace('Expression:', value, '(MSB)');
//					break;
//					
//				case 0x20:
//					trace('Bank select:', value, '(LSB)');
//					break;
//				case 0x21:
//					trace('Modulation depth:', value, '(LSB)');
//					break;
//				case 0x22:
//					trace('Breath control:', value, '(LSB)');
//					break;
//				case 0x24:
//					trace('Foot control:', value, '(LSB)');
//					break;
//				case 0x25:
//					trace('Portament time:', value, '(LSB)');
//					break;
//				case 0x26:
//					trace('Data entry:', value, '(LSB)');
//					break;
//				case 0x27:
//					trace('Main volume:', value, '(LSB)');
//					break;
//				case 0x28:
//					trace('Balance control:', value, '(LSB)');
//					break;
//				case 0x2a:
//					trace('Panpot:', value, '(LSB)');
//					break;
//				case 0x2b:
//					trace('Expression:', value, '(LSB)');
//					break;
//					
//				case 0x78:
//					trace('All sound off');
//					break;
//				case 0x79:
//					trace('Reset all controller');
//					break;
//				case 0x7a:
//					trace('Local control:', value);
//					break;
//				case 0x7b:
//					trace('All note off');
//					break;
//				case 0x7c:
//					trace('Omni off');
//					break;
//				case 0x7d:
//					trace('Omni on');
//					break;
//				case 0x7e:
//					trace('Monophonic on');
//					break;
//				case 0x7f:
//					trace('Polyphonic on');
//					break;
//					
//				default:
//					trace('Unknown control:', ctrl.toString(16), value);
//					break;
//			}
//		}
		
		
		private function _parseSysExEvent(delta:uint, type:int, data:ByteArray):SMFSysExEvent {
			var len:int = _readVarInt(data);
			var exdata:ByteArray = new ByteArray();
			data.readBytes(exdata, 0, len);
			var ev:SMFSysExEvent = new SMFSysExEvent(delta);
			ev.data = exdata;
			return ev;
		}

		
		private function _parseMetaEvent(delta:uint, data:ByteArray):SMFMetaEvent {
			var p:uint = data.position;
			var type:int = data.readUnsignedByte();
			var len:int = _readVarInt(data);
//			trace('Meta Event: position=', p.toString(16), ', type=', type.toString(16), ', length=', len);
			var ev:SMFMetaEvent;
//			var text:String;
			
			switch (type) {
				case SMFMetaEvent.TYPE_SEQUENCE_NUMBER:
					ev = new SMFNumberEvent(delta, SMFMetaEvent.TYPE_SEQUENCE_NUMBER, data.readUnsignedByte());
					break;
					
				case SMFMetaEvent.TYPE_TEXT:
					ev = new SMFTextEvent(delta, SMFMetaEvent.TYPE_TEXT, data.readUTFBytes(len));
					break;
					
				case SMFMetaEvent.TYPE_COPYRIGHT_NOTICE:
					ev = new SMFTextEvent(delta, SMFMetaEvent.TYPE_COPYRIGHT_NOTICE, data.readUTFBytes(len));
					break;
					
				case SMFMetaEvent.TYPE_SEQUENCE_NAME:
					ev = new SMFTextEvent(delta, SMFMetaEvent.TYPE_SEQUENCE_NAME, data.readUTFBytes(len));
					break;
					
				case SMFMetaEvent.TYPE_INSTRUMENT_NAME:
					ev = new SMFTextEvent(delta, SMFMetaEvent.TYPE_INSTRUMENT_NAME, data.readUTFBytes(len));
					break;
					
				case SMFMetaEvent.TYPE_LYRIC:
					ev = new SMFTextEvent(delta, SMFMetaEvent.TYPE_LYRIC, data.readUTFBytes(len));
					break;
					
				case SMFMetaEvent.TYPE_MARKER:
					ev = new SMFTextEvent(delta, SMFMetaEvent.TYPE_MARKER, data.readUTFBytes(len));
					break;
					
				case SMFMetaEvent.TYPE_QUEUE_POINT:
					ev = new SMFTextEvent(delta, SMFMetaEvent.TYPE_QUEUE_POINT, data.readUTFBytes(len));
					break;
					
				case SMFMetaEvent.TYPE_CHANNEL_PREFIX:
					ev = new SMFNumberEvent(delta, SMFMetaEvent.TYPE_CHANNEL_PREFIX, data.readUnsignedByte());
					break;
					
				case SMFMetaEvent.TYPE_END_OF_TRACK:
					ev = new SMFMetaEvent(delta, SMFMetaEvent.TYPE_END_OF_TRACK);
					break;
					
				case SMFMetaEvent.TYPE_SET_TEMPO:
					ev = new SMFNumberEvent(delta, SMFMetaEvent.TYPE_SET_TEMPO, (data.readUnsignedByte() << 16) | (data.readUnsignedByte() << 8) | data.readUnsignedByte());
					break;
					
				case SMFMetaEvent.TYPE_SMPTE_OFFSET:
					ev = new SMFSMPTEOffsetEvent(delta, data.readUnsignedByte(), data.readUnsignedByte(), data.readUnsignedByte(), data.readUnsignedByte());
					data.readUnsignedByte(); // 0xff
					break;
					
				case SMFMetaEvent.TYPE_TIME_SIGNATURE:
					ev = new SMFTimeSignatureEvent(delta, data.readUnsignedByte(), data.readUnsignedByte(), data.readUnsignedByte(), data.readUnsignedByte());
					break;
					
				case SMFMetaEvent.TYPE_KEY_SIGNATURE:
					ev = new SMFKeySignatureEvent(delta, data.readByte(), data.readByte() < 0);
					break;
					
				case SMFMetaEvent.TYPE_SEQUENCER_SPECIFIC:
				default:
					ev = new SMFMetaEvent(delta, SMFMetaEvent.TYPE_SEQUENCER_SPECIFIC);
					// TODO: implement to handle data correctly
					data.readBytes(data, data.position, len); // skip ?
					break;
			}
			return ev;
		}

		
		private function _readVarInt(data:ByteArray):int {
			var tmp:uint = data.readByte();
			var val:uint = tmp & 0x7f;
			while (tmp & 0x80) {
				tmp = data.readByte();
				val = (val << 7) | (tmp & 0x7f);
			}
			return val;
		}
		
		
		private function _skipDataBytes(data:ByteArray):void {
			while (data.readUnsignedByte() & 0x80);
		}
		
		
		//
		
		
		public function get format():int {
			return _header.format;
		}
		
		
		public function get numTracks():int {
			return _header.numTracks;
		}
		
		
		public function get resolution():int {
			return _header.resolution;
		}
		
		
		public function get tracks():Array {
			return _tracks;
		}
		
		
		public function get duration():int {
			var dur:int = int.MIN_VALUE;
			for each (var t:SMFTrackChunk in _tracks) {
				if (t.duration > dur) {
					dur = t.duration;
				}
			}
			return dur;
		}

		
		//
		
		
		public function dump():void {
			trace('Header ------------------');
			trace('\t' + _header + '\n');
			for (var i:int = 0; i < numTracks; ++i) {
				trace('Track #' + (i + 1) + ' ------------------');
				var j:int = 1;
				for each (var e:SMFEvent in _tracks[i].events) {
					trace('\t' + e.toString());
				}
				trace();
			}
		}
	}
}
