package net.saqoosha.flint {
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Quaternion;

	import flash.events.Event;

	
	public class Emitter3D extends org.flintparticles.threeD.emitters.Emitter3D {
		
		
		public static const PRE_CREATE_PARTICLE:String = 'preCreateParticle';
		private static const PreCreateParticleEvent:Event = new Event(PRE_CREATE_PARTICLE);
		
		
		protected var _origin:Vertex3D;
		protected var _target:Vertex3D;
		
		protected var _prevPosition:Vector3D;
		protected var _velocity:Vector3D;
		
		public var calculateVelocity:Boolean = true;
		
		
		public function Emitter3D(origin:Vertex3D = null, target:Vertex3D = null) {
			_origin = origin || new Vertex3D(0, 0, 0);
			_target = target || new Vertex3D(0, 1, 0);
			updateTransform(Matrix3D.IDENTITY);
		}
		
		
		public override function start():void {
			_prevPosition = position.clone();
			_velocity = new Vector3D();
			super.start();
		}
		
		
		public override function update(time:Number):void {
			if (calculateVelocity) {
				position.subtract(_prevPosition, _velocity);
				_velocity.multiply(1 / time, _velocity);
			}
			position.clone(_prevPosition);
			super.update(time);
		}
		
		
		protected override function createParticle():Particle {
			dispatchEvent(PreCreateParticleEvent);
			return super.createParticle();
		}


		private var _p0:Number3D = new Number3D();
		private var _p1:Number3D = new Number3D();
		private var _unitY:Number3D = new Number3D(0, 1, 0);
		private var _axis:Number3D = new Number3D();
		private var _q:Quaternion = new Quaternion();
		public function updateTransform(m:Matrix3D):void {
			_p0.x = _origin.x;
			_p0.y = _origin.y;
			_p0.z = _origin.z;
			Matrix3D.multiplyVector(m, _p0);
			position.x = _p0.x;
			position.y = _p0.y;
			position.z = _p0.z;
			
			_p1.x = _target.x;
			_p1.y = _target.y;
			_p1.z = _target.z;
			Matrix3D.multiplyVector(m, _p1);
			_p0.minusEq(_p1);
			_p0.normalize();
			Number3D.cross(_p0, _unitY, _axis);
			_axis.normalize();
			var rad:Number = Math.acos(Number3D.dot(_p0, _unitY));
			_q.setFromAxisAngle(_axis.x, _axis.y, _axis.z, rad);
			rotation.x = _q.x;
			rotation.y = _q.y;
			rotation.z = _q.z;
			rotation.w = _q.w;
		}

		
		public function resetVelocity():void {
			_velocity.reset();
			position.clone(_prevPosition);
		}
		
		
		//

		
		public function get origin():Vertex3D {
			return _origin;
		}
		
		public function set origin(value:Vertex3D):void {
			_origin = value;
		}

		public function get target():Vertex3D {
			return _target;
		}
		
		public function set target(value:Vertex3D):void {
			_target = value;
		}

		public function get velocity():Vector3D {
			return _velocity;
		}
		
		public function set velocity(value:Vector3D):void {
			value.clone(_velocity);
		}

		public function get prevPosition():Vector3D {
			return _prevPosition;
		}
		
		public function set prevPosition(value:Vector3D):void {
			value.clone(_prevPosition);
		}
	}
}
