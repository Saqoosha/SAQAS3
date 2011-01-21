package sh.saqoo.util {
	
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	
	public function getBitmapDataByLinkageId(id:String):BitmapData {
		var ret:BitmapData;
		try {
			ret = new (getDefinitionByName(id))(null, null);
		} catch (e:Error) {
			trace('getDefinitionByName: "' + id + '" not found...');
		}
		return ret;
	}
}