package sh.saqoo.util {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * Get MovieClip instance from "from" object specified by id.
	 * @param id Class name
	 * @param from Loader or MovieClip instance which has application domain. If pass the null, class is refered from current application domain.
	 */
	public function getMovieClipByLinkageId(id:String, from:* = null):MovieClip {
		var ret:MovieClip = null;
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
			trace('getMovieClipByLinkageId: "' + id + '" not found...');
		}
		return ret;
	}
}
