package sh.saqoo.flint {
	
	import org.flintparticles.common.utils.Maths;
	import org.flintparticles.threeD.geom.Matrix3D;
	import org.flintparticles.threeD.geom.Quaternion;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.zones.Zone3D;
	
	public class RingZone implements Zone3D {
		
		private var _direction:Vector3D;
		private var _radius:Number;
		private var _height:Number;
		private var _angle:Number;
		
		private var _transform:Matrix3D;
		private var _current:Number;
		
		public function RingZone(direction:Vector3D, radius:Number, height:Number, angle:Number) {
			_transform = new Matrix3D();
			
			this.direction = direction;
			_radius = radius;
			_height = height;
			_angle = Maths.asRadians(angle);
			
			_current = 0;
		}
		
		public function contains( p:Vector3D ):Boolean {
			return false;
		}
		
		public function getLocation():Vector3D {
			var vx:Number = Math.cos(_current) * _radius;
			var vz:Number = Math.sin(_current) * _radius;
			_current += _angle;
			var v:Vector3D = new Vector3D(vx, _height, vz);
			if (_transform) {
				_transform.transformVectorSelf(v);
			}
			return v;
		}
		
		public function getVolume():Number {
			return 0;
		}
		
		public function get direction():Vector3D {
			return _direction;
		}
		
		private var _p:Vector3D = new Vector3D();
		private var _q:Quaternion = new Quaternion();
		public function set direction(value:Vector3D):void {
			if (!_direction || !value.equals(_direction)) {
				_direction = value.normalize();
				if (_direction.equals(Vector3D.AXISY)) {
					_transform = null;
//					_transform.copy(Matrix3D.IDENTITY);
					return;
				}
				_direction.crossProduct(Vector3D.AXISY, _p);
				_q.setFromAxisRotation(_p, Math.acos(_direction.dotProduct(Vector3D.AXISY)));
				_transform = _q.toMatrixTransformation();
			}
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function set height(value:Number):void {
			_height = value;
		}
		
		public function get angle():Number {
			return Maths.asDegrees(_angle);
		}
		
		public function set angle(value:Number):void {
			_angle = Maths.asRadians(value);
		}
	} 
}
