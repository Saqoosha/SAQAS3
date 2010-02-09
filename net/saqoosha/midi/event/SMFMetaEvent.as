package net.saqoosha.midi.event {
	import net.saqoosha.util.StringUtil;

	/**
	 * @author Saqoosha
	 */
	public class SMFMetaEvent extends SMFEvent {
		
		
		public static const TYPE_SEQUENCE_NUMBER:int	= 0x00;
		public static const TYPE_TEXT:int				= 0x01;
		public static const TYPE_COPYRIGHT_NOTICE:int	= 0x02;
		public static const TYPE_SEQUENCE_NAME:int		= 0x03;
		public static const TYPE_INSTRUMENT_NAME:int	= 0x04;
		public static const TYPE_LYRIC:int				= 0x05;
		public static const TYPE_MARKER:int				= 0x06;
		public static const TYPE_QUEUE_POINT:int		= 0x07;
		public static const TYPE_CHANNEL_PREFIX:int		= 0x20;
		public static const TYPE_END_OF_TRACK:int		= 0x2f;
		public static const TYPE_SET_TEMPO:int			= 0x51;
		public static const TYPE_SMPTE_OFFSET:int		= 0x54;
		public static const TYPE_TIME_SIGNATURE:int		= 0x58;
		public static const TYPE_KEY_SIGNATURE:int		= 0x59;
		public static const TYPE_SEQUENCER_SPECIFIC:int = 0x7f;
		
		protected static var TYPE_NAME_TABLE:Object = {};
		{
			TYPE_NAME_TABLE[TYPE_SEQUENCE_NUMBER] = 'SEQUENCE_NUMBER';
			TYPE_NAME_TABLE[TYPE_TEXT] = 'TEXT';
			TYPE_NAME_TABLE[TYPE_COPYRIGHT_NOTICE] = 'COPYRIGHT_NOTICE';
			TYPE_NAME_TABLE[TYPE_SEQUENCE_NAME] = 'SEQUENCE_NAME';
			TYPE_NAME_TABLE[TYPE_INSTRUMENT_NAME] = 'INSTRUMENT_NAME';
			TYPE_NAME_TABLE[TYPE_LYRIC] = 'LYRIC';
			TYPE_NAME_TABLE[TYPE_MARKER] = 'MARKER';
			TYPE_NAME_TABLE[TYPE_QUEUE_POINT] = 'QUEUE_POINT';
			TYPE_NAME_TABLE[TYPE_CHANNEL_PREFIX] = 'CHANNEL_PREFIX';
			TYPE_NAME_TABLE[TYPE_END_OF_TRACK] = 'END_OF_TRACK';
			TYPE_NAME_TABLE[TYPE_SET_TEMPO] = 'SET_TEMPO';
			TYPE_NAME_TABLE[TYPE_SMPTE_OFFSET] = 'SMPTE_OFFSET';
			TYPE_NAME_TABLE[TYPE_TIME_SIGNATURE] = 'TIME_SIGNATURE';
			TYPE_NAME_TABLE[TYPE_KEY_SIGNATURE] = 'KEY_SIGNATURE';
			TYPE_NAME_TABLE[TYPE_SEQUENCER_SPECIFIC] = 'SEQUENCER_SPECIFIC';
		}
		
		
		//
		
		
		private var _metaType:int;

		
		public function SMFMetaEvent(deltaTime:int, type:int) {
			super(deltaTime, SMFEvent.TYPE_META);
			metaType = type;
		}

		
		public function get metaType():int {
			return _metaType;
		}
		
		
		public function set metaType(value:int):void {
			_metaType = value;
		}
		
		
		public override function toString():String {
			return '[SMFMetaEvent delta=' + deltaTime + ' type=' + TYPE_NAME_TABLE[_metaType] + '(0x' + StringUtil.toHex(metaType, 2) + ')]';
		}
	}
}
