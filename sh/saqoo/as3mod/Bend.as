/**
 * This version cannot change the mod axis.
 */
package sh.saqoo.as3mod {
	
	import com.as3dmod.IModifier;
	import com.as3dmod.core.MeshProxy;
	import com.as3dmod.core.Modifier;
	import com.as3dmod.core.VertexProxy;
	import com.as3dmod.util.ModConstant;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Bend extends Modifier implements IModifier {
		
		protected var _min:Number;
		protected var _height:Number;
		
		protected var _force:Number = 0;
		protected var _angle:Number = 0;
		
		private var _m1:Matrix;
		private var _m2:Matrix;
		
		public function Bend() {
		}

		override public function setModifiable(mod:MeshProxy):void {
			super.setModifiable(mod);
			_min = mod.getMin(ModConstant.Y);
			angle = 0;
		}

		public function set force(f:Number):void { _force = f; }		
		public function get force():Number { return _force; }

		public function get angle():Number { return _angle; }
		public function set angle(a:Number):void { 
			_angle = a; 
			_m1 = new Matrix();
			_m1.rotate(_angle);
			_m2 = new Matrix();
			_m2.rotate(-_angle);
		}

		private var _tp:Point = new Point();
		public function apply():void {
			if (_force == 0) {
				return;
			}
			
			var vs:Array = mod.getVertices();
			var vc:int = vs.length;
			
			var radius:Number = mod.height / Math.PI / _force;
			var bendRad:Number = Math.PI * 2 * (mod.height / (radius * Math.PI * 2));
			
			for (var i:int = 0; i < vc; i++) {
				var v:VertexProxy = vs[i] as VertexProxy;
				
				var p:Number = (v.y - _min) / mod.height;
				_tp.x = v.x;
				_tp.y = v.z;
				_tp = _m1.transformPoint(_tp);
				
				var fa:Number = (Math.PI / 2) + (bendRad * p);
				var op:Number = Math.sin(fa) * (radius + _tp.x);
				var ow:Number = Math.cos(fa) * (radius + _tp.x);

				_tp.x = op - radius;
				
				_tp = _m2.transformPoint(_tp);
				
				v.x = _tp.x;
				v.y = _min - ow;
				v.z = _tp.y;
			}
		}
	}
}
