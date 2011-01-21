package sh.saqoo.as3mod {
	
	import flash.geom.Point;
	import com.as3dmod.IModifier;
	import com.as3dmod.core.MeshProxy;
	import com.as3dmod.core.Modifier;
	import com.as3dmod.core.VertexProxy;

	public class Expo extends Modifier implements IModifier {
		
		private var _center:Point;
		private var _height:Number;
		
		public function Expo() {
			_center = new Point();
			_height = 0;
		}
		
		public override function setModifiable(mod : MeshProxy) : void {
			super.setModifiable(mod);
		}
		
		public function apply() : void {
			var vs:Array = mod.getVertices();
			var vc:int = vs.length;
			var v:VertexProxy;
			var dx:Number, dy:Number;
			var d:Number;
			var maxd:Number = Number.MIN_VALUE;
			for (var i:int = 0; i < vc; i++) {
				v = vs[i] as VertexProxy;
				dx = (v.x - _center.x);
				dy = (v.y - _center.y);
				v.z = dx * dx + dy * dy;
				d = v.z - v.originalZ;
				if (d > maxd) {
					maxd = d;
				}
			}
			var s:Number = _height / maxd;
			for each (v in vs) {
				v.z = _height - (v.originalZ + (v.z - v.originalZ) * s);
			}
		}
		
		public function get center():Point {
			return _center;
		}
		
		public function set center(value:Point):void {
			_center = value;
		}

		public function get height():Number {
			return _height;
		}
		
		public function set height(value:Number):void {
			_height = value;
		}
	}
}
