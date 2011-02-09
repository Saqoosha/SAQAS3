package sh.saqoo.util {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	
	public function getSpriteByLinkageId(id:String, from:* = null):Sprite {
		var ret:Sprite = null;
		try {
			switch (true) {
				case from is Loader:
					ret = new (from.contentLoaderInfo.applicationDomain.getDefinition(id))();
					break;
				case from is MovieClip:
					ret = new (from.loaderInfo.applicationDomain.getDefinition(id))();
					break;
				default:
					ret = new (getDefinitionByName(id))();
			}
		} catch (e:Error) {
			trace('getSpriteByLinkageId: "' + id + '" not found...');
		}
		return ret;
	}
}
