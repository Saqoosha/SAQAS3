package sh.saqoo.math {


	/**
	 * Partially ported from JSXGraph.
	 * @author Saqoosha
	 * @see http://jsxgraph.uni-bayreuth.de/wp/
	 */
	public class MatrixUtil {


		/**
		 * Initializes a matrix as an array of rows with the given value.
		 * @param {Number} n Number of rows
		 * @param {Number} [m=n] Number of columns
		 * @param {Number} [init=0] Initial value for each coefficient
		 * @returns {Array} A <tt>n</tt> times <tt>m</tt>-matrix represented by a
		 * two-dimensional array. The inner arrays hold the columns, the outer array holds the rows.
		 */
		public static function create(n:int, m:int = 0, init:Number = 0):Array {
			var r:Array, i:int, j:int;

			init = init || 0;
			m = m || n;

			r = new Array(n);
			for (i = 0; i < n; i++) {
				r[i] = new Array(m);
				for (j = 0; j < m; j++) {
					r[i][j] = init;
				}
			}

			return r;
		}


		/**
		 * Multiplies a vector vec to a matrix mat: mat * vec. The matrix is interpreted by this function as an array of rows. Please note: This
		 * function does not check if the dimensions match.
		 * @param {Array} mat Two dimensional array of numbers. The inner arrays describe the columns, the outer ones the matrix' rows.
		 * @param {Array} vec Array of numbers
		 * @returns {Array} Array of numbers containing the result
		 * @example
		 * var A = [[2, 1],
		 *          [1, 3]],
		 *     b = [4, 5],
		 *     c;
		 * c = JXG.Math.matVecMult(A, b)
		 * // c === [13, 19];
		 */
		public static function matVecMult(mat:Array, vec:Array):Array {
			var m:int = mat.length,
				n:int = vec.length,
				res:Array = [],
				i:int, s:Number, k:int;

			if (n === 3) {
				for (i = 0; i < m; i++) {
					res[i] = mat[i][0] * vec[0] + mat[i][1] * vec[1] + mat[i][2] * vec[2];
				}
			} else {
				for (i = 0; i < m; i++) {
					s = 0;
					for (k = 0; k < n; k++) {
						s += mat[i][k] * vec[k];
					}
					res[i] = s;
				}
			}
			return res;
		}


		/**
		 * Computes the product of the two matrices mat1*mat2.
		 * @param {Array} mat1 Two dimensional array of numbers
		 * @param {Array} mat2 Two dimensional array of numbers
		 * @returns {Array} Two dimensional Array of numbers containing result
		 */
		public static function matMatMult(mat1:Array, mat2:Array):Array {
			var m:int = mat1.length,
				n:int = m > 0 ? mat2[0].length : 0,
				m2:int = mat2.length,
				res:Array = create(m, n),
				i:int, j:int, s:Number, k:int;

			for (i = 0; i < m; i++) {
				for (j = 0; j < n; j++) {
					s = 0;
					for (k = 0; k < m2; k++) {
						s += mat1[i][k] * mat2[k][j];
					}
					res[i][j] = s;
				}
			}
			return res;
		}


		/**
		 * Transposes a matrix given as a two dimensional array.
		 * @param {Array} M The matrix to be transposed
		 * @returns {Array} The transpose of M
		 */
		public static function transpose(M:Array):Array {
			var MT:Array, i:int, j:int, m:int, n:int;

			m = M.length;
			// number of rows of M
			n = M.length > 0 ? M[0].length : 0;
			// number of columns of M
			MT = create(n, m);

			for (i = 0; i < n; i++) {
				for (j = 0; j < m; j++) {
					MT[i][j] = M[j][i];
				}
			}
			return MT;
		}
	}
}
