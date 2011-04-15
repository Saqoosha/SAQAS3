package sh.saqoo.progression {

	import flash.events.Event;

	import jp.progression.casts.CastButton;


	public class CenteringCastButton extends CastButton {


		public function CenteringCastButton(initObject:Object = null) {
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
