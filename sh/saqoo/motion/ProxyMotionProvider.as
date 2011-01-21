package sh.saqoo.motion {
	
	public class ProxyMotionProvider implements IMotionProvider {
		
		public function ProxyMotionProvider() {
		}

		public function start(now:Number=0):void {
		}
		
		public function get time():Number {
			return 0;
		}
		
		public function set time(t:Number):void {
		}
		
		public function get syncStart():Boolean {
			return false;
		}
		
		public function set syncStart(val:Boolean):void {
		}
		
		public function get x():Number {
			return 0;
		}
		
		public function get y():Number {
			return 0;
		}
		
	}
	
}