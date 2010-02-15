package net.saqoosha.net {
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	/**
	 * @author Saqoosha
	 */
	public function navigateToURL(url:String, target:String = '_blank'):void {
		flash.net.navigateToURL(new URLRequest(url), target);
	}
}
