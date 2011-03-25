package sh.saqoo.geom {
	
	/**
	 * @author Saqoosha
	 */
	public class SVGUtil {


		public static function buildSVGRootNode(id:String = null, width:Number = 1024, height:Number = 1024):XML {
			var svg:XML = <svg/>;
			svg.setNamespace('http://www.w3.org/2000/svg');
			svg.@version = '1.1';
			if (id is String) svg.@id = id.replace('\s', '_');
			svg.@x = '0px';
			svg.@y = '0px';
			svg.@width = width + 'px';
			svg.@height = height + 'px';
			svg.@viewBox = '0 0 ' + width + ' ' + height;
			svg.attribute('enable-background').nodeValue = 'new 0 0 ' + width + ' ' + height;
			return svg;
		}
	}
}
