package sh.saqoo.util {

	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;
	
	[Event(name="noCamera", type="flash.events.Event")]
	[Event(name="detected", type="flash.events.Event")]
	[Event(name="timeout", type="flash.events.Event")]
	[Event(name="allowed", type="flash.events.Event")]
	[Event(name="denied", type="flash.events.Event")]

	/**
	 * @author Saqoosha
	 */
	public class ActiveCameraDetector extends EventDispatcher {
		
		
		public static const NO_CAMERA:String = 'noCamera';	// couldn't find any camera.
		public static const DETECTED:String = 'detected';	// found active camera.
		public static const TIMEOUT:String = 'timeout';		// couldn't detect any activity in specified seconds.
		public static const ALLOWED:String = 'allowed';		// user clicked "Allow" button on the security panel.
		public static const DENIED:String = 'denied';		// user clicked "Deny" button on the security panel.

		public static const ALL_EVENTS:Array = [NO_CAMERA, DETECTED, TIMEOUT, ALLOWED, DENIED];
		public static const MAC_DVCPRO:Array = ['DVCPRO HD (1080i50)', 'DVCPRO HD (1080i60)', 'DVCPRO HD (720p60)'];

		private static const TEST_CAMERA_WIDTH:int = 80;
		private static const TEST_CAMERA_HEIGHT:int = 60;
		private static const TEST_MOTION_LEVEL:int = 1;

		//

		private var _timer:Timer;
		private var _cameras:Array;
		private var _videos:Array;
		private var _detectedIndex:int = -1;
		private var _detectedName:String = null;
		
		public function get detected():Boolean { return _detectedIndex != -1; }
		public function get detectedCameraIndex():int { return _detectedIndex; }
		public function get detectedCameraName():String { return _detectedName; }
		public function get activeCamera():Camera { return Camera.getCamera(_detectedIndex.toString()); }


		public function ActiveCameraDetector():void {
		}


		public function start(timeout:int = 0, excludeCameraNames:Array = null):void {
			var n:int = Camera.names.length;
			if (n == 0) {
				dispatchEvent(new Event(NO_CAMERA));
				return;
			}
			_cameras = [];
			_videos = [];
			for (var i:int = 0; i < n; ++i) {
				var cam:Camera = Camera.getCamera(i.toString());
				var ignored:Boolean = excludeCameraNames && excludeCameraNames.indexOf(cam.name) != -1;
				trace(cam.index, '"' + cam.name + '"', (ignored ? 'ignored' : ''));
				cam.setMode(TEST_CAMERA_WIDTH, TEST_CAMERA_HEIGHT, 10);
				cam.setMotionLevel(TEST_MOTION_LEVEL, 10000);
				cam.addEventListener(ActivityEvent.ACTIVITY, _onActivity);
				_cameras.push(cam);
				var vid:Video = new Video(TEST_CAMERA_WIDTH, TEST_CAMERA_HEIGHT);
				vid.attachCamera(cam);
				_videos.push(vid);
			}
			Camera(_cameras[0]).addEventListener(StatusEvent.STATUS, _onStatus);
			if (timeout) {
				_timer = new Timer(timeout * 1000, 1);
				_timer.addEventListener(TimerEvent.TIMER, _onTimeout);
				_timer.start();
			}
			_detectedIndex = -1;
			_detectedName = null;
		}


		public function stop():void {
			if (_videos) {
				var n:int = _videos.length;
				for (var i:int = 0; i < n; ++i) {
					Video(_videos[i]).attachCamera(null);
					Camera(_cameras[i]).removeEventListener(ActivityEvent.ACTIVITY, _onActivity);
				}
				Camera(_cameras[0]).removeEventListener(StatusEvent.STATUS, _onStatus);
				_videos = null;
				_cameras = null;
				if (_timer) {
					_timer.stop();
					_timer = null;
				}
			}
		}


		private function _onStatus(e:StatusEvent):void {
			trace(e);
			switch (e.code) {
				case 'Camera.Unmuted':
					dispatchEvent(new Event(ALLOWED));
					break;
				case 'Camera.Muted':
					stop();
					dispatchEvent(new Event(DENIED));
					break;
			}
		}


		private function _onActivity(e:ActivityEvent):void {
			trace(e, Camera(e.target).name);
			if (e.activating) {
				_detectedName = Camera(e.target).name;
				_detectedIndex = Camera(e.target).index;
				stop();
				dispatchEvent(new Event(DETECTED));
			}
		}


		private function _onTimeout(e:TimerEvent):void {
			stop();
			dispatchEvent(new Event(TIMEOUT));
		}
	}
}
