package sh.saqoo.math {


	/**
	 * Ported from JSXGraph.
	 * @author Saqoosha
	 * @see http://jsxgraph.uni-bayreuth.de/wp/
	 */
	public class GaussJordanElimination {
		
		
        /**
         * Solves a system of linear equations given by A and b using the Gauss-Jordan-elimination.
         * The algorithm runs in-place. I.e. the entries of A and b are changed.
         * @param {Array} A Square matrix represented by an array of rows, containing the coefficients of the lineare equation system.
         * @param {Array} b A vector containing the linear equation system's right hand side.
         * @throws {Error} If a non-square-matrix is given or if b has not the right length or A's rank is not full.
         * @returns {Array} A vector that solves the linear equation system.
         */
		public static function solve(A:Array, b:Array):Array {
            var eps:Number = 0.000001,
                // number of columns of A
                n:int = A.length > 0 ? A[0].length : 0,
                // copy the matrix to prevent changes in the original
                Acopy:Array,
                // solution vector, to prevent changing b
                x:Array,
                i:int, j:int, k:int,
                // little helper to swap array elements
                swap:Function = function (i:int, j:int):void {
                    var temp:Number = this[i];
                    this[i] = this[j];
                    this[j] = temp;
                };

            if ((n !== b.length) || (n !== A.length))
                throw new Error("Dimensions don't match. A must be a square matrix and b must be of the same length as A.");

            // initialize solution vector
            Acopy = new Array(n);
            x = b.slice(0, n);
            for (i = 0; i < n; i++) {
                Acopy[i] = A[i].slice(0, n);
            }

            // Gauss-Jordan-elimination
            for (j = 0; j < n; j++) {
                for (i = n - 1; i > j; i--) {
                    // Is the element which is to eliminate greater than zero?
                    if (Math.abs(Acopy[i][j]) > eps) {
                        // Equals pivot element zero?
                        if (Math.abs(Acopy[j][j]) < eps) {
                            // At least numerically, so we have to exchange the rows
                            swap.apply(Acopy, [i, j]);
                            swap.apply(x, [i, j]);
                        } else {
                            // Saves the L matrix of the LR-decomposition. unnecessary.
                            Acopy[i][j] /= Acopy[j][j];
                            // Transform right-hand-side b
                            x[i] -= Acopy[i][j] * x[j];
                            // subtract the multiple of A[i][j] / A[j][j] of the j-th row from the i-th.
                            for (k = j + 1; k < n; k ++) {
                                Acopy[i][k] -= Acopy[i][j] * Acopy[j][k];
                            }
                        }
                    }
                }
                if (Math.abs(Acopy[j][j]) < eps) { // The absolute values of all coefficients below the j-th row in the j-th column are smaller than JXG.Math.eps.
                    throw new Error("The given matrix seems to be singular.");
                }
            }
            backwardSolve(Acopy, x, true); // return Array

            return x;
		}


        /**
         * Solves a system of linear equations given by the right triangular matrix R and vector b.
         * @param {Array} R Right triangular matrix represented by an array of rows. All entries a_(i,j) with i &lt; j are ignored.
         * @param {Array} b Right hand side of the linear equation system.
         * @param {Boolean} [canModify=false] If true, the right hand side vector is allowed to be changed by this method.
         * @returns {Array} An array representing a vector that solves the system of linear equations.
         */
        private static function backwardSolve(R:Array, b:Array, canModify:Boolean):Array {
            var x:Array, m:int, n:int, i:int, j:int;

            if (canModify) {
                x = b;
            } else {
                x = b.slice(0, b.length);
            }

            // m: number of rows of R
            // n: number of columns of R
            m = R.length;
            n = R.length > 0 ? R[0].length : 0;
            for (i = m - 1; i >= 0; i--) {
                for (j = n - 1; j > i; j--) {
                    x[i] -= R[i][j] * x[j];
                }
                x[i] /= R[i][i];
            }

            return x;
        }
	}
}
