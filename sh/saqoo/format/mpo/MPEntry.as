package sh.saqoo.format.mpo {

	import flash.utils.ByteArray;
	import sh.saqoo.debug.ObjectDumper;

	
	
	/**
	 * @author Saqoosha
	 */
	class MPEntry {
		
		
		public var spec:uint;
		public var size:uint;
		public var offset:uint;
		public var slave1EntryNo:uint;
		public var slave2EntryNo:uint;
		
		
		public function MPEntry(data:ByteArray) {
			spec = data.readUnsignedInt();
			size = data.readUnsignedInt();
			offset = data.readUnsignedInt();
			slave1EntryNo = data.readUnsignedShort();
			slave2EntryNo = data.readUnsignedShort();
		}
		
		
		public function dump():void {
			ObjectDumper.dump({
				spec: spec.toString(16),
				size: size,
				offset: offset,
				slave1EntryNo: slave1EntryNo,
				slave2EntryNo: slave2EntryNo
			});
		}
	}
}
