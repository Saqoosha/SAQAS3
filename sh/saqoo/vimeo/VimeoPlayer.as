package sh.saqoo.vimeo {

	import sh.saqoo.util.DisplayObjectUtil;
	import sh.saqoo.util.EnterFrameBeacon;

	import org.osflash.signals.Signal;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * @author Saqoosha
	 * @see https://github.com/vimeo/player-api
	 */
	public class VimeoPlayer extends Sprite {


		private var _width:int;
		private var _height:int;

		private var _loader:Loader;
		private var _moogaloop:Object;
		private var _videoControls:DisplayObject;
		private var _timer:uint;
		
		private var _sigReady:Signal = new Signal();
		private var _sigLoadProgress:Signal = new Signal(Number);
		private var _sigPlayProgress:Signal = new Signal(Number);
		private var _sigFinish:Signal = new Signal();
		
		//
		
		override public function get width():Number { return _width; }
		override public function get height():Number { return _height; }
		
		public function get moogaloop():Object { return _moogaloop; }
		
		public function get sigReady():Signal { return _sigReady; }
		public function get sigLoadProgress():Signal { return _sigLoadProgress; }
		public function get sigPlayProgress():Signal { return _sigPlayProgress; }
		public function get sigFinish():Signal { return _sigFinish; }
		
		//
		
		public function get bytesLoaded():Number { return _moogaloop.bytesLoaded; }
		public function get bytesTotal():Number { return _moogaloop.bytesTotal; }
		public function get loadProgress():Number { return _moogaloop.bytesLoaded / _moogaloop.bytesTotal; }
		public function get currentTime():Number { return _moogaloop.currentTime; }
		public function get duration():Number { return _moogaloop.duration; }
		public function get playProgress():Number { return _moogaloop.currentTime / _moogaloop.duration; }

		public function get color():uint { return _moogaloop.color; }
		public function set color(value:uint):void { _moogaloop.setColor('0x' + value.toString(16)); }
		public function get size():Object { return _moogaloop.size; }

		public function get videoWidth():Number { return _moogaloop.videoWidth; }
		public function get videoHeight():Number { return _moogaloop.videoHeight; }
		public function get videoURL():String { return _moogaloop.videoUrl; }
		public function get videoEmbedCode():String { return _moogaloop.videoEmbedCode; }

		public function get volume():Number { return _moogaloop.volume; }
		public function set volume(value:Number):void { _moogaloop.volume = value; }
		public function get loop():Boolean { return _moogaloop.getLoop(); }
		public function set loop(value:Boolean):void { _moogaloop.setLoop(value); }
		public function get paused():Boolean { return _moogaloop.paused(); }
		
		//
		
		public function VimeoPlayer(clipId:int, width:int, height:int, autoPlay:Boolean = false, oauthKey:String = null) {
			_width = width;
			_height = height;
			
			Security.allowDomain('*');
			Security.loadPolicyFile('http://api.vimeo.com/crossdomain.xml');

			var opts:URLVariables = new URLVariables();
			opts.clip_id = clipId;
			opts.width = width;
			opts.height = height;
			opts.autoplay = int(autoPlay);
			if (oauthKey) opts.oauth_key = oauthKey;
			opts.fp_version = '10';
			opts.api = '1';
			opts.r = Math.random().toString(16);

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoaded);
			_loader.load(new URLRequest('http://api.vimeo.com/moogaloop_api.swf?' + opts));
		}


		public function play():void { _moogaloop.play(); }
		public function pause():void { _moogaloop.pause(); }
		public function seek(seconds:Number):void { _moogaloop.seek(seconds); }
		public function unload():void { _moogaloop.unload(); }
		public function destroy():void {
			if (_moogaloop) {
				_moogaloop.destroy();
			} else {
				_loader.unloadAndStop();
				_cleanupLoader();
			}
		}
		
		public function enableMouseMove():void { _moogaloop.enableMouseMove(); }
		public function disableMouseMove():void { _moogaloop.disableMouseMove(); }
		public function enableKeyboardEvents():void { _moogaloop.enableKeyboardEvents(); }
		public function disableKeyboardEvents():void { _moogaloop.disableKeyboardEvents(); }


		private function _onLoaded(e:Event):void {
			_moogaloop = e.currentTarget.loader.content;
			_cleanupLoader();
			DisplayObjectUtil.inactivate(InteractiveObject(_moogaloop));
			addChild(DisplayObject(_moogaloop));
			EnterFrameBeacon.add(_checkPlayerLoaded);
		}


		private function _checkPlayerLoaded(e:Event):void {
			if (_moogaloop.player_loaded) {
				_videoControls = _moogaloop.getChildByName('videoControlsController');
				_videoControls.visible = false;
				EnterFrameBeacon.remove(_checkPlayerLoaded);
				_sigReady.dispatch();
				_timer = setInterval(_checkProgress, 100);
			}
		}

		
		private var _prevLoaded:Number = 0;
		private var _prevTime:Number = -1;

		private function _checkProgress():void {
			if (_prevLoaded < _moogaloop.bytesLoaded) {
				_prevLoaded = _moogaloop.bytesLoaded;
				_sigLoadProgress.dispatch(loadProgress);
			}
			if (_prevTime < _moogaloop.currentTime) {
				_prevTime = _moogaloop.currentTime;
				_sigPlayProgress.dispatch(_moogaloop.currentTime);
				if (_moogaloop.duration - 0.1 <= _moogaloop.currentTime) {
					_sigFinish.dispatch();
					clearInterval(_timer);
				}
			}
		}
		
		
		private function _cleanupLoader():void {
			if (_loader) {
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoaded);
				_loader = null;
			}
		}
	}
}
