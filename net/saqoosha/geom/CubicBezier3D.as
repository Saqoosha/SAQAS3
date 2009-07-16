package net.saqoosha.geom {
	
	public class CubicBezier3D {
		
		private var _p0:Point3D;
		private var _p1:Point3D;
		private var _p2:Point3D;
		private var _p3:Point3D;
		
		public function CubicBezier3D(start:Point3D = null, control1:Point3D = null, control2:Point3D = null, end:Point3D = null) {
			this.start = start || new Point3D();
			this.control1 = control1 || new Point3D();
			this.control2 = control2 || new Point3D();
			this.end = end || new Point3D();;
		}
		
		public function getPointAt(t:Number, p:Point3D = null):Point3D {
			var t2:Number = t * t;
			var t3:Number = t2 * t;
			var g:Number;
			var b:Number;
			var a:Number;
			var ret:Point3D = p || new Point3D();
			// x
			g = 3 * (this._p1.x - this._p0.x);
			b = 3 * (this._p2.x - this._p1.x) - g;
			a = this._p3.x - this._p0.x - g - b;
			ret.x = a * t3 + b * t2 + g * t + this._p0.x;
			// y
			g = 3 * (this._p1.y - this._p0.y);
			b = 3 * (this._p2.y - this._p1.y) - g;
			a = this._p3.y - this._p0.y - g - b;
			ret.y = a * t3 + b * t2 + g * t + this._p0.y;
			// z
			g = 3 * (this._p1.z - this._p0.z);
			b = 3 * (this._p2.z - this._p1.z) - g;
			a = this._p3.z - this._p0.z - g - b;
			ret.z = a * t3 + b * t2 + g * t + this._p0.z;
			return ret;
		}
		
		public function destroy():void {
			this._p0 = null;
			this._p1 = null;
			this._p2 = null;
			this._p3 = null;
		}
		
		//
		public function get p0():Point3D {
			return this._p0;
		}
		public function set p0(value:Point3D):void {
			this._p0 = value;
		}
		public function get start():Point3D {
			return this._p0;
		}
		public function set start(value:Point3D):void {
			this._p0 = value;
		}
		
		//
		public function get p1():Point3D {
			return this._p1;
		}
		public function set p1(value:Point3D):void {
			this._p1 = value;
		}
		public function get control1():Point3D {
			return this._p1;
		}
		public function set control1(value:Point3D):void {
			this._p1 = value;
		}
		
		//
		public function get p2():Point3D {
			return this._p2;
		}
		public function set p2(value:Point3D):void {
			this._p2 = value;
		}
		public function get control2():Point3D {
			return this._p2;
		}
		public function set control2(value:Point3D):void {
			this._p2 = value;
		}
		
		//
		public function get p3():Point3D {
			return this._p3;
		}
		public function set p3(value:Point3D):void {
			this._p3 = value;
		}
		public function get end():Point3D {
			return this._p3;
		}
		public function set end(value:Point3D):void {
			this._p3 = value;
		}
		
		//
		public function toString():String {
			return '[CubicBezier3D \n' +
						'\t' + this._p0 + ',\n' + 
						'\t' + this._p1 + ',\n' + 
						'\t' + this._p2 + ',\n' + 
						'\t' + this._p3 + '\n' + 
					']';
		}
	}
}