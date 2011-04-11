package sh.saqoo.progression {

	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;

	import com.flashdynamix.motion.Tweensy;
	import com.flashdynamix.motion.TweensyTimeline;

	/**
	 * @author Saqoosha
	 */
	public class DoTweensy extends Command {


		public static function to(instance:Object, to:Object, duration:Number = 0.5, ease:Function = null, delayStart:Number = 0, update:Object = null):DoTweensy {
			return new DoTweensy(Tweensy.to, [instance, to, duration, ease, delayStart, update]);
		}


		public static function from(instance:Object, from:Object, duration:Number = 0.5, ease:Function = null, delayStart:Number = 0, update:Object = null):DoTweensy {
			return new DoTweensy(Tweensy.from, [instance, from, duration, ease, delayStart, update]);
		}


		public static function fromTo(instance:Object, from:Object, to:Object, duration:Number = 0.5, ease:Function = null, delayStart:Number = 0, update:Object = null):DoTweensy {
			return new DoTweensy(Tweensy.fromTo, [instance, from, to, duration, ease, delayStart, update]);
		}


		//


		private var _tweensyFunc:Function;
		private var _args:Array;
		private var _timeline:TweensyTimeline;


		public function DoTweensy(tweensyFunc:Function, args:Array) {
			super(_executeFunction, _interruptFunction);
			_tweensyFunc = tweensyFunc;
			_args = args;
		}


		private function _executeFunction():void {
			_timeline = _tweensyFunc.apply(null, _args);
			_timeline.onComplete = _onComplete;
		}


		private function _onComplete():void {
			super.executeComplete();
		}


		private function _interruptFunction():void {
			_timeline.stopAll();
		}


		override public function clone():Command {
			return new DoTweensy(_tweensyFunc, _args.slice());
			;
		}


		override public function toString():String {
			return ObjectUtil.formatToString(this, super.className, super.id ? "id" : null, "time");
		}
	}
}
