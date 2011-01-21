package sh.saqoo.util {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	
	public class FileUtil {
		
		
		public static function readFile(file:File):String {
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			return str;
		}
	}
}
