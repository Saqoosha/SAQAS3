package sh.saqoo.format.mpo {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Saqoosha
	 * @see http://www.cipa.jp/hyoujunka/kikaku/pdf/DC-007_J.pdf
	 */
	public class MPOParser extends EventDispatcher {


		private var _index:MPIndex;
		private var _images:Vector.<BitmapData>;
		private var _loaded:int;
		
		
		public function MPOParser(data:ByteArray) {
			var pos:int;
			var tag:int, length:int;
			while (!_index && data.position < data.length) {
				pos = data.position;
				tag = data.readUnsignedShort();
				if (tag == 0xFFD8 || tag == 0xFFD9) {
					length = 0;
				} else {
					length = data.readUnsignedShort();
				}
				switch (tag) {
					case 0xFFE2:
						_index = _parseAPP2(data, length);
						break;
				}
				if (length > 0) data.position += length - 4;
			}
			
			var n:int = _index.mpEntry.length;
			_images = new Vector.<BitmapData>(n);
			_loaded = 0;
			for (var i:int = 0; i < n; i++) {
				var entry:MPEntry = _index.mpEntry[i];
				var jpeg:ByteArray = new ByteArray();
				data.position = entry.offset;
				data.readBytes(jpeg, 0, entry.size);
				_loadImage(jpeg, i);
			}
		}
	
	
		private function _parseAPP2(data:ByteArray, length:int):MPIndex {
			var id:uint = data.readUnsignedInt();
			var zero:int = data.position;
			var endian:uint = data.readUnsignedInt();
			if (endian == 0x49492a00) data.endian = Endian.LITTLE_ENDIAN;
			var firstIFDOffset:uint = data.readUnsignedInt();
			data.position = zero + firstIFDOffset;
			var index:MPIndex = new MPIndex(data);
			for each (var entry:MPEntry in index.mpEntry) {
				if (entry.offset > 0) entry.offset += zero;
			}
			data.endian = Endian.BIG_ENDIAN;
			return index;
		}
	
	
		private function _loadImage(data:ByteArray, i:int):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void {
				_images[i] = Bitmap(loader.content).bitmapData;
				if (++_loaded == _images.length) {
					dispatchEvent(new Event(Event.COMPLETE));
				}
			});
			loader.loadBytes(data);
		}
		
		
		public function get index():MPIndex { return _index; }
		public function get images():Vector.<BitmapData> { return _images; }
		public function get numImages():int { return _index.numberOfImages; }
	}
}
