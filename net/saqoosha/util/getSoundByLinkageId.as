package net.saqoosha.util {
	
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	
	public function getSoundByLinkageId(id:String):Sound {
		var ret:Sound = null;
		try {
			ret = new (getDefinitionByName(id))();
		} catch (e:Error) {
			trace('getDefinitionByName: ' + id + ' not found...');
		}
		return ret;
	}
}