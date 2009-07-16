package net.saqoosha.gui {
	
	import de.popforge.parameter.Parameter;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Slider extends Sprite {
		
		private static const MIN_WIDTH:uint = 200;
		private static const KNOB_WIDTH:uint = 25;
		private static const LABEL_WIDTH:uint = 50;
		private static const INPUT_FIELD_WIDTH:uint = 40;
		
		private var _base:Shape;
		private var _knob:Sprite;
		private var _label:TextField;
		private var _inputField:TextField;
		
		private var _param:Parameter;
		private var _width:int;
		private var _so:SharedObject;
		private var _dragOffset:Number;
		
		public function Slider(param:Parameter, w:int = MIN_WIDTH, label:String = '', so:SharedObject = null) {
			this._param = param;
			this._param.addChangedCallbacks(this.parameterChangeHandler);
			this._width = w;
			
			this._base = this.addChild(new Shape()) as Shape;
			var g:Graphics = this._base.graphics;
			g.beginFill(0x5f5f5f);
			g.drawRoundRect(0, 0, this._width, 18, 10, 10);
			g.endFill();
			g.beginFill(0xdbdbdb);
			g.drawRoundRect(3 + LABEL_WIDTH + 3, 3, this._width - (3 + LABEL_WIDTH + 3 + 3 + INPUT_FIELD_WIDTH + 3), 12, 6, 6);
			g.endFill();
			g.beginFill(0x888888);
			g.drawRoundRect(this._width - 3 - INPUT_FIELD_WIDTH, 3, INPUT_FIELD_WIDTH, 12, 6, 6);
			g.endFill();
			
			this._label = this.addChild(new TextField()) as TextField;
			this._label.x = 3 + 2;
			this._label.y = 1;
			this._label.width = LABEL_WIDTH - 2;
			this._label.height = 16;
			this._label.autoSize = TextFieldAutoSize.NONE;
			this._label.defaultTextFormat = new TextFormat('Verdana', 10, 0xffffff, null, null, null, null, null, TextFormatAlign.RIGHT);
			this._label.text = label;
			
			this._knob = this.addChild(new Sprite()) as Sprite;
			g = this._knob.graphics;
			g.beginFill(0x5f5f5f);
			g.drawRoundRect(0, 0, KNOB_WIDTH, 10, 6, 6);
			g.endFill();
			this._knob.x = 3 + LABEL_WIDTH + 3 + 1;
			this._knob.y = 4;
			this._knob.addEventListener(MouseEvent.MOUSE_DOWN, this.knobMouseDownHandler);
			
			this._inputField = this.addChild(new TextField()) as TextField;
			this._inputField.x = this._width - 3 - INPUT_FIELD_WIDTH + 2;
			this._inputField.y = 1;
			this._inputField.width = INPUT_FIELD_WIDTH - 4;
			this._inputField.height = 16;
			this._inputField.autoSize = TextFieldAutoSize.NONE;
			this._inputField.type = TextFieldType.INPUT;
			this._inputField.defaultTextFormat = new TextFormat('Verdana', 10, 0xffffff);
			this._inputField.addEventListener(FocusEvent.FOCUS_IN, this.valueFocusInHandler);
			this._inputField.addEventListener(FocusEvent.FOCUS_OUT, this.valueFocusOutHandler);
			
			this._so = so;
			var val:* = this._so && this._so.data[label] != undefined ? this._so.data[label] : this._param.getValue();
			this._param.setValue(val);
			this.parameterChangeHandler(this._param, val, val);
		}
		
		private function valueFocusInHandler(e:FocusEvent):void {
			this._inputField.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
		}
		
		private function valueFocusOutHandler(e:FocusEvent):void {
			this._inputField.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
			this.inputFieldToValue();
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			if (e.keyCode == 13) {
				this.inputFieldToValue();
			}
		}
		
		private function parameterChangeHandler(parameter:Parameter, oldValue:*, newValue:*):void {
			this._knob.x = this._param.getValueNormalized() * (this._width - (3 + LABEL_WIDTH + 3 + 1 + KNOB_WIDTH + 1 + 3 + INPUT_FIELD_WIDTH + 3)) + 3 + LABEL_WIDTH + 3 + 1;
			this._inputField.text = this._param.getValue();
			if (this._so) {
				this._so.data[this._label.text] = this._param.getValue();
			}
		}
		
		private function knobMouseDownHandler(e:MouseEvent):void {
			this._dragOffset = this._knob.mouseX;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stageMouseMoveHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this.stageMouseUpHandler);
			this.stageMouseMoveHandler(null);
		}
		
		private function stageMouseMoveHandler(e:MouseEvent):void {
			var val:Number = (this.mouseX - this._dragOffset - (3 + LABEL_WIDTH + 3 + 1)) / (this._width - (3 + LABEL_WIDTH + 3 + 1 + KNOB_WIDTH + 1 + 3 + INPUT_FIELD_WIDTH + 3));
			this._param.setValueNormalized(val < 0 ? 0 : val > 1 ? 1 : val);
		}
		
		private function stageMouseUpHandler(e:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stageMouseMoveHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stageMouseUpHandler);
		}
		
		private function inputFieldToValue():void {
			var val:Number = parseFloat(this._inputField.text);
			if (!isNaN(val)) {
				this._param.setValue(val);
				val = this._param.getValueNormalized();
				this._param.setValueNormalized(val < 0 ? 0 : val > 1 ? 1 : val);
			}
			this._inputField.text = this._param.getValue();
			this._inputField.scrollH = 0;
		}
		
		public function get parameter():Parameter {
			return this._param;
		}
		
		public function get value():* {
			return this._param.getValue();
		}
		
	}
	
}