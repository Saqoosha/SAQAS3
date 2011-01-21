package sh.saqoo.motion {
	
	public class ManualMotionProvider implements IMotionProvider {
		
		public var ox:Number;
		public var oy:Number;
		
		public function ManualMotionProvider(ix:Number, iy:Number) {
			this.ox = ix;
			this.oy = iy;
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
			return this.ox;
		}
		
		public function get y():Number {
			return this.oy;
		}
		
	}
	
}