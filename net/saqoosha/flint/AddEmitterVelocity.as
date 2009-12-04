package net.saqoosha.flint {
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.particles.Particle3D;
	
	public class AddEmitterVelocity extends InitializerBase {
		
		public function AddEmitterVelocity() {
		}
		
		public override function getDefaultPriority():Number {
			return -10;
		}
		
		public override function addedToEmitter(emitter:Emitter):void {
			if (!(emitter is Emitter3D)) {
				throw new Error('Emitter isn\'t net.saqoosha.flint.Emitter3D.');
			}
		}
		
		public override function initialize(emitter:Emitter, particle:Particle):void {
			var p:Particle3D = Particle3D(particle);
			var e:Emitter3D = Emitter3D(emitter);
			p.velocity.add(e.velocity, p.velocity);
		}
	}
}
