package net.saqoosha.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="cancel", type="flash.events.Event")]

	
	/**
	 * @author Saqoosha
	 */
	public class ImageFileSelector extends EventDispatcher {

		
		private var _file:FileReference;
		private var _image:BitmapData;

		
		public function ImageFileSelector() {
		}
		
		
		public function browse():void {
			_file = new FileReference();
			_file.addEventListener(Event.SELECT, _onFileSelect);
			_file.addEventListener(Event.CANCEL, _onFileCancel);
			_file.browse([new FileFilter('Image file', '*.jpg;*.png;*.gif')]);
		}

		
		private function _onFileSelect(event:Event):void {
			_file.addEventListener(Event.COMPLETE, _onFileComplete);
			_file.load();
		}

		
		private function _onFileCancel(event:Event):void {
			_cleanFileReference();
			dispatchEvent(new Event(Event.CANCEL));
		}

		
		private function _onFileComplete(event:Event):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadComplete);
			loader.loadBytes(_file.data);
		}

		
		private function _onLoadComplete(event:Event):void {
			_image = Bitmap(LoaderInfo(event.target).loader.content).bitmapData;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		private function _cleanFileReference():void {
			_file.removeEventListener(Event.SELECT, _onFileSelect);
			_file.removeEventListener(Event.CANCEL, _onFileCancel);
			_file.removeEventListener(Event.COMPLETE, _onFileComplete);
//			_file = null;
		}
		
		
		public function get image():BitmapData {
			return _image;
		}
		
		
		public function get file():FileReference {
			return _file;
		}
	}
}
