package sh.saqoo.format.fbx {


	/**
	 * @author Saqoosha
	 */
	public dynamic class FBXNode {

		
		public var type:String = null;
		public var name:String = null;
		public var value:* = null;
		
		
		public function FBXNode(type:String = null) {
			this.type = type;
		}
		
		
		public function toString():String {
			return '[FBXNode type="' + type + '" name="' + name + '" value=' + value + ']';
		}
	}
}
