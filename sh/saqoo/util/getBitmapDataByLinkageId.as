package sh.saqoo.util {
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * Get BitmapData instance from "from" object specified by id.
	 * @param id Class name
	 * @param from Loader or MovieClip instance which has application domain. If pass the null, class is refered from current application domain.
	 */
	public function getBitmapDataByLinkageId(id:String, from:* = null):BitmapData {
		var ret:BitmapData = null;
		try {
			switch (true) {
				case from is Loader:
					ret = new (from.contentLoaderInfo.applicationDomain.getDefinition(id))(null, null);					break;
				case from is MovieClip:
					ret = new (from.loaderInfo.applicationDomain.getDefinition(id))(null, null);
					break;
				default:
					ret = new (getDefinitionByName(id))(null, null);
			}
		} catch (e:Error) {
			trace('getBitmapDataByLinkageId: "' + id + '" not found...');
		}
		return ret;
	}
}
