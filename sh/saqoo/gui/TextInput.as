package sh.saqoo.gui {
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	[Event( name="change", type="flash.events.Event" )]

	public class TextInput extends Sprite {
		
		private static const MIN_WIDTH:uint = 200;
		private static const LABEL_WIDTH:uint = 50;
		
		private var _width:int;
		private var _so:SharedObject;
		private var _base:Shape;
		private var _label:TextField;
		private var _inputField:TextField;
		
		public function TextInput(defText:String, width:int = MIN_WIDTH, name:String = '', so:SharedObject = null) {
			this._width = width;
			
			this._base = this.addChild(new Shape()) as Shape;
			var g:Graphics = this._base.graphics;
			g.beginFill(0x5f5f5f);
			g.drawRoundRect(0, 0, this._width, 18, 10, 10);
			g.endFill();
			g.beginFill(0x888888);
			g.drawRoundRect(3 + LABEL_WIDTH + 3, 3, this._width - (3 + LABEL_WIDTH + 3 + 3), 12, 6, 6);
			g.endFill();
			
			this._label = this.addChild(new TextField()) as TextField;
			this._label.x = 3 + 2;
			this._label.y = 1;
			this._label.width = LABEL_WIDTH - 2;
			this._label.height = 16;
			this._label.autoSize = TextFieldAutoSize.NONE;
			this._label.defaultTextFormat = new TextFormat('Verdana', 10, 0xffffff, null, null, null, null, null, TextFormatAlign.RIGHT);
			this._label.text = name;
			
			this._inputField = this.addChild(new TextField()) as TextField;
			this._inputField.x = 3 + LABEL_WIDTH + 3 + 2;
			this._inputField.y = 1;
			this._inputField.width = this._width - (3 + LABEL_WIDTH + 3 + 3) - 4;
			this._inputField.height = 16;
			this._inputField.autoSize = TextFieldAutoSize.NONE;
			this._inputField.type = TextFieldType.INPUT;
			this._inputField.defaultTextFormat = new TextFormat('Verdana', 10, 0xffffff);
			this._inputField.addEventListener(Event.CHANGE, this._onTextChange);

			this._so = so;
			this._inputField.text = this._so && this._so.data[name] != undefined ? this._so.data[name] : defText;
		}
		
		private function _onTextChange(e:Event = null):void {
			if (this._so) {
				this._so.data[this._label.text] = this._inputField.text;
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get text():String {
			return this._inputField.text;
		}
		
		public function set text(t:String):void {
			var prev:String = this._inputField.text;
			this._inputField.text = t;
			if (prev != t) {
				this._onTextChange();
			}
		}
		
	}
	
}