package net.saqoosha.progression {
	
	import jp.progression.casts.CastButton;
	import jp.progression.events.CastMouseEvent;
	
	import seguente.SoundManager;

	public class SimpleCastButton extends CastButton {
		
		public function SimpleCastButton(initObject:Object=null) {
			super(initObject);
			this.gotoAndStop(1);
			this.addEventListener(CastMouseEvent.CAST_ROLL_OVER, this._onRollOver);
			this.addEventListener(CastMouseEvent.CAST_ROLL_OUT, this._onRollOut);
			this.addEventListener(CastMouseEvent.CAST_MOUSE_DOWN, this._onMouseDown);
		}
		
		private function _onRollOver(e:CastMouseEvent):void {
			this.gotoAndStop(2);
			SoundManager.play(SoundManager.ROLL_OVER);
		}
		
		private function _onRollOut(e:CastMouseEvent):void {
			this.gotoAndStop(1);
		}
		
		private function _onMouseDown(e:CastMouseEvent):void {
			SoundManager.play(SoundManager.CLICK);
		}
	}
}