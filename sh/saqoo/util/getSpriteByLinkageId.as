package sh.saqoo.util {
	
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	public function getSpriteByLinkageId(id:String):Sprite {
		var ret:Sprite;
		try {
			ret = new (getDefinitionByName(id))();
		} catch (e:Error) {
			trace('getDefinitionByName: "' + id + '" not found...');
		}
		return ret;
	}
}