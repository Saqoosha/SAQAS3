package net.saqoosha.progression {
	
	import flash.events.Event;
	
	import jp.progression.casts.CastButton;

	public class CenteringCastButton extends CastButton {
		
		public function CenteringCastButton(initObject:Object=null) {
			super(initObject);
			this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this._onRemovedFromStage);
		}
		
		private function _onAddedToStage(e:Event):void {
			this.stage.addEventListener(Event.RESIZE, this._onStageResized);
			this._onStageResized(null);
		}
		
		private function _onRemovedFromStage(e:Event):void {
			this.stage.removeEventListener(Event.RESIZE, this._onStageResized);
		}
	
		protected function _onStageResized(e:Event):void {
			this.x = this.stage.stageWidth >> 1;
			this.y = this.stage.stageHeight >> 1;
		}
	}
}