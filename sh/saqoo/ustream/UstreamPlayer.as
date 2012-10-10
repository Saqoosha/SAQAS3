package sh.saqoo.ustream {

	import sh.saqoo.logging.dump;

	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;


	/**
	 * @author Saqoosha
	 */
	public class UstreamPlayer extends Sprite {


		private var _controlConnection:NetConnection;
		private var _player:Player;
		private var _videoWidth:int;
		private var _videoHeight:int;
		
		
		public function UstreamPlayer(channel:String, videoWidth:Number = 640, videoHeight:Number = 480) {
			_controlConnection = new NetConnection();
			_controlConnection.objectEncoding = ObjectEncoding.AMF0;
			_controlConnection.client = this;
			_controlConnection.addEventListener(NetStatusEvent.NET_STATUS, _onControlStatus);
			_controlConnection.connect('rtmp://74.217.100.132/ustream', {media: channel, application: 'channel'});
			_videoWidth = videoWidth;
			_videoHeight = videoHeight;
		}


		private function _onControlStatus(event:NetStatusEvent):void {
			trace('CONTROL NET STATUS ---');
			dump(event.info);
		}


		public function moduleInfo(info:Object):void {
			trace('CONTROL MODULE INFO ---');
			dump(info);
			if (info.hasOwnProperty('stream')) {
				if (info.stream === 'offline') {
					trace('OFFLINE');
				} else {
					var streamInfo:Object = info.stream[0];
					if (info.stream.length > 1) {
						var found:Boolean = false;
						for each (var s:Object in info.stream) {
							if (s.name === 'ustream' || s.name === 'level3') {
								streamInfo = s;
								found = true;
								break;
							}
						}
						if (!found) {
							streamInfo = info.stream[info.stream.length - 1];
						}
					}
					if (_player && _player.equals(streamInfo)) {
						streamInfo = null;
					}
					trace('SELECTED STREAM ---');
					dump(streamInfo);
					if (streamInfo) {
						if (_player) {
							_player.close();
							_player.parent.removeChild(_player);
						}
						_player = new Player(streamInfo, _videoWidth, _videoHeight);
						_player.smoothing = true;
						addChild(_player);
					}
				}
			}
		}
		
		
		public function setSize(width:int, height:int):void {
			_player.width = _videoWidth = width;
			_player.height = _videoHeight = height;
		}
		
		
		public function destroy():void {
			if (_player) {
				_player.close();
				_player.parent.removeChild(_player);
				_player = null;
			}
			_controlConnection.client = {};
			_controlConnection.removeEventListener(NetStatusEvent.NET_STATUS, _onControlStatus);
			_controlConnection.close();
			_controlConnection = null;
		}
	}
}


import sh.saqoo.logging.dump;

import flash.events.NetStatusEvent;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.net.Responder;


class Player extends Video {
	
	
	private static const DEFAULT_STREAM_NAME:String = 'streams/live';


	private var _info:Object;
	private var _connection:NetConnection;
	private var _stream:NetStream;
	
	
	public function Player(info:Object, videoWidth:int, videoHeight:int) {
		super(videoWidth, videoHeight);
		_info = info;
		_connection = new NetConnection();
		_connection.client = this;
		_connection.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
		_connection.connect(fmsUrl);
	}
	
	
	public function get fmsUrl():String {
		return _info.url;
	}
	
	public function get streamName():String {
		if (_info.hasOwnProperty('streamName')) {
			return _info.streamName;
		} else if (_info.hasOwnProperty('streams')) {
			return _info.streams[0].streamName;
		} else {
			return DEFAULT_STREAM_NAME;
		}
	}
	
	
	public function moduleInit(...args):void {
		trace('STREAM MODULE INIT ---');
		dump(args);
	}
	
	public function moduleInfo(...args):void {
		trace('STREAM MODULE INFO ---');
		dump(args);
	}
	
	public function onMetaData(...args):void {
		trace('STREAM onMetaData ---');
		dump(args);
	}
	
	public function onBWDone(...args):void {
		trace('STREAM onBWDone ---');
		dump(args);
		if (_info['needSubscribe']) {
			_connection.call('FCSubscrive', new Responder(dump, dump), streamName);
		}
	}
	
	public function onFCSubscribe(...args):void {
		trace('STREAM onFCSubscribe ---');
		dump(args);
	}
	
	public function logicOff(...args):void {
		trace('STREAM LOGIC OFF ---');
		dump(args);
	}
	
	public function cdnOn(...args):void {
		trace('STREAM CDN ON ---');
		dump(args);
	}
	
	public function ping(...args):void {
		trace('STREAM PONG --- ');
		dump(args);
		_connection.call('pong', new Responder(dump, dump));
	}
	
	public function goOffline(...args):void {
		trace('STREAM GO OFFLINE ---');
		dump(args);
		close();
	}
	
	
	public function close():void {
		if (_stream) {
			attachNetStream(null);
			clear();
			_stream.removeEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			_stream.client = {};
			_stream = null;
		}
		if (_connection) {
			_connection.removeEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			_connection.client = {};
			_connection.close();
			_connection = null;
		}
	}


	private function _onNetStatus(event:NetStatusEvent):void {
		trace('STREAM NET STATUS ---');
		dump(event.info);
		switch (event.info.code) {
			case 'NetConnection.Connect.Success':
				_stream = new NetStream(_connection);
				_stream.client = this;
				_stream.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
				_stream.play(streamName);
				attachNetStream(_stream);
				break;
		}
	}
	
	
	public function equals(info:Object):Boolean {
		var nextStreamName:String = DEFAULT_STREAM_NAME;
		if (info.hasOwnProperty('streamName')) {
			nextStreamName = info.streamName;
		} else if (_info.hasOwnProperty('streams')) {
			nextStreamName = info.streams[0].streamName;
		}
		dump(fmsUrl, info.url, streamName, nextStreamName);
		return fmsUrl === info.url && streamName === nextStreamName;
	}
}
