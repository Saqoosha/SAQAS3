package sh.saqoo.util {

	import flash.display.Bitmap;
	import flash.display.PixelSnapping;

	/**
	 * @author Saqoosha
	 */
	public function getBitmapByClassName(className:String, smoothing:Boolean = false):Bitmap {
		return new Bitmap(getBitmapDataByClassName(className), PixelSnapping.AUTO, smoothing);
	}
}
