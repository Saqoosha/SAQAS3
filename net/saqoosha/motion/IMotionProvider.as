package net.saqoosha.motion {
	
	public interface IMotionProvider {
		
		virtual function start(now:Number = 0):void;
		
		virtual function get time():Number;
		virtual function set time(t:Number):void;
		
		virtual function get syncStart():Boolean;
		virtual function set syncStart(val:Boolean):void;
		
		virtual function get x():Number;
		virtual function get y():Number;
		
	}
	
}