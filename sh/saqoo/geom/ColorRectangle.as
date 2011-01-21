package sh.saqoo.geom {
	
	import flash.display.Shape;

	public class ColorRectangle extends Shape {
		
		public function ColorRectangle(color:int, x:Number = 0.0, y:Number = 0.0, width:Number = 1000, height:Number = 1000) {
			this.graphics.beginFill(color & 0xffffff, ((color >> 24) & 0xff) / 0xff);
			this.graphics.drawRect(x, y, width, height);
			this.graphics.endFill();
		}
		
	}
	
}