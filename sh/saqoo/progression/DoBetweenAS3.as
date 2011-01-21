package sh.saqoo.progression {
	import jp.progression.commands.Func;

	import org.libspark.betweenas3.tweens.ITween;

	import flash.events.Event;

	
	public class DoBetweenAS3 extends Func {
		public function DoBetweenAS3(tween:ITween, initObject:Object = null) {
			tween.onComplete = _onCompleteTween;
			super(tween.play, null, this, Event.COMPLETE);
		}
		
		private function _onCompleteTween():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
