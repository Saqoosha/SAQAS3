package net.saqoosha.event {
	
	import flash.events.Event;

	dynamic public class DynamicEvent extends Event {
		
		public function DynamicEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}