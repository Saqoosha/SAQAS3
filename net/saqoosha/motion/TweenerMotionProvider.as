package net.saqoosha.motion {
	
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	
	public class TweenerMotionProvider implements IMotionProvider {
		
		private var _dummy:Sprite;
		private var _running:Boolean;
		
		public function TweenerMotionProvider() {
			super();
			this._running = false;
		}
		
		public function addTween(opt:Object):void {
			Tweener.addTween(this, opt);
		}

		public function get currnet():Number {
			return 0;
		}
		
	}
	
}