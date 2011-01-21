package sh.saqoo.math {
	import de.polygonal.math.PM_PRNG;

	
	public class PerlinNoise {

		
		private static const MAXB:int = 0x100;
		private static const N:int = 0x1000;

		private static function s_curve(t:Number):Number {
			return t * t * (3 - 2 * t);
		}

		
		private static function lerp(t:Number, a:Number, b:Number):Number {
			return a + t * (b - a);
		}

		private static var p:Array;
		private static var g1:Array;
		private static var g2:Array;
		private static var g3:Array;

		private static var start:int = 1;
		private static var B:int;
		private static var BM:int;	

		public static function SetNoiseFrequency(frequency:int):void {
			start = 1;
			B = frequency;
			BM = B - 1;
		}

		
		public static function noise1(arg:Number):Number {
			var bx0:int, bx1:int;
			var rx0:Number, rx1:Number, sx:Number, t:Number, u:Number, v:Number;
			var vec:Array = new Array(1);
		
			vec[0] = arg;
			if (start) {
				start = 0;
				initNoise();
			}
		
			t = vec[0] + N;
			bx0 = (int(t)) & BM;
			bx1 = (bx0 + 1) & BM;
			rx0 = t - int(t);
			rx1 = rx0 - 1.;
		
			sx = s_curve(rx0);
			u = rx0 * g1[p[bx0]];
			v = rx1 * g1[p[bx1]];
		
			return lerp(sx, u, v);
		}

		
		public static function noise2(vec:Array):Number {
			var bx0:int, bx1:int, by0:int, by1:int, b00:int, b10:int, b01:int, b11:int;
			var rx0:Number, rx1:Number, ry0:Number, ry1:Number, sx:Number, sy:Number, a:Number, b:Number, t:Number, u:Number, v:Number;
			var q:Array;
			var i:int, j:int;
		
			if (start) {
				start = 0;
				initNoise();
			}
		
			t = vec[0] + N;
			bx0 = (int(t)) & BM;
			bx1 = (bx0 + 1) & BM;
			rx0 = t - int(t);
			rx1 = rx0 - 1.;
			t = vec[1] + N;
			by0 = (int(t)) & BM;
			by1 = (by0 + 1) & BM;
			ry0 = t - int(t);
			ry1 = ry0 - 1.;
		
			i = p[bx0];
			j = p[bx1];
		
			b00 = p[i + by0];
			b10 = p[j + by0];
			b01 = p[i + by1];
			b11 = p[j + by1];
		
			sx = s_curve(rx0);
			sy = s_curve(ry0);
		
			q = g2[b00];
			u = rx0 * q[0] + ry0 * q[1]
			q = g2[b10];
			v = rx1 * q[0] + ry0 * q[1];
			a = lerp(sx, u, v);
		
			q = g2[b01];
			u = rx0 * q[0] + ry1 * q[1];
			q = g2[b11];
			v = rx1 * q[0] + ry1 * q[1];
			b = lerp(sx, u, v);
		
			return lerp(sy, a, b);
		}

		
		public static function noise3(vec:Array):Number {
			var bx0:int, bx1:int, by0:int, by1:int, bz0:int, bz1:int, b00:int, b10:int, b01:int, b11:int;
			var rx0:Number, rx1:Number, ry0:Number, ry1:Number, rz0:Number, rz1:Number, sy:Number, sz:Number, a:Number, b:Number, c:Number, d:Number, t:Number, u:Number, v:Number;
			var q:Array;
			var i:int, j:int;
		
			if (start) {
				start = 0;
				initNoise();
			}
		
			t = vec[0] + N;
			bx0 = (int(t)) & BM;
			bx1 = (bx0 + 1) & BM;
			rx0 = t - int(t);
			rx1 = rx0 - 1.;
			t = vec[1] + N;
			by0 = (int(t)) & BM;
			by1 = (by0 + 1) & BM;
			ry0 = t - int(t);
			ry1 = ry0 - 1.;
			t = vec[2] + N;
			bz0 = (int(t)) & BM;
			bz1 = (bz0 + 1) & BM;
			rz0 = t - int(t);
			rz1 = rz0 - 1.;
		
			i = p[bx0];
			j = p[bx1];
		
			b00 = p[i + by0];
			b10 = p[j + by0];
			b01 = p[i + by1];
			b11 = p[j + by1];
		
			t = s_curve(rx0);
			sy = s_curve(ry0);
			sz = s_curve(rz0);
		
			q = g3[b00 + bz0];
			u = rx0 * q[0] + ry0 * q[1] + rz0 * q[2];
			q = g3[b10 + bz0];
			v = rx1 * q[0] + ry0 * q[1] + rz0 * q[2];
			a = lerp(t, u, v);
		
			q = g3[b01 + bz0];
			u = rx0 * q[0] + ry1 * q[1] + rz0 * q[2];
			q = g3[b11 + bz0];
			v = rx1 * q[0] + ry1 * q[1] + rz0 * q[2];
			b = lerp(t, u, v);
		
			c = lerp(sy, a, b);
		
			q = g3[b00 + bz1];
			u = rx0 * q[0] + ry0 * q[1] + rz1 * q[2];
			q = g3[b10 + bz1];
			v = rx1 * q[0] + ry0 * q[1] + rz1 * q[2];
			a = lerp(t, u, v);
		
			q = g3[b01 + bz1];
			u = rx0 * q[0] + ry1 * q[1] + rz1 * q[2];
			q = g3[b11 + bz1];
			v = rx1 * q[0] + ry1 * q[1] + rz1 * q[2];
			b = lerp(t, u, v);
		
			d = lerp(sy, a, b);
		
			return lerp(sz, c, d);
		}

		
		public static function normalize2(v:Array):void {
			var s:Number;
		
			s = Math.sqrt(v[0] * v[0] + v[1] * v[1]);
			v[0] = v[0] / s;
			v[1] = v[1] / s;
		}

		
		public static function normalize3(v:Array):void {
			var s:Number;
		
			s = Math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
			v[0] = v[0] / s;
			v[1] = v[1] / s;
			v[2] = v[2] / s;
		}

		
		public static function initNoise():void {
			var i:int, j:int, k:int;
			var rnd:PM_PRNG = new PM_PRNG();
			rnd.seed = 30757;
		
			p = new Array(MAXB + MAXB + 2);
			g1 = new Array(MAXB + MAXB + 2);
			g2 = new Array(MAXB + MAXB + 2);
			g3 = new Array(MAXB + MAXB + 2);
			for (i = 0; i < B; i++) {
				p[i] = i;
				g1[i] = rnd.nextDoubleRange(-1, 1);

				g2[i] = new Array(2);
				for (j = 0; j < 2; j++)
					g2[i][j] = rnd.nextDoubleRange(-1, 1);
				normalize2(g2[i]);

				g3[i] = new Array(3);
				for (j = 0; j < 3; j++)
					g3[i][j] = rnd.nextDoubleRange(-1, 1);
				normalize3(g3[i]);
			}
		
			while (--i) {
				k = p[i];
				p[i] = p[j = rnd.nextIntRange(0, 7)];
				p[j] = k;
			}
		
			for (i = 0; i < B + 2; i++) {
				p[B + i] = p[i];
				g1[B + i] = g1[i];
				g2[B + i] = new Array(2);
				for (j = 0; j < 2; j++)
					g2[B + i][j] = g2[i][j];
				g3[B + i] = new Array(3);
				for (j = 0; j < 3; j++)
					g3[B + i][j] = g3[i][j];
			}
		}

		
		// My harmonic summing functions - PDB
		
		//
		// In what follows "alpha" is the weight when the sum is formed.
		// Typically it is 2, As this approaches 1 the function is noisier.
		// "beta" is the harmonic scaling/spacing, typically 2.
		//
		public static function get1d(x:Number, alpha:Number, beta:Number, n:int):Number {
			var i:int;
			var val:Number, sum:Number = 0;
			var p:Number, scale:Number = 1;
		
			p = x;
			for (i = 0; i < n; i++) {
				val = noise1(p);
				sum += val / scale;
				scale *= alpha;
				p *= beta;
			}
			return sum;
		}

		
		public static function get2d(x:Number, y:Number, alpha:Number, beta:Number, n:int):Number {		
			var i:int;
			var val:Number, sum:Number = 0;
			var p:Array, scale:Number = 1;
		
			p = [x, y];
			for (i = 0; i < n; i++) {
				val = noise2(p);
				sum += val / scale;
				scale *= alpha;
				p[0] *= beta;
				p[1] *= beta;
			}
			return sum;
		}

		
		public static function get3d(x:Number, y:Number, z:Number, alpha:Number, beta:Number, n:int):Number {
			var i:int;
			var val:Number, sum:Number = 0;
			var p:Array, scale:Number = 1;

			p = [x, y, z];		
			for (i = 0; i < n; i++) {
				val = noise3(p);
				sum += val / scale;
				scale *= alpha;
				p[0] *= beta;
				p[1] *= beta;
				p[2] *= beta;
			}
			return sum;
		}
	}
}
