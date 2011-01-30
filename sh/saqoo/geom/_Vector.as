package sh.saqoo.geom {
	
	import flash.geom.Point;
	
	public class _Vector {
		
		public var x:Number;
		public var y:Number;
	
		public function _Vector(px:Number = 0, py:Number = 0) {
			x = px;
			y = py;
		}
		
//		public function setTo(px:Number, py:Number):void {
//			x = px;
//			y = py;
//		}
		
		public function clone():Vector {
			return new Vector(this.x, this.y);
		}
	
		public function dot(v:Vector):Number {
			return x * v.x + y * v.y;
		}
		
		public function cross(v:Vector):Number {
			return x * v.y - y * v.x;
		}
		
		public function getAdd(v:Vector):Vector {
			return new Vector(x + v.x, y + v.y); 
		}
		
		public function add(v:Vector):Vector {
			x += v.x;
			y += v.y;
			return this;
		}
		
		public function getSub(v:Vector):Vector {
			return new Vector(x - v.x, y - v.y);    
		}
	
		public function sub(v:Vector):Vector {
			x -= v.x;
			y -= v.y;
			return this;
		}
	
		public function getMul(s:Number):Vector {
			return new Vector(x * s, y * s);
		}
	
		public function mul(s:Number):Vector {
			x *= s;
			y *= s;
			return this;
		}
	
//		public function times(v:Vector):Vector {
//			return new Vector(x * v.x, y * v.y);
//		}

		public function div(s:Number):Vector {
			if (s == 0) s = 0.00001;
			x /= s;
			y /= s;
			return this;
		}
		
		public function magnitude():Number {
			return Math.sqrt(x * x + y * y);
		}

		public function distance(v:Vector):Number {
			var delta:Vector = this.getSub(v);
			return delta.magnitude();
		}

		public function normalize():Vector {
			 var m:Number = this.magnitude();
			 if (m == 0) m = 0.00001;
			 return this.mul(1 / m);
		}
		
		public function getNormalize():Vector {
			 var m:Number = this.magnitude();
			 if (m == 0) m = 0.00001;
			 return this.getMul(1 / m);
		}
		
		public function getAngle(target:Vector):Number {
			return Math.atan2(target.y - this.y, target.x - this.x);
		}
		
		public function toAngle():Number {
			return Math.atan2(this.y, this.x);
		}
		
		public function rotate(rad:Number):Vector {
			var v:Vector = this.clone();
			this.x = Math.cos(rad) * v.x - Math.sin(rad) * v.y;
			this.y = Math.sin(rad) * v.x + Math.cos(rad) * v.y;
			return this;
		}
		
		public function getRotate(rad:Number):Vector {
			return new Vector(Math.cos(rad) * this.x - Math.sin(rad) * this.y, Math.sin(rad) * this.x + Math.cos(rad) * this.y);
		}
		
		public function toPoint():Point {
			return new Point(this.x, this.y);
		}
			
		public function toString():String {
			return '[Vector: x=' + this.x.toString().substr(0, 5) + ', y=' + this.y.toString().substr(0, 5) + ']';
		}
		
		public static function fromPoint(p:Point):Vector {
			return new Vector(p.x, p.y);
		}
		
		public static function fromAngle(a:Number):Vector {
			return new Vector(Math.cos(a), Math.sin(a));
		}

	}
	
}