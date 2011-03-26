package sh.saqoo.format.mpo {

	import flash.utils.ByteArray;
	
	/**
	 * @author Saqoosha
	 */
	class MPIndex {
		
		
		public var count:int;
		public var version:String;
		public var numberOfImages:uint;
		public var offsetToNextIFD:uint;
		public var mpEntry:Vector.<MPEntry>;
		
		
		public function MPIndex(data:ByteArray) {
			count = data.readUnsignedShort();
			for (var i:int = 0; i < count; i++) {
				var tag:int = data.readUnsignedShort();
				var type:int = data.readUnsignedShort();
				var cnt:int = data.readUnsignedInt();
				switch (tag) {
					case 0xB000: // MPF Version
						version = data.readUTFBytes(4);
						break;
					case 0xB001: // Number of Images
						numberOfImages = data.readUnsignedInt();
						break;
					case 0xB002: // MP Entry
						data.readUnsignedInt();
						break;
				}
			}
			offsetToNextIFD = data.readUnsignedInt();
			mpEntry = new Vector.<MPEntry>();
			for (i = 0; i < numberOfImages; i++) {
				mpEntry.push(new MPEntry(data));
			}
		}
	}
}
