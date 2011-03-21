package sh.saqoo.math {

	import flash.geom.Point;

	/**
	 * @author Saqoosha
	 * @see http://jsxgraph.uni-bayreuth.de/wiki/index.php/Least-squares_circle_fitting
	 */
	public class CircleFitting {
		
		
		public static function calc(points:Vector.<Point>):Object {
			// Having constructed the points, we can fit a circle 
			// through the point set, consisting of n points.
			// The (n times 3) matrix consists of
			//   x_1, y_1, 1
			//   x_2, y_2, 1
			//      ...
			//   x_n, y_n, 1
			// where x_i, y_i is the position of point p_i
			// The vector y of length n consists of
			//    x_i*x_i+y_i*y_i 
			// for i=1,...n.
			var M:Array = [], y:Array = [], MT:Array, B:Array, c:Array, z:Array, n:int;
			n = points.length;
			for (var i:int = 0; i < n; i++) {
				M.push([points[i].x, points[i].y, 1.0]);
				y.push(points[i].x * points[i].x + points[i].y * points[i].y);
			}
			 
			// Now, the general linear least-square fitting problem
			//    min_z || M*z - y||_2^2
			// is solved by solving the system of linear equations
			//    (M^T*M) * z = (M^T*y)
			// with Gauss elimination.
			MT = MatrixUtil.transpose(M);
			B = MatrixUtil.matMatMult(MT, M);
			c = MatrixUtil.matVecMult(MT, y);
			z = GaussJordanElimination.solve(B, c);
			 
			// Finally, we can read from the solution vector z the coordinates [xm, ym] of the center
			// and the radius r and draw the circle.
			var xm:Number = z[0] * 0.5;
			var ym:Number = z[1] * 0.5;
			var r:Number = Math.sqrt(z[2] + xm * xm + ym * ym);

			return {x: xm, y: ym, r: r};
		}
	}
}
