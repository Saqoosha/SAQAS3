package sh.saqoo.debug {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;

	
	/**
	 * Ported from cinder.
	 * @author Saqoosha
	 */
	public class ArcBall extends Sprite {
		
		
		private var _target:DisplayObject;
		private var _radius:Number;
		private var _enabled:Boolean;
		private var _debug:Boolean;
		
		private var _components:Vector.<Vector3D>;
		private var _iniMouse:Vector3D;
		private var _iniQuat:Vector3D;

		
		public function ArcBall(target:DisplayObject, radius:Number = 300) {
			this.target = target;
			this.radius = radius;
			this.enabled = true;
			this.debug = false;
			
			_iniMouse = new Vector3D();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
		}

		
		private function _calcSpherePoint(px:Number, py:Number, result:Vector3D):void {
			result.x = -px / (_radius * 2);
			result.y = -py / (_radius * 2);
			result.z = 0;
			var mag:Number = result.lengthSquared;
			if (mag > 1) {
				result.normalize();
			} else {
				result.z = Math.sqrt(1 - mag);
				result.normalize();
			}
		}

		
		private function _mulQuats(a:Vector3D, b:Vector3D, result:Vector3D):void {
			result.x = b.w * a.x + b.x * a.w + b.y * a.z - b.z * a.y;
			result.y = b.w * a.y + b.y * a.w + b.z * a.x - b.x * a.z;
			result.z = b.w * a.z + b.z * a.w + b.x * a.y - b.y * a.x;
			result.w = b.w * a.w - b.x * a.x - b.y * a.y - b.z * a.z;
		}

		
		private function _onAddedToStage(event:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);		}

		
		private function _onRemovedFromStage(event:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}

		
		private function _onMouseDown(event:MouseEvent):void {
			if (!_enabled) return;
			_calcSpherePoint(mouseX, mouseY, _iniMouse);
			_components = _target.transform.matrix3D.decompose(Orientation3D.QUATERNION);
			_iniQuat = _components[1].clone();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}

		
		private var to:Vector3D = new Vector3D();
		private function _onMouseMove(event:MouseEvent):void {
			_calcSpherePoint(mouseX, mouseY, to);
			var rot:Vector3D = _iniMouse.crossProduct(to);
			rot.w = _iniMouse.dotProduct(to);
			_mulQuats(_iniQuat, rot, _components[1]);
			_target.transform.matrix3D.recompose(_components, Orientation3D.QUATERNION);
		}

		
		private function _onMouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		
		public function get target():DisplayObject { return _target; }
		public function set target(value:DisplayObject):void {
			if (_target != value) {
				_target = value;
				_target.transform.matrix3D ||= new Matrix3D();
			}
		}
		
		public function get radius():Number { return _radius; }
		public function set radius(value:Number):void {
			if (_radius != value) {
				_radius = value;
				graphics.clear();
				graphics.beginFill(0x00ffff, 0.3);
				graphics.drawCircle(0, 0, _radius);
				graphics.endFill();
			}
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void { _enabled = value; }
		
		public function get debug():Boolean { return _debug; }
		public function set debug(value:Boolean):void { 
			_debug = value;
			visible = _debug;
		}
	}
}
