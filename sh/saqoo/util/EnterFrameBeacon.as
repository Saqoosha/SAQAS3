package sh.saqoo.util {
	import sh.saqoo.display.SigSprite;

	
	/**
	 * @author Saqoosha
	 */
	public class EnterFrameBeacon {
		
		
		private static const _instance:EnterFrameBeacon = new EnterFrameBeacon();
		
		
		public var beacon:SigSprite;

		
		public function EnterFrameBeacon():void {
			if (_instance) throw new Error('EnterFrameBeacon is singleton.');
			beacon = new SigSprite();
		}
		
		
		public static function add(listener:Function, priority:int = 0):void {
			_instance.beacon.sigEnterFrame.addWithPriority(listener, priority);
		}
		
		
		public static function addOnce(listener:Function, priority:int = 0):void {
			_instance.beacon.sigEnterFrame.addOnceWithPriority(listener, priority);
		}
		
		
		public static function remove(listener:Function):void {
			_instance.beacon.sigEnterFrame.remove(listener);
		}
	}
}
