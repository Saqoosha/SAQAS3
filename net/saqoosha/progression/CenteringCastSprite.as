package net.saqoosha.progression {
	import jp.progression.casts.CastSprite;

	import flash.events.Event;

	
	public class CenteringCastSprite extends CastSprite {
		
		public function CenteringCastSprite(initObject:Object = null) {
			super(initObject);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
		}
		
		private function _onAddedToStage(e:Event):void {
			stage.addEventListener(Event.RESIZE, _onStageResized);
			_onStageResized();
		}
		
		private function _onRemovedFromStage(e:Event):void {
			stage.removeEventListener(Event.RESIZE, _onStageResized);
		}
	
		protected function _onStageResized(e:Event = null):void {
			x = stage.stageWidth >> 1;
			y = stage.stageHeight >> 1;
		}
	}
}
