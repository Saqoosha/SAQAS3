package net.saqoosha.thread {
	
	import flash.utils.getTimer;
	
	import org.libspark.betweenas3.tweens.ITween;
	import org.libspark.thread.IMonitor;
	import org.libspark.thread.Monitor;
	import org.libspark.thread.Thread;

	public class BetweenAS3Thread extends Thread {
		
		private var _tween:ITween;
		private var _monitor:IMonitor;
		
		public function BetweenAS3Thread(target:ITween) {
			_tween = target;
			_monitor = new Monitor();
		}
		
		public function cancel():void {
			interrupt();
		}
		
		override protected function run():void {
			_monitor.wait();
			interrupted(interruptedHandler);
			_tween.onComplete = _monitor.notifyAll;
			_tween.play();
		}
		
		private function interruptedHandler():void {
			trace('interruptedHandler', _tween.isPlaying);
			if (_tween.isPlaying) {
				_tween.stop();
			}
		}
	}
}