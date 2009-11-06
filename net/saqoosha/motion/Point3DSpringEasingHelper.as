package net.saqoosha.motion {
	
	public class Point3DSpringEasingHelper {
		
		private var _easeX:SpringEasingHelper;
		private var _easeY:SpringEasingHelper;
		private var _easeZ:SpringEasingHelper;
		
		public function Point3DSpringEasingHelper(iniX:Number, iniY:Number, iniZ:Number, factor:Number = 20, decay:Number = 0.8) {
			this._easeX = new SpringEasingHelper(iniX, factor, decay);
			this._easeY = new SpringEasingHelper(iniY, factor, decay);
			this._easeZ = new SpringEasingHelper(iniZ, factor, decay);
		}
		
		public function update(newX:Number, newY:Number, newZ:Number):void {
			_easeX.update(newX);
			_easeY.update(newY);
			_easeZ.update(newZ);
		}
		
		public function get currentX():Number {
			return _easeX.current;
		}
		
		public function get currentY():Number {
			return _easeY.current;
		}
		
		public function get currentZ():Number {
			return _easeZ.current;
		}
		
		public function get factor():Number {
			return _easeX.factor;
		}
		
		public function set factor(newVal:Number):void {
			_easeX.factor = _easeY.factor = _easeZ.factor = newVal;
		}
		
		public function get decay():Number {
			return _easeX.decay;
		}
		
		public function set decay(newVal:Number):void {
			_easeX.decay = _easeY.decay = _easeZ.decay = newVal;
		}
		
		public function toString():String {
			return '[Point3DSpringEasingHelper: X=' + currentX + ', Y=' + currentY + ', Z' + currentZ + ', factor=' + factor + ', decay=' + decay + ']';
		}
	}
}
