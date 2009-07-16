package net.saqoosha.util {
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public function getMovieClipByLinkageId(id:String):MovieClip {
		return new (getDefinitionByName(id))();
	}
	
}