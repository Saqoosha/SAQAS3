package sh.saqoo.geom {

	import flash.geom.Point;

	
	/**
	 * An Algorithm for Automatically Fitting Digitized Curves
	 * by Philip J. Schneider
	 * from "Graphics Gems", Academic Press, 1990.
	 * @author Saqoosha
	 * @see http://www.graphicsgems.org/
	 * @see http://www.carlosicaza.com/?p=56
	 */
	public class CubicBezierFitter {
		
		
		/**
		 * Fit a Bezier curve to a set of digitized points 
		 * @param points Array of digitized points
		 * @param error User-defined error squared
		 */
		public static function FitCurve(points:Vector.<Point>, error:Number):CubicBezier {
			var nPts:int = points.length;	/*  Number of digitized points	*/
			var tHat1:Point, tHat2:Point;	/*  Unit tangent vectors at endpoints */
			tHat1 = ComputeLeftTangent(points, 0);
			tHat2 = ComputeRightTangent(points, nPts - 1);
			var segments:Vector.<CubicBezierSegment> = new Vector.<CubicBezierSegment>();
			FitCubic(points, 0, nPts - 1, tHat1, tHat2, error, segments);
			return new CubicBezier(segments);
		}

		
		/**
		 * FitCubic :
		 *     Fit a Bezier curve to a (sub)set of digitized points
		 * @param d Array of digitized points
		 * @param first Indices of first pts in region
		 * @param last Indices of last pts in region
		 * @param tHat1 Unit tangent vectors at endpoints
		 * @param tHat2 Unit tangent vectors at endpoints
		 * @param error User-defined error squared
		 * @param out Container for generatet contorl points
		 */
		private static function FitCubic(d:Vector.<Point>, first:int, last:int, tHat1:Point, tHat2:Point, error:Number, curves:Vector.<CubicBezierSegment>):void {
			var bezCurve:Vector.<Point>;	/*  Control points of fitted Bezier curve  */
			var u:Vector.<Number>;			/*  Parameter values for point  */
			var uPrime:Vector.<Number>;		/*  Improved parameter values */
			var maxError:Number;			/*  Maximum fitting error	 */
			var splitPoint:IntValue = new IntValue();		/*  Point to split point set at	 */
			var nPts:int;					/*  Number of points in subset  */
			var iterationError:Number;		/*  Error below which you try iterating  */
			var maxIterations:int = 4;		/*  Max times to try iterating  */
			var tHatCenter:Point;			/*  Unit tangent vector at splitPoint  */
			var i:int;
			
			iterationError = error * error;
			nPts = last - first + 1;
		
			/*  Use heuristic if region only has two points in it */
			if (nPts == 2) {
				var dist:Number = Point.distance(d[last], d[first]) / 3.0;
				bezCurve = new Vector.<Point>(4, true);
				bezCurve[0] = d[first].clone();
				bezCurve[1] = new Point();				bezCurve[2] = new Point();
				bezCurve[3] = d[last].clone();
				V2Add(bezCurve[0], V2Scale(tHat1, dist), bezCurve[1]);
				V2Add(bezCurve[3], V2Scale(tHat2, dist), bezCurve[2]);
				curves.push(new CubicBezierSegment(bezCurve[0], bezCurve[1], bezCurve[2], bezCurve[3]));
				return;			}

			/*  Parameterize points, and attempt to fit curve */
			u = ChordLengthParameterize(d, first, last);
			bezCurve = GenerateBezier(d, first, last, u, tHat1, tHat2);
			
			/*  Find max deviation of points to fitted curve */
			maxError = ComputeMaxError(d, first, last, bezCurve, u, splitPoint);
			if (maxError < error) {
//				out.push(bezCurve[0], bezCurve[1], bezCurve[2], bezCurve[3]);
				curves.push(new CubicBezierSegment(bezCurve[0], bezCurve[1], bezCurve[2], bezCurve[3]));				return;
			}

			/*  If error not too large, try some reparameterization  */
			/*  and iteration */
			if (maxError < iterationError) {
				for (i = 0; i < maxIterations; ++i) {
					uPrime = Reparameterize(d, first, last, u, bezCurve);
					bezCurve = GenerateBezier(d, first, last, uPrime, tHat1, tHat2);
					maxError = ComputeMaxError(d, first, last, bezCurve, uPrime, splitPoint);
					if (maxError < error) {
//						out.push(bezCurve[0], bezCurve[1], bezCurve[2], bezCurve[3]);
						curves.push(new CubicBezierSegment(bezCurve[0], bezCurve[1], bezCurve[2], bezCurve[3]));
						return;
					}
					u = uPrime;
				}
			}

			/* Fitting failed -- split at max error point and fit recursively */
			tHatCenter = ComputeCenterTangent(d, splitPoint.value);
			FitCubic(d, first, splitPoint.value, tHat1, tHatCenter, error, curves);
			V2Negate(tHatCenter);
			FitCubic(d, splitPoint.value, last, tHatCenter, tHat2, error, curves);
		}

		
		/**
		 * GenerateBezier :
		 * Use least-squares method to find Bezier control points for region.
		 * @param d Array of digitized points
		 * @param first Indices defining region
		 * @param last Indices defining region
		 * @param uPrime Parameter values for region
		 * @param tHat1 Unit tangent vectors at endpoints
		 * @param tHat2 Unit tangent vectors at endpoints
		 */
		private static function GenerateBezier(d:Vector.<Point>, first:int, last:int, uPrime:Vector.<Number>, tHat1:Point, tHat2:Point):Vector.<Point> {
			var i:int;
			var tmp:Point;
			var bezCurve:Vector.<Point> = Vector.<Point>([new Point(), new Point(), new Point(), new Point()]);
			var nPts:int = last - first + 1;
			
			/* Compute the A's	*/
			var A:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>(nPts, true);
			for (i = 0; i < nPts; ++i) {
				var v1:Point, v2:Point;
				v1 = tHat1.clone();
				v2 = tHat2.clone();
				v1.normalize(B1(uPrime[i]));
				v2.normalize(B2(uPrime[i]));
				A[i] = Vector.<Point>([v1, v2]);
			}
			
			/* Create the C and X matrices	*/
			var C:Vector.<Vector.<Number>> = Vector.<Vector.<Number>>([
				Vector.<Number>([0.0, 0.0]),
				Vector.<Number>([0.0, 0.0])
			]);
			var X:Vector.<Number> = Vector.<Number>([0.0, 0.0]);
			
			for (i = 0; i < nPts; ++i) {
				C[0][0] += V2Dot(A[i][0], A[i][0]);
				C[0][1] += V2Dot(A[i][0], A[i][1]);
				C[1][0] = C[0][1];
				C[1][1] += V2Dot(A[i][1], A[i][1]);
				
				tmp = V2SubII(d[first + i],
					V2AddII(
						V2ScaleIII(d[first], B0(uPrime[i])),
						V2AddII(
							V2ScaleIII(d[first], B1(uPrime[i])),
							V2AddII(
								V2ScaleIII(d[last], B2(uPrime[i])),
								V2ScaleIII(d[last], B3(uPrime[i]))
							)
						)
					)
				);
				X[0] += V2Dot(A[i][0], tmp);
				X[1] += V2Dot(A[i][1], tmp);
			}

			/* Compute the determinants of C and X	*/
			var det_C0_C1:Number = C[0][0] * C[1][1] - C[1][0] * C[0][1];
			var det_C0_X:Number  = C[0][0] * X[1]    - C[1][0] * X[0];
			var det_X_C1:Number  = X[0]    * C[1][1] - X[1]    * C[0][1];
			
			/* Finally, derive alpha values	*/
			var alpha_l:Number = (det_C0_C1 == 0) ? 0.0 : det_X_C1 / det_C0_C1;
			var alpha_r:Number = (det_C0_C1 == 0) ? 0.0 : det_C0_X / det_C0_C1;

			/* If alpha negative, use the Wu/Barsky heuristic (see text) */
			/* (if alpha is 0, you get coincident control points that lead to
			 * divide by zero in any subsequent NewtonRaphsonRootFind() call. */
			var segLength:Number = Point.distance(d[last], d[first]);
			var epsilon:Number = 1.0e-6 * segLength;
			if (alpha_l < epsilon || alpha_r < epsilon) {
				/* fall back on standard (probably inaccurate) formula, and subdivide further if needed. */
				var dist:Number = segLength / 3.0;
				bezCurve[0] = d[first].clone();
				bezCurve[3] = d[last].clone();
				V2Add(bezCurve[0], V2Scale(tHat1, dist), bezCurve[1]);
				V2Add(bezCurve[3], V2Scale(tHat2, dist), bezCurve[2]);
				return bezCurve;
			}

			/*  First and last control points of the Bezier curve are */
			/*  positioned exactly at the first and last data points */
			/*  Control points 1 and 2 are positioned an alpha distance out */
			/*  on the tangent vectors, left and right, respectively */
			bezCurve[0] = d[first].clone();
			bezCurve[3] = d[last].clone();
			V2Add(bezCurve[0], V2Scale(tHat1, alpha_l), bezCurve[1]);
			V2Add(bezCurve[3], V2Scale(tHat2, alpha_r), bezCurve[2]);
			return bezCurve;
		}


 		/**
 		 * Reparameterize:
 		 * Given set of points and their parameterization, try to find
 		 *  a better parameterization.
 		 */
 		private static function Reparameterize(d:Vector.<Point>, first:int, last:int, u:Vector.<Number>, bezCurve:Vector.<Point>):Vector.<Number> {
 			var nPts:int = last - first + 1;
 			var i:int;
 			var uPrime:Vector.<Number> = new Vector.<Number>(nPts, true);	/*  New parameter values    */
 			
 			for (i = first; i <= last; ++i) {
				uPrime[i - first] = NewtonRaphsonRootFind(bezCurve, d[i], u[i - first]);
			}
			return uPrime;
		}


 		/**
		 *  NewtonRaphsonRootFind :
		 *  Use Newton-Raphson iteration to find better root.
 		 */
 		private static function NewtonRaphsonRootFind(Q:Vector.<Point>, P:Point, u:Number):Number {
			var numerator:Number, denominator:Number;
			var Q1:Vector.<Point> = new Vector.<Point>(3, true);	/*  Q'           */
			var Q2:Vector.<Point> = new Vector.<Point>(2, true);	/*  Q''          */
			var Q_u:Point, Q1_u:Point, Q2_u:Point;					/*  u evaluated at Q, Q', & Q''  */
			var uPrime:Number;										/*  Improved u          */
			var i:int;
			
			/* Compute Q(u) */
			Q_u = BezierII(3, Q, u);

			/* Generate control vertices for Q' */
			for (i = 0; i <= 2; i++) {
				Q1[i] = new Point((Q[i + 1].x - Q[i].x) * 3.0, (Q[i + 1].y - Q[i].y) * 3.0);
			}
			
			/* Generate control vertices for Q'' */
			for (i = 0; i <= 1; i++) {
				Q2[i] = new Point((Q1[i + 1].x - Q1[i].x) * 2.0, (Q1[i + 1].y - Q1[i].y) * 2.0);
			}
			
			/* Compute Q'(u) and Q''(u) */
			Q1_u = BezierII(2, Q1, u);
			Q2_u = BezierII(1, Q2, u);
			
			/* Compute f(u)/f'(u) */
			numerator = (Q_u.x - P.x) * (Q1_u.x) + (Q_u.y - P.y) * (Q1_u.y);
			denominator = (Q1_u.x) * (Q1_u.x) + (Q1_u.y) * (Q1_u.y) + (Q_u.x - P.x) * (Q2_u.x) + (Q_u.y - P.y) * (Q2_u.y);
			if (denominator == 0.0) return u;

			/* u = u - f(u)/f'(u) */
			uPrime = u - (numerator / denominator);
			return uPrime;
 		}

		
		/**
 		 * Bezier :
 		 *     Evaluate a Bezier curve at a particular parameter value
 		 */
 		private static function BezierII(degree:int, V:Vector.<Point>, t:Number):Point {
 			var i:int, j:int;
 			var Vtemp:Vector.<Point>;	/* Local copy of control points     */
			Vtemp = new Vector.<Point>(degree + 1, true);
 			
 			/* Copy array   */
 			for (i = 0; i <= degree; ++i) {
				Vtemp[i] = V[i].clone();
			}
			
			/* Triangle computation */
			for (i = 1; i <= degree; ++i) {
				for (j = 0; j<= degree - i; ++j) {
					Vtemp[j].x = (1.0 - t) * Vtemp[j].x + t * Vtemp[j + 1].x;
					Vtemp[j].y = (1.0 - t) * Vtemp[j].y + t * Vtemp[j + 1].y;
				}
			}
			return Vtemp[0].clone();
		}

		
		/**
		 * B0, B1, B2, B3 :
		 * Bezier multipliers
		 */
		private static function B0(u:Number):Number {
			var tmp:Number = 1.0 - u;
			return tmp * tmp * tmp;
		}
		
		private static function B1(u:Number):Number {
			var tmp:Number = 1.0 - u;
			return 3 * u * tmp * tmp;
		}
		
		private static function B2(u:Number):Number {
			var tmp:Number = 1.0 - u;
			return 3 * u * u * tmp;
		}
		
		private static function B3(u:Number):Number {
			return u * u * u;
		}


		/**
		 * ComputeLeftTangent, ComputeRightTangent, ComputeCenterTangent :
		 * Approximate unit tangents at endpoints and "center" of digitized curve
		 */		
		private static function ComputeLeftTangent(d:Vector.<Point>, end:int):Point {
			var tHat1:Point = d[end + 1].subtract(d[end]);
			tHat1.normalize(1);
			return tHat1;
		}
		
		private static function ComputeRightTangent(d:Vector.<Point>, end:int):Point {
			var tHat2:Point = d[end - 1].subtract(d[end]);
			tHat2.normalize(1);
			return tHat2;
		}
		
		private static function ComputeCenterTangent(d:Vector.<Point>, center:int):Point {
			var V1:Point, V2:Point, tHatCenter:Point;
			V1 = d[center - 1].subtract(d[center]);
			V2 = d[center].subtract(d[center + 1]);
			tHatCenter = new Point();
			tHatCenter.x = (V1.x + V2.x) / 2.0;
			tHatCenter.y = (V1.y + V2.y) / 2.0;
			tHatCenter.normalize(1);
			return tHatCenter;
		}
		
		
		/**
		 *  ChordLengthParameterize :
		 *	Assign parameter values to digitized points 
		 *	using relative distances between points.
		 *	@param d Array of digitized points
		 *	@param first Indices defining region
		 *	@param last Indices defining region
		 */
		private static function ChordLengthParameterize(d:Vector.<Point>, first:int, last:int):Vector.<Number> {
			var i:int;
			var u:Vector.<Number> = new Vector.<Number>(last - first + 1, true);	/*  Parameterization		*/
			
			u[0] = 0.0;
			for (i = first + 1; i <= last; ++i) {
				u[i - first] = u[i - first - 1] + Point.distance(d[i], d[i - 1]);
			}
			
			for (i = first + 1; i <= last; ++i) {
				u[i - first] = u[i - first] / u[last - first];
			}
			
			return u;
		}


 		/**
 		 * ComputeMaxError :
 		 * Find the maximum squared distance of digitized points
 		 * to fitted curve.
 		 */
 		private static function ComputeMaxError(d:Vector.<Point>, first:int, last:int, bezCurve:Vector.<Point>, u:Vector.<Number>, splitPoint:IntValue):Number {
 			var i:int;
 			var maxDist:Number;	/*  Maximum error       */
 			var dist:Number;	/*  Current error       */
 			var P:Point;		/*  Point on curve      */
 			var v:Point;		/*  Vector from point to curve  */
 			
			splitPoint.value = (last - first + 1) / 2;
			maxDist = 0.0;
			for (i = first + 1; i < last; ++i) {
				P = BezierII(3, bezCurve, u[i - first]);
				v = V2SubII(P, d[i]);
				dist = V2SquaredLength(v);
				if (dist >= maxDist) {
					maxDist = dist;
					splitPoint.value = i;
				}
			}
			return maxDist;
		}

		
		private static function V2AddII(a:Point, b:Point):Point {
			return a.add(b);
		}

		
		private static function V2ScaleIII(v:Point, s:Number):Point {
			return new Point(v.x * s, v.y * s);
		}

		
		private static function V2SubII(a:Point, b:Point):Point {
			return a.subtract(b);
		}


		/* negates the input vector and returns it */
		private static function V2Negate(v:Point):Point {
			v.x = -v.x;
			v.y = -v.y;
			return v;
		}

		/* scales the input vector to the new length and returns it */
		private static function V2Scale(v:Point, newlen:Number):Point {
			v.normalize(newlen);
			return v;
		}


		/* return vector sum c = a+b */
		private static function V2Add(a:Point, b:Point, c:Point):Point {
			c.x = a.x + b.x;
			c.y = a.y + b.y;
			return c;
		}
		
		
		/* return vector difference c = a-b */
		private static function V2Sub(a:Point, b:Point, c:Point):Point {
			c.x = a.x - b.x;
			c.y = a.y - b.y;
			return c;
		}
		

		/* return the dot product of vectors a and b */
		private static function V2Dot(a:Point, b:Point):Number {
			return a.x * b.x + a.y * b.y;
		}


		private static function V2SquaredLength(a:Point):Number {
			return a.x * a.x + a.y * a.y;
		}
	}
}


class IntValue {
	public var value:int;
	public function IntValue(value:int = 0) { this.value = value; }
}

