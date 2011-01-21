package sh.saqoo.net {
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import jp.progression.commands.net.IProgress;

	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.ProgressEvent", name="progress")]

	public class AssetLoader extends EventDispatcher {
		
		private var _loader:Loader;
		private var _loaded:Boolean = false;
		
		public function AssetLoader(request:URLRequest = null) {
			if (request) {
				load(request);
			}
		}
		
		public function load(request:URLRequest):void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			_loader.load(request);
		}
		
		public function unload():void {
			_loader.unload();
			_loader = null;
		}
		
		public function getBitmapData(id:String):BitmapData {
			var ret:BitmapData = null;
			try {
				ret = new (getDefinitionByName(id))(null, null);
			} catch (e:Error) {
				trace('getBitmapData: "' + id + '" not found in ' + url);
			}
			return ret;
		}
		
		public function getSound(id:String):Sound {
			var ret:Sound = null;
			try {
				ret = new (getDefinitionByName(id))();
			} catch (e:Error) {
				trace('getSound: "' + id + '" not found in ' + url);
			}
			return ret;
		}
		
		private function getDefinitionByName(name:String):Class {
			return _loader.contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
		}
		
		
		
		private function _onLoadComplete(e:Event):void {
			_loaded = true;
			dispatchEvent(e);
		}
		
		
		
		
		public function get url():String {
			return _loader ? _loader.contentLoaderInfo.url : '';
		}
		
		public function get bytesLoaded():uint {
			return _loader.contentLoaderInfo.bytesLoaded;
		}
		
		public function get bytesTotal():uint {
			return _loader.contentLoaderInfo.bytesTotal;
		}
		
//		public function get percent():Number {
//			return bytesLoaded / bytesTotal;
//		}
//		
//		public function get target():IProgress {
//			return this;
//		}
//		
//		public function get total():uint {
//			return 1;
//		}
//		
//		public function get loaded():uint {
//			return _loaded ? 1 : 0;
//		}
//
//		public function get data():* {
//			return this;
//		}
//		public function set data(value:*):void {
//		}
//		
//		private var _factor:Number = 1;
//		public function get factor():Number {
//			return _factor;
//		}
//		public function set factor(value:Number):void {
//			_factor = value;
//		}
	}
}