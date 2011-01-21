package sh.saqoo.midi.event {
	import sh.saqoo.util.StringUtil;

	/**
	 * @author Saqoosha
	 */
	public class SMFMIDIEvent extends SMFEvent {
		
		
		public static const TYPE_NOTE_OFF:int				= 0x80;
		public static const TYPE_NOTE_ON:int				= 0x90;
		public static const TYPE_POLYPHONIC_AFTERTOUCH:int	= 0xa0;
		public static const TYPE_CONTROL_CHANGE:int			= 0xb0;
		public static const TYPE_PROGRAM_CHANGE:int			= 0xc0;
		public static const TYPE_CHANNEL_AFTERTOUCH:int		= 0xd0;
		public static const TYPE_PITCH_WHEEL_CONTROL:int	= 0xe0;
		public static const TYPE_EXCLUSIVE:int				= 0xf0;
		
		public static const TYPE_QUATER_FRAME:int			= 0xf1;
		public static const TYPE_SONG_POSITION_POINTER:int	= 0xf2;
		public static const TYPE_SONG_SELECT:int			= 0xf3;
		public static const TYPE_TUNE_REQUEST:int			= 0xf6;
		public static const TYPE_END_OF_SYSEX:int			= 0xf7;
		
		public static const TYPE_TIMING_CLOCK:int			= 0xf8;
		public static const TYPE_START:int					= 0xfa;
		public static const TYPE_CONTINUE:int				= 0xfb;
		public static const TYPE_STOP:int					= 0xfc;
		public static const TYPE_ACTIVE_SENSING:int			= 0xfe;
		public static const TYPE_SYSTEM_RESET:int			= 0xff;
		
		//
		
		public static const CONTROL_BANK_SELECT_MSB:int				= 0x00;
		public static const CONTROL_MODULATION_WHEEL_MSB:int		= 0x01;
		public static const CONTROL_BREATH_CONTROLLER_MSB:int		= 0x02;
		public static const CONTROL_FOOT_CONTROLLER_MSB:int			= 0x04;
		public static const CONTROL_PORTAMENTO_TIME_MSB:int			= 0x05;
		public static const CONTROL_DATA_ENTRY_MSB_MSB:int			= 0x06;
		public static const CONTROL_CHANNEL_VOLUME_MSB:int			= 0x07;
		public static const CONTROL_BALANCE_MSB:int					= 0x08;
		public static const CONTROL_PAN_MSB:int						= 0x0a;
		public static const CONTROL_EXPRESSION_CONTROLLER_MSB:int	= 0x0b;
		public static const CONTROL_EFFECT_CONTROL_1_MSB:int		= 0x0c;
		public static const CONTROL_EFFECT_CONTROL_2_MSB:int		= 0x0d;

		public static const CONTROL_BANK_SELECT_LSB:int				= 0x20;
		public static const CONTROL_MODULATION_WHEEL_LSB:int		= 0x21;
		public static const CONTROL_BREATH_CONTROLLER_LSB:int		= 0x22;
		public static const CONTROL_FOOT_CONTROLLER_LSB:int			= 0x24;
		public static const CONTROL_PORTAMENTO_TIME_LSB:int			= 0x25;
		public static const CONTROL_DATA_ENTRY_LSB_LSB:int			= 0x26;
		public static const CONTROL_CHANNEL_VOLUME_LSB:int			= 0x27;
		public static const CONTROL_BALANCE_LSB:int					= 0x28;
		public static const CONTROL_PAN_LSB:int						= 0x2a;
		public static const CONTROL_EXPRESSION_CONTROLLER_LSB:int	= 0x2b;
		public static const CONTROL_EFFECT_CONTROL_1_LSB:int		= 0x2c;
		public static const CONTROL_EFFECT_CONTROL_2_LSB:int		= 0x2d;
		
		public static const CONTROL_DAMPER_PEDAL_ON_OFF:int			= 0x40;
		public static const CONTROL_PORTAMENTO_ON_OFF:int			= 0x41;
		public static const CONTROL_SOSTENUTO_ON_OFF:int			= 0x42;
		public static const CONTROL_SOFT_PEDAL_ON_OFF:int			= 0x43;
		public static const CONTROL_LEGATO_FOOTSWITCH:int			= 0x44;
		public static const CONTROL_HOLD_2:int						= 0x45;
		public static const CONTROL_SOUND_CONTROLLER_1:int			= 0x46;
		public static const CONTROL_SOUND_CONTROLLER_2:int			= 0x47;
		public static const CONTROL_SOUND_CONTROLLER_3:int			= 0x48;
		public static const CONTROL_SOUND_CONTROLLER_4:int			= 0x49;
		public static const CONTROL_SOUND_CONTROLLER_5:int			= 0x4a;
		public static const CONTROL_SOUND_CONTROLLER_6:int			= 0x4b;
		public static const CONTROL_SOUND_CONTROLLER_7:int			= 0x4c;
		public static const CONTROL_SOUND_CONTROLLER_8:int			= 0x4d;
		public static const CONTROL_SOUND_CONTROLLER_9:int			= 0x4e;
		public static const CONTROL_SOUND_CONTROLLER_10:int			= 0x4f;
		public static const CONTROL_GENERAL_PURPOSE_CTRLR_5:int		= 0x50;
		public static const CONTROL_GENERAL_PURPOSE_CTRLR_6:int		= 0x51;
		public static const CONTROL_GENERAL_PURPOSE_CTRLR_7:int		= 0x52;
		public static const CONTROL_GENERAL_PURPOSE_CTRLR_8:int		= 0x53;
		public static const CONTROL_PORTAMENTO_CONTROL:int			= 0x54;
		public static const CONTROL_EFFECT_1_DEPTH:int				= 0x5b;
		public static const CONTROL_EFFECT_2_DEPTH:int				= 0x5c;
		public static const CONTROL_EFFECT_3_DEPTH:int				= 0x5d;
		public static const CONTROL_EFFECT_4_DEPTH:int				= 0x5e;
		public static const CONTROL_EFFECT_5_DEPTH:int				= 0x5f;
		public static const CONTROL_DATA_INCREMENT:int				= 0x60;
		public static const CONTROL_DATA_DECREMENT:int				= 0x61;
		
		public static const CONTROL_ALL_SOUND_OFF:int				= 0x78;
		public static const CONTROL_RESET_ALL_CONTROLLERS:int		= 0x79;
		public static const CONTROL_LOCAL_CONTROL_ON_OFF:int		= 0x7a;
		public static const CONTROL_ALL_NOTES_OFF:int				= 0x7b;
		public static const CONTROL_OMNI_MODE_OFF:int				= 0x7c;
		public static const CONTROL_OMNI_MODE_ON:int				= 0x7d;
		public static const CONTROL_MONO_MODE_ON:int				= 0x7e;
		public static const CONTROL_MONO_MODE_OFF:int				= 0x7f;
		
		//
		
		private var _midiType:int;
		private var _channel:int;
		private var _data1:int;
		private var _data2:int;
		
		
		public function SMFMIDIEvent(deltaTime:int, type:int, channel:int = 0, data1:int = 0, data2:int = 0) {
			super(deltaTime, SMFEvent.TYPE_MIDI);
			_midiType = type;
			_data1 = data1;
			_data2 = data2;
		}

		
		public function get midiType():int {
			return _midiType;
		}
		
		
		public function set midiType(value:int):void {
			_midiType = value;
		}
		
		
		public function get channel():int {
			return _channel;
		}
		
		
		public function set channel(value:int):void {
			_channel = value;
		}

		
		public function get data1():int {
			return _data1;
		}
		
		
		public function set data1(value:int):void {
			_data1 = value;
		}
		
		
		public function get data2():int {
			return _data2;
		}
		
		
		public function set data2(value:int):void {
			_data2 = value;
		}
		
		
		//
		
		
		public function get note():int {
			return _data1;
		}
		
		
		public function set note(value:int):void {
			_data1 = value;
		}
		
		
		public function get velosity():int {
			return _data2;
		}
		
		
		public function set velosity(value:int):void {
			_data2 = value;
		}
		
		
		public function get pressure():int {
			return _data2;
		}

		
		public function set pressure(value:int):void {
			_data2 = value;
		}
		
		
		public function get control():int {
			return _data1;
		}
		
		
		public function set control(value:int):void {
			_data1 = value;
		}
		
		
		public override function toString():String {
			var s:String = '[SMFMIDIEvent delta=' + deltaTime + ' midiType=' + TYPE_NAME_TABLE[midiType] + '(0x' + StringUtil.toHex(midiType, 2) + ') channel=' + _channel;
			switch (_midiType) {
				case TYPE_NOTE_OFF:
				case TYPE_NOTE_ON:
					s += ' note#=' + data1 + ' velosity=' + data2 + ']';
					break;
				case TYPE_POLYPHONIC_AFTERTOUCH:
					s += ' note#=' + data1 + ' pressure=' + data2 + ']';
					break;
				case TYPE_CONTROL_CHANGE:
					s += ' control#=' + CONTROL_NAME_TABLE[data1] + '(0x' + StringUtil.toHex(data1, 2) + ') data=' + data2 + '(0x' + StringUtil.toHex(data2, 2) + ')]';
					break;
				case TYPE_PROGRAM_CHANGE:
					s += ' program#=' + data1 + ']';
					break;
				case TYPE_CHANNEL_AFTERTOUCH:
					s += ' pressure=' + data1 + ']';
					break;
				default:
					s += ' data1=' + data1 + ' data2=' + data2 + ']';
					break;
			}
			return s;
		}
		
		
		protected static var TYPE_NAME_TABLE:Object = {};
		protected static var CONTROL_NAME_TABLE:Object = {};
		{
			TYPE_NAME_TABLE[TYPE_NOTE_OFF] = 'NOTE_OFF';
			TYPE_NAME_TABLE[TYPE_NOTE_ON] = 'NOTE_ON';
			TYPE_NAME_TABLE[TYPE_POLYPHONIC_AFTERTOUCH] = 'POLYPHONIC_AFTERTOUCH';
			TYPE_NAME_TABLE[TYPE_CONTROL_CHANGE] = 'CONTROL_CHANGE';
			TYPE_NAME_TABLE[TYPE_PROGRAM_CHANGE] = 'PROGRAM_CHANGE';
			TYPE_NAME_TABLE[TYPE_CHANNEL_AFTERTOUCH] = 'CHANNEL_AFTERTOUCH';
			TYPE_NAME_TABLE[TYPE_PITCH_WHEEL_CONTROL] = 'PITCH_WHEEL_CONTROL';
			TYPE_NAME_TABLE[TYPE_EXCLUSIVE] = 'EXCLUSIVE';
			
			TYPE_NAME_TABLE[TYPE_QUATER_FRAME] = 'QUATER_FRAME';
			TYPE_NAME_TABLE[TYPE_SONG_POSITION_POINTER] = 'SONG_POSITION_POINTER';
			TYPE_NAME_TABLE[TYPE_SONG_SELECT] = 'SONG_SELECT';
			TYPE_NAME_TABLE[TYPE_TUNE_REQUEST] = 'TUNE_REQUEST';
			TYPE_NAME_TABLE[TYPE_END_OF_SYSEX] = 'END_OF_SYSEX';
			
			TYPE_NAME_TABLE[TYPE_TIMING_CLOCK] = 'TIMING_CLOCK';
			TYPE_NAME_TABLE[TYPE_START] = 'START';
			TYPE_NAME_TABLE[TYPE_CONTINUE] = 'CONTINUE';
			TYPE_NAME_TABLE[TYPE_STOP] = 'STOP';
			TYPE_NAME_TABLE[TYPE_ACTIVE_SENSING] = 'ACTIVE_SENSING';
			TYPE_NAME_TABLE[TYPE_SYSTEM_RESET] = 'SYSTEM_RESET';

			CONTROL_NAME_TABLE[CONTROL_BANK_SELECT_MSB] = 'BANK_SELECT_MSB';
			CONTROL_NAME_TABLE[CONTROL_MODULATION_WHEEL_MSB] = 'MODULATION_WHEEL_MSB';
			CONTROL_NAME_TABLE[CONTROL_BREATH_CONTROLLER_MSB] = 'BREATH_CONTROLLER_MSB';
			CONTROL_NAME_TABLE[CONTROL_FOOT_CONTROLLER_MSB] = 'FOOT_CONTROLLER_MSB';
			CONTROL_NAME_TABLE[CONTROL_PORTAMENTO_TIME_MSB] = 'PORTAMENTO_TIME_MSB';
			CONTROL_NAME_TABLE[CONTROL_DATA_ENTRY_MSB_MSB] = 'DATA_ENTRY_MSB_MSB';
			CONTROL_NAME_TABLE[CONTROL_CHANNEL_VOLUME_MSB] = 'CHANNEL_VOLUME_MSB';
			CONTROL_NAME_TABLE[CONTROL_BALANCE_MSB] = 'BALANCE_MSB';
			CONTROL_NAME_TABLE[CONTROL_PAN_MSB] = 'PAN_MSB';
			CONTROL_NAME_TABLE[CONTROL_EXPRESSION_CONTROLLER_MSB] = 'EXPRESSION_CONTROLLER_MSB';
			CONTROL_NAME_TABLE[CONTROL_EFFECT_CONTROL_1_MSB] = 'EFFECT_CONTROL_1_MSB';
			CONTROL_NAME_TABLE[CONTROL_EFFECT_CONTROL_2_MSB] = 'EFFECT_CONTROL_2_MSB';
			
			CONTROL_NAME_TABLE[CONTROL_BANK_SELECT_LSB] = 'BANK_SELECT_LSB';
			CONTROL_NAME_TABLE[CONTROL_MODULATION_WHEEL_LSB] = 'MODULATION_WHEEL_LSB';
			CONTROL_NAME_TABLE[CONTROL_BREATH_CONTROLLER_LSB] = 'BREATH_CONTROLLER_LSB';
			CONTROL_NAME_TABLE[CONTROL_FOOT_CONTROLLER_LSB] = 'FOOT_CONTROLLER_LSB';
			CONTROL_NAME_TABLE[CONTROL_PORTAMENTO_TIME_LSB] = 'PORTAMENTO_TIME_LSB';
			CONTROL_NAME_TABLE[CONTROL_DATA_ENTRY_LSB_LSB] = 'DATA_ENTRY_LSB_LSB';
			CONTROL_NAME_TABLE[CONTROL_CHANNEL_VOLUME_LSB] = 'CHANNEL_VOLUME_LSB';
			CONTROL_NAME_TABLE[CONTROL_BALANCE_LSB] = 'BALANCE_LSB';
			CONTROL_NAME_TABLE[CONTROL_PAN_LSB] = 'PAN_LSB';
			CONTROL_NAME_TABLE[CONTROL_EXPRESSION_CONTROLLER_LSB] = 'EXPRESSION_CONTROLLER_LSB';
			CONTROL_NAME_TABLE[CONTROL_EFFECT_CONTROL_1_LSB] = 'EFFECT_CONTROL_1_LSB';
			CONTROL_NAME_TABLE[CONTROL_EFFECT_CONTROL_2_LSB] = 'EFFECT_CONTROL_2_LSB';
			
			CONTROL_NAME_TABLE[CONTROL_DAMPER_PEDAL_ON_OFF] = 'DAMPER_PEDAL_ON_OFF';
			CONTROL_NAME_TABLE[CONTROL_PORTAMENTO_ON_OFF] = 'PORTAMENTO_ON_OFF';
			CONTROL_NAME_TABLE[CONTROL_SOSTENUTO_ON_OFF] = 'SOSTENUTO_ON_OFF';
			CONTROL_NAME_TABLE[CONTROL_SOFT_PEDAL_ON_OFF] = 'SOFT_PEDAL_ON_OFF';
			CONTROL_NAME_TABLE[CONTROL_LEGATO_FOOTSWITCH] = 'LEGATO_FOOTSWITCH';
			CONTROL_NAME_TABLE[CONTROL_HOLD_2] = 'HOLD_2';
			CONTROL_NAME_TABLE[CONTROL_SOUND_CONTROLLER_1] = 'SOUND_CONTROLLER_1';
			CONTROL_NAME_TABLE[CONTROL_SOUND_CONTROLLER_2] = 'SOUND_CONTROLLER_2';
			CONTROL_NAME_TABLE[CONTROL_SOUND_CONTROLLER_3] = 'SOUND_CONTROLLER_3';
			CONTROL_NAME_TABLE[CONTROL_SOUND_CONTROLLER_4] = 'SOUND_CONTROLLER_4';
			CONTROL_NAME_TABLE[CONTROL_SOUND_CONTROLLER_5] = 'SOUND_CONTROLLER_5';
			CONTROL_NAME_TABLE[CONTROL_SOUND_CONTROLLER_6] = 'SOUND_CONTROLLER_6';
			CONTROL_NAME_TABLE[CONTROL_SOUND_CONTROLLER_7] = 'SOUND_CONTROLLER_7';
			CONTROL_NAME_TABLE[CONTROL_SOUND_CONTROLLER_8] = 'SOUND_CONTROLLER_8';
			CONTROL_NAME_TABLE[CONTROL_SOUND_CONTROLLER_9] = 'SOUND_CONTROLLER_9';
			CONTROL_NAME_TABLE[CONTROL_SOUND_CONTROLLER_10] = 'SOUND_CONTROLLER_10';
			CONTROL_NAME_TABLE[CONTROL_GENERAL_PURPOSE_CTRLR_5] = 'GENERAL_PURPOSE_CTRLR_5';
			CONTROL_NAME_TABLE[CONTROL_GENERAL_PURPOSE_CTRLR_6] = 'GENERAL_PURPOSE_CTRLR_6';
			CONTROL_NAME_TABLE[CONTROL_GENERAL_PURPOSE_CTRLR_7] = 'GENERAL_PURPOSE_CTRLR_7';
			CONTROL_NAME_TABLE[CONTROL_GENERAL_PURPOSE_CTRLR_8] = 'GENERAL_PURPOSE_CTRLR_8';
			CONTROL_NAME_TABLE[CONTROL_PORTAMENTO_CONTROL] = 'PORTAMENTO_CONTROL';
			CONTROL_NAME_TABLE[CONTROL_EFFECT_1_DEPTH] = 'EFFECT_1_DEPTH';
			CONTROL_NAME_TABLE[CONTROL_EFFECT_2_DEPTH] = 'EFFECT_2_DEPTH';
			CONTROL_NAME_TABLE[CONTROL_EFFECT_3_DEPTH] = 'EFFECT_3_DEPTH';
			CONTROL_NAME_TABLE[CONTROL_EFFECT_4_DEPTH] = 'EFFECT_4_DEPTH';
			CONTROL_NAME_TABLE[CONTROL_EFFECT_5_DEPTH] = 'EFFECT_5_DEPTH';
			CONTROL_NAME_TABLE[CONTROL_DATA_INCREMENT] = 'DATA_INCREMENT';
			CONTROL_NAME_TABLE[CONTROL_DATA_DECREMENT] = 'DATA_DECREMENT';
			
			CONTROL_NAME_TABLE[CONTROL_ALL_SOUND_OFF] = 'ALL_SOUND_OFF';
			CONTROL_NAME_TABLE[CONTROL_RESET_ALL_CONTROLLERS] = 'RESET_ALL_CONTROLLERS';
			CONTROL_NAME_TABLE[CONTROL_LOCAL_CONTROL_ON_OFF] = 'LOCAL_CONTROL_ON_OFF';
			CONTROL_NAME_TABLE[CONTROL_ALL_NOTES_OFF] = 'ALL_NOTES_OFF';
			CONTROL_NAME_TABLE[CONTROL_OMNI_MODE_OFF] = 'OMNI_MODE_OFF';
			CONTROL_NAME_TABLE[CONTROL_OMNI_MODE_ON] = 'OMNI_MODE_ON';
			CONTROL_NAME_TABLE[CONTROL_MONO_MODE_ON] = 'MONO_MODE_ON';
			CONTROL_NAME_TABLE[CONTROL_MONO_MODE_OFF] = 'MONO_MODE_OFF';
		}
	}
}
