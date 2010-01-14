package net.saqoosha.pv3d.primitive {
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.proto.MaterialObject3D;

	public class Geosphere extends TriangleMesh3D {
		
		private static const MIN_SEGMENTS:uint = 1;
		private static const DEFAULT_SEGMENTS:uint = 3;
		private static const DEFAULT_RADIUS:Number = 100;
		
		public var segments:uint;
		
		public function Geosphere(material:MaterialObject3D = null, radius:Number = 100, segments:int = 1, initObject:Object = null) {
			super(material, new Array(), new Array(), null, initObject);
			
			this.segments = Math.max(MIN_SEGMENTS, segments || DEFAULT_SEGMENTS); // Defaults to 8
			if (radius == 0)	radius = DEFAULT_RADIUS; // Defaults to 100
			
			this.buildGeosphere(radius);
		}
		
		private function buildGeosphere(radius:Number):void {
			var nsections:uint = 20;
			var subrad:Number, subz:Number, theta:Number, sn:Number, cs:Number;
			var i:int, f:int;
			
			var aVertice:Array = this.geometry.vertices;
			var aFace:Array = this.geometry.faces;

			// get first 12 Vertices //
			aVertice.push(new Vertex3D(0, 0, radius));
			subz = Math.sqrt(0.2) * radius;
			subrad = 2 * subz;
			for (i = 0; i < 5; i++) {
				theta = 2 * Math.PI * i / 5;
				sn = Math.sin (theta);
				cs = Math.cos (theta);
				aVertice.push(new Vertex3D(subrad * cs, subrad * sn, subz));
			}
			for (i = 0; i < 5; i++) {
				theta = Math.PI * (2 * i + 1) / 5;
				sn = Math.sin (theta);
				cs = Math.cos (theta);
				aVertice.push(new Vertex3D(subrad * cs, subrad * sn, -subz));
			}
			aVertice.push(new Vertex3D(0, 0, -radius));
			
			// tessellate triangles
			for (i = 0; i < 5 ; i++) interpolate(0, i + 1, this.segments);
			for (i = 0; i < 5 ; i++) interpolate(i + 1, (i + 1) % 5 + 1, this.segments);
			for (i = 0; i < 5 ; i++) interpolate(i + 1, i + 6, this.segments);
			for (i = 0; i < 5 ; i++) interpolate(i + 1, (i + 4) % 5 + 6, this.segments);
			for (i = 0; i < 5 ; i++) interpolate(i + 6, (i + 1) % 5 + 6, this.segments);
			for (i = 0; i < 5 ; i++) interpolate(11, i + 6, this.segments);
			for (f = 0; f < 5 ; f++) {
				for (i = 1; i <= this.segments - 2; i++) {
					interpolate(12 + f * (this.segments - 1) + i, 12 + ((f + 1) % 5) * (this.segments - 1) + i, i + 1);
				}
			}
			for (f = 0; f < 5 ; f++) {
				for (i = 1; i <= this.segments - 2 ; i++) {
					interpolate(12 + (f + 15) * (this.segments - 1) + i, 12 + (f + 10) * (this.segments - 1) + i, i + 1);
				}
			}
			for (f = 0; f < 5 ; f++) {
				for (i = 1; i <= this.segments - 2 ; i++) {
					interpolate(12 + (((f + 1) % 5) + 15) * (this.segments - 1) + this.segments - 2 - i, 12 + (f + 10) * (this.segments - 1) + this.segments - 2 - i, i + 1);
				}
			}
			for (f = 0; f < 5 ; f++) {
				for (i = 1; i <= this.segments - 2 ; i++) {
					interpolate(12 + (((f + 1) % 5) + 25) * (this.segments - 1) + i, 12 + (f + 25) * (this.segments - 1) + i, i + 1);
				}
			}
			
			// create faces
			for (f = 0; f <= nsections - 1; f++) {
				for (var row:int = 0 ; row <= this.segments - 1 ; row++) {
					for (var column:int = 0 ; column <= row ; column++) {
						var a:uint = findVertices(this.segments, f, row, column);
						var b:uint = findVertices(this.segments, f, row + 1, column);
						var c:uint = findVertices(this.segments, f, row + 1, column + 1);
						aFace.push(new Triangle3D(this, [aVertice[a], aVertice[c], aVertice[b]], material, [new NumberUV(), new NumberUV(), new NumberUV()]));
						if (column < row) {
							var d:uint = findVertices(this.segments, f, row, column + 1);
							aFace.push(new Triangle3D(this, [aVertice[a], aVertice[d], aVertice[c]], material, [new NumberUV(), new NumberUV(), new NumberUV()]));
						}
					}
				}
			}
			
			this.geometry.ready = true;
		}
		
		private function interpolate(v1:uint, v2:uint, num:uint):void {
			if (this.segments < 2) return;
			var aVertice:Array = this.geometry.vertices;
			var a:Vertex3D = aVertice[v1];
			var b:Vertex3D = aVertice[v2];
			var rad:Number = Number3D.dot(a.toNumber3D(), a.toNumber3D());
			var cs:Number = Number3D.dot(a.toNumber3D(), b.toNumber3D()) / rad;
			cs = (cs < -1) ? -1 : (cs > 1) ? 1 : cs;
			var theta:Number = Math.acos(cs);
			var sn:Number = Math.sin(theta);
			for (var e:int = 1; e <= num - 1; e++) {
				var np:Vertex3D = new Vertex3D();
				var theta1:Number = (theta * e) / num;
				var theta2:Number = (theta * (num - e)) / num;
				var st1:Number = Math.sin(theta1);
				var st2:Number = Math.sin(theta2);
				np.x = (a.x * st2 + b.x * st1) / sn;
				np.y = (a.y * st2 + b.y * st1) / sn;
				np.z = (a.z * st2 + b.z * st1) / sn;
				aVertice.push(np);
			}
		}
		
		private function findVertices(s:int, f:int, r:int, c:int):int {
			if (r == 0) {
				if (f < 5) return 0;
				if (f > 14) return 11;
				return f - 4;
			}
			if (r == s && c == 0) {
				if (f < 5) return f + 1;
				if (f < 10) return ((f + 4) % 5) + 6;
				if (f < 15) return ((f + 1) % 5) + 1;
				return ((f + 1) % 5) + 6;
			}
			if (r == s && c == s) {
				if (f < 5) return ((f + 1) % 5) + 1;
				if (f < 10) return f + 1;
				if (f < 15) return f - 9;
				return f - 9;
			}
			if (r == s) {
				if (f < 5) return 12 + (5 + f) * (s - 1) + c-1;
				if (f < 10) return 12 + (20 + ((f + 4) % 5)) * (s - 1) + c - 1;
				if (f < 15) return 12 + (f - 5) * (s - 1) + s - 1 - c;
				return 12 + (5 + f) * (s - 1) + s - 1 - c;
			}
			if (c == 0) {
				if (f < 5) return 12 + f * (s - 1) + r - 1;
				if (f < 10) return 12 + ((f % 5) + 15) * (s - 1) + r - 1;
				if (f < 15) return 12 + (((f + 1) % 5) + 15) * (s - 1) + s - 1 - r;
				return 12 + (((f + 1) % 5) + 25) * (s - 1) + r - 1;
			}
			if (c == r) {
				if (f < 5) return 12 + ((f + 1) % 5) * (s - 1) + r - 1;
				if (f < 10) return 12 + ((f % 5) + 10) * (s - 1) + r - 1;
				if (f < 15) return 12 + ((f % 5) + 10) * (s - 1) + s - 1 - r;
				return 12 + ((f % 5) + 25) * (s - 1) + r - 1;
			}
			return 12 + 30 * (s - 1) + f * (s - 1) * (s - 2) / 2 + (r - 1) * (r - 2) / 2 + c - 1;
		}		
		
	}
	
}
