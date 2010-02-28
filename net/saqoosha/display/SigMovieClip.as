package net.saqoosha.display {
	import org.osflash.signals.natives.NativeRelaySignal;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	
	/**
	 * @author Saqoosha
	 */
	public class SigMovieClip extends MovieClip {

		
		private var _sigAddedToStage:NativeRelaySignal;
		private var _sigRemovedFromStage:NativeRelaySignal;
		private var _sigEnterFrame:NativeRelaySignal;
		
		private var _sigClick:NativeRelaySignal;
		private var _sigMouseDown:NativeRelaySignal;
		private var _sigMouseUp:NativeRelaySignal;
		private var _sigMouseOver:NativeRelaySignal;
		private var _sigMouseOut:NativeRelaySignal;
		private var _sigMouseMove:NativeRelaySignal;
		private var _sigMouseWheel:NativeRelaySignal;
		private var _sigRollOver:NativeRelaySignal;
		private var _sigRollOut:NativeRelaySignal;

		
		public function SigMovieClip() {
		}
		
		
		public function removeAllSignal():void {
			if (_sigAddedToStage) _sigAddedToStage.removeAll();
			if (_sigRemovedFromStage) _sigRemovedFromStage.removeAll();
			if (_sigEnterFrame) _sigEnterFrame.removeAll();
			if (_sigClick) _sigClick.removeAll();
			if (_sigMouseDown) _sigMouseDown.removeAll();
			if (_sigMouseUp) _sigMouseUp.removeAll();
			if (_sigMouseOver) _sigMouseOver.removeAll();
			if (_sigMouseOut) _sigMouseOut.removeAll();
			if (_sigMouseMove) _sigMouseMove.removeAll();
			if (_sigMouseWheel) _sigMouseWheel.removeAll();
			if (_sigRollOver) _sigRollOver.removeAll();
			if (_sigRollOut) _sigRollOut.removeAll();
		}

		
		public function get sigAddedToStage():NativeRelaySignal {
			return _sigAddedToStage ||= new NativeRelaySignal(this, Event.ADDED_TO_STAGE);
		}
		
		
		public function get sigRemovedFromStage():NativeRelaySignal {
			return _sigRemovedFromStage ||= new NativeRelaySignal(this, Event.REMOVED_FROM_STAGE);
		}

		
		public function get sigEnterFrame():NativeRelaySignal {
			return _sigEnterFrame ||= new NativeRelaySignal(this, Event.ENTER_FRAME);
		}
		
		
		public function get sigClick():NativeRelaySignal {
			return _sigClick ||= new NativeRelaySignal(this, MouseEvent.CLICK, MouseEvent);
		}
		
		
		public function get sigMouseDown():NativeRelaySignal {
			return _sigMouseDown ||= new NativeRelaySignal(this, MouseEvent.MOUSE_DOWN, MouseEvent);
		}
		
		
		public function get sigMouseUp():NativeRelaySignal {
			return _sigMouseUp ||= new NativeRelaySignal(this, MouseEvent.MOUSE_UP, MouseEvent);
		}

		
		public function get sigMouseOver():NativeRelaySignal {
			return _sigMouseOver ||= new NativeRelaySignal(this, MouseEvent.MOUSE_OVER, MouseEvent);
		}
		
		
		public function get sigMouseOut():NativeRelaySignal {
			return _sigMouseOut ||= new NativeRelaySignal(this, MouseEvent.MOUSE_OUT, MouseEvent);
		}
		
		
		public function get sigMouseMove():NativeRelaySignal {
			return _sigMouseMove ||= new NativeRelaySignal(this, MouseEvent.MOUSE_MOVE, MouseEvent);
		}

		
		public function get sigMouseWheel():NativeRelaySignal {
			return _sigMouseWheel ||= new NativeRelaySignal(this, MouseEvent.MOUSE_WHEEL, MouseEvent);
		}
		
		
		public function get sigRollOver():NativeRelaySignal {
			return _sigRollOver ||= new NativeRelaySignal(this, MouseEvent.ROLL_OVER, MouseEvent);
		}
		
		
		public function get sigRollOut():NativeRelaySignal {
			return _sigRollOut ||= new NativeRelaySignal(this, MouseEvent.ROLL_OUT, MouseEvent);
		}
	}
}
