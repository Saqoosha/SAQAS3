package net.saqoosha.pv3d.util {
	import com.bit101.components.HUISlider;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	
	/**
	 * @author hiko
	 */
	public class DO3DManipulator extends Window {

		
		private var _target:*;
		
		private var _posX:HUISlider;
		private var _posY:HUISlider;
		private var _posZ:HUISlider;
		private var _rotX:HUISlider;
		private var _rotY:HUISlider;
		private var _rotZ:HUISlider;
		private var _scaleX:HUISlider;
		private var _scaleY:HUISlider;
		private var _scaleZ:HUISlider;
		
		private var _positionRange:Number = 20;
		private var _scaleMax:Number = 5;
		private var _linkScale:Boolean = true;

		
		public function DO3DManipulator(parent:DisplayObjectContainer, target:*) {
			super(parent, 10, 10, 'DO3DManipulator');
			_target = target;
			
			var vbox:VBox = new VBox(content, 5, 5);
			vbox.spacing = 0;
			_posX = new HUISlider(vbox, 0, 0, 'posX', _onChange);
			_posY = new HUISlider(vbox, 0, 0, 'posY', _onChange);			_posZ = new HUISlider(vbox, 0, 0, 'posZ', _onChange);
			_posX.tick = _posY.tick = _posZ.tick = 0.01;
			_posX.labelPrecision = _posY.labelPrecision = _posZ.labelPrecision = 2;
			positionRange = 20;
			_posX.value = _target.x;
			_posY.value = _target.y;
			_posZ.value = _target.z;
			_posX.width = _posY.width = _posZ.width = 300;
			
			_rotX = new HUISlider(vbox, 0, 0, 'rotX', _onChange);			_rotY = new HUISlider(vbox, 0, 0, 'rotY', _onChange);			_rotZ = new HUISlider(vbox, 0, 0, 'rotZ', _onChange);
			_rotX.tick = _rotY.tick = _rotZ.tick = 0.01;
			_rotX.labelPrecision = _rotY.labelPrecision = _rotZ.labelPrecision = 2;
			_rotX.minimum = _rotY.minimum = _rotZ.minimum = -180;
			_rotX.maximum = _rotY.maximum = _rotZ.maximum = 180;
			_rotX.value = _target.rotationX;
			_rotY.value = _target.rotationY;
			_rotZ.value = _target.rotationZ;
			_rotX.width = _rotY.width = _rotZ.width = 300;
			
			_scaleX = new HUISlider(vbox, 0, 0, 'sclX', _onChange);			_scaleY = new HUISlider(vbox, 0, 0, 'sclY', _onChange);			_scaleZ = new HUISlider(vbox, 0, 0, 'sclZ', _onChange);
			_scaleX.tick = _scaleY.tick = _scaleZ.tick = 0.01;
			_scaleX.labelPrecision = _scaleY.labelPrecision = _scaleZ.labelPrecision = 2;
			_scaleX.minimum = _scaleY.minimum = _scaleZ.minimum = 0.01;
			scaleMax = 5.0;
			_scaleX.value = _target.scaleX;
			_scaleY.value = _target.scaleY;
			_scaleZ.value = _target.scaleZ;
			_scaleX.width = _scaleY.width = _scaleZ.width = 300;

			hasMinimizeButton = true;
			width = 285;
			height = 190;
			alpha = 0.9;
		}

		
		private function _onChange(event:Event):void {
			if (_linkScale) {
				switch (event.currentTarget){
					case _scaleX: _scaleY.value = _scaleZ.value = _scaleX.value; break;					case _scaleY: _scaleX.value = _scaleZ.value = _scaleY.value; break;					case _scaleZ: _scaleX.value = _scaleY.value = _scaleZ.value; break;
				}
			}
			
			_target.x = _posX.value;
			_target.y = _posY.value;
			_target.z = _posZ.value;
			_target.rotationX = _rotX.value;
			_target.rotationY = _rotY.value;
			_target.rotationZ = _rotZ.value;
			_target.scaleX = _scaleX.value;
			_target.scaleY = _scaleY.value;
			_target.scaleZ = _scaleZ.value;
		}
		
		
		public function get positionRange():Number {
			return _positionRange;
		}
		
		
		public function set positionRange(positionRange:Number):void {
			_positionRange = positionRange;
			_posX.minimum = _target.x - _positionRange;
			_posY.minimum = _target.y - _positionRange;
			_posZ.minimum = _target.z - _positionRange;
			_posX.maximum = _target.x + _positionRange;
			_posY.maximum = _target.y + _positionRange;
			_posZ.maximum = _target.z + _positionRange;
		}
		
		
		public function get scaleMax():Number {
			return _scaleMax;
		}
		
		
		public function set scaleMax(scaleMax:Number):void {
			_scaleMax = scaleMax;
			_scaleX.maximum = _scaleY.maximum = _scaleZ.maximum = _scaleMax;
		}

		
		public function get linkScale():Boolean {
			return _linkScale;
		}
		
		
		public function set linkScale(linkScale:Boolean):void {
			_linkScale = linkScale;
		}
	}
}
