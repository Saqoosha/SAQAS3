package net.saqoosha.youtube {
	import net.saqoosha.logging.dump;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;

	[Event(name="ready", type="net.saqoosha.youtube.YouTubePlayerEvent")]

	
	/**
	 * @author Saqoosha
	 * @see http://code.google.com/apis/youtube/flash_api_reference.html
	 */
	public class YouTubePlayer extends Sprite {
		
		
		private var _player:*;
		
		
		public function YouTubePlayer(playerUrl:String = 'http://www.youtube.com/apiplayer?version=3') {
			mouseEnabled = false;
			Security.allowDomain('www.youtube.com');
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, _onInit);
			loader.load(new URLRequest(playerUrl));
		}
		
		
		//----- Queing functions -----
		
		public function cueVideoById(videoId:String, startSeconds:Number = 0, suggestedQuality:String = 'default'):void {
			_player.cueVideoById(videoId, startSeconds, suggestedQuality);
		}
		
		public function loadVideoById(videoId:String, startSeconds:Number = 0, suggestedQuality:String = 'default'):void {
			_player.loadVideoById(videoId, startSeconds, suggestedQuality);
		}
		
		public function cueVideoByUrl(mediaContentUrl:String, startSeconds:Number = 0):void {
			_player.cueVideoByUrl(mediaContentUrl, startSeconds);
		}
		
		public function loadVideoByUrl(mediaContentUrl:String, startSeconds:Number = 0):void {
			_player.loadVideoByUrl(mediaContentUrl, startSeconds);
		}
		
		
		//----- Playing a video-----

		public function playVideo():void { _player.playVideo(); }

		public function pauseVideo():void { _player.pauseVideo(); }

		public function stopVideo():void { _player.stopVideo(); }
		
		public function seekTo(seconds:Number, allowSeekAhead:Boolean):void {
			_player.seekTo(seconds, allowSeekAhead);
		}
		
		
		//----- Changing the player volume -----
		
		public function mute():void { _player.mute(); }
		
		public function unMute():void { _player.unMute(); }
		
		public function isMuted():Boolean { return _player.isMuted(); }
		
		public function setVolume(volume:Number):void { _player.setVolume(volume); }
		
		public function getVolume():Number { return _player.getVolume(); }
		
		
		//----- Setting the player size -----
		
		public function setSize(width:Number, height:Number):void { _player.setSize(width, height); }
		
		
		//----- Playback status -----
		
		public function getVideoBytesLoaded():Number { return _player.getVideoBytesLoaded(); }
		
		public function getVideoBytesTotal():Number { return _player.getVideoBytesTotal(); }
		
		public function getVideoStartBytes():Number { return _player.getVideoStartBytes(); }
		
		public function getPlayerState():Number { return _player.getPlayerState(); }
		
		public function getCurrentTime():Number { return _player.getCurrentTime(); }
		
		
		//----- Playback quality -----
		
		public function getPlaybackQuality():String { return _player.getPlaybackQuality(); }
		
		public function setPlaybackQuality(suggestedQuality:String):void { _player.setPlaybackQuality(suggestedQuality); }
		
		public function getAvailableQualityLevels():Array { return _player.getAvailableQualityLevels(); }
		
		
		//----- Retrieving video information -----
		
		public function getDuration():Number { return _player.getDuration(); }
		
		public function getVideoUrl():String { return _player.getVideoUrl(); }
		
		public function getVideoEmbedCode():String { return _player.getVideoEmbedCode(); }
		
		
		//----- Special Functions -----
		
		public function destroy():void { _player.destroy(); }
		
		
		//-----
		
		private function _onInit(event:Event):void {
			var loader:Loader = LoaderInfo(event.target).loader;
			_player = loader.content;
			_player.addEventListener(YouTubePlayerEvent.READY, _dispatchEvent);
			_player.addEventListener(YouTubePlayerEvent.STATE_CHANGE, _dispatchEvent);
			_player.addEventListener(YouTubePlayerEvent.PLAYBACK_QUALITY_CHANGE, _dispatchEvent);
			_player.addEventListener(YouTubePlayerEvent.ERROR, _dispatchEvent);
			addChild(_player);
		}

		
		private function _dispatchEvent(event:Event):void {
			dump(event, event['data']);
			if (hasEventListener(event.type)) {
				var ev:YouTubePlayerEvent = new YouTubePlayerEvent(event.type, event.bubbles, event.cancelable);
				switch (event.type) {
					case YouTubePlayerEvent.STATE_CHANGE: 
						ev.state = event['data'];
						break;
					case YouTubePlayerEvent.PLAYBACK_QUALITY_CHANGE:
						ev.quality = event['data'];
						break;
					case YouTubePlayerEvent.ERROR:
						ev.errorCode = event['data'];
						break;
				}
				dispatchEvent(ev);
			}
		}
	}
}
