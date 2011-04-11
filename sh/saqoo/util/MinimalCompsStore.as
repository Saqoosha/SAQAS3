package sh.saqoo.util {

	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.RadioButton;
	import com.bit101.components.RotarySelector;
	import com.bit101.components.Slider;
	import com.bit101.components.UISlider;
	import com.bit101.components.Window;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;


	public class MinimalCompsStore {


		public static function store(name:String, ...comps):MinimalCompsStore {
			var store:MinimalCompsStore = new MinimalCompsStore(name);
			for each (var c:* in comps) store.addComp(c);
			return store;
		}


		private var _timer:Timer;
		private var _so:SharedObject;
		private var _compInfo:Dictionary;
		private var _changed:Dictionary;


		public function MinimalCompsStore(storeName:String, saveDelay:int = 1000) {
			_timer = new Timer(saveDelay, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimer);
			_so = SharedObject.getLocal(storeName);
			_compInfo = new Dictionary(true);
			_changed = new Dictionary(true);
		}


		public function addComp(comp:*, name:String = null):void {
			name ||= comp.name;
			switch (true) {
				case comp is InputText:
					_addProp(comp, name, 'text', new Event(Event.CHANGE));
					comp.addEventListener(Event.CHANGE, _onChange);
					break;
				case comp is Slider:
				case comp is UISlider:
				case comp is ColorChooser:
					_addProp(comp, name, 'value', new Event(Event.CHANGE));
					comp.addEventListener(Event.CHANGE, _onChange);
					break;
				case comp is CheckBox:
				case comp is RadioButton:
					_addProp(comp, name, 'selected', new MouseEvent(MouseEvent.CLICK));
					comp.addEventListener(MouseEvent.CLICK, _onChange);
					break;
				case comp is RotarySelector:
					_addProp(comp, name, 'choice', new Event(Event.CHANGE));
					comp.addEventListener(Event.CHANGE, _onChange);
					break;
				case comp is Window:
					_addProp(comp, name, 'minimized', new Event(Event.RESIZE));
					comp.addEventListener(Event.RESIZE, _onChange);
					_addProp(comp, name, 'x', new Event(Event.CHANGE));
					_addProp(comp, name, 'y', new Event(Event.CHANGE));
					comp.addEventListener(Event.CHANGE, _onChange);
					break;
				default:
					throw new Error('MinimalCompsStore only supports following components: InputText, Slider, UISlider, ColorChooser, CheckBox, RadioButton, RotarySelector, Window');
					break;
			}
		}
		
		
		private function _addProp(comp:Component, name:String, prop:String, event:Event = null):void {
			var key:String = name + ':' + prop;
			if (!(_so.data[key] === undefined)) {
				trace('Restore:', getQualifiedClassName(comp).split('::').pop() + ': ' + name + '.' + prop + ' = ' + _so.data[key]);
				comp[prop] = _so.data[key];
				if (event) comp.dispatchEvent(event);
			}
			if (!_compInfo[comp]) _compInfo[comp] = new Dictionary();
			_compInfo[comp][prop] = {name: name, prop: prop, key: key};
		}


		private function _onChange(e:Event):void {
			_changed[e.currentTarget] = true;
			_timer.reset();
			_timer.start();
		}


		private function _onTimer(e:TimerEvent):void {
			for (var comp:* in _changed) {
				for (var prop:String in _compInfo[comp]) {
					var name:String = _compInfo[comp][prop].name;
					var key:String = _compInfo[comp][prop].key;
					_so.data[key] = comp[prop];
					trace('Save:', getQualifiedClassName(comp).split('::').pop() + ': ' + name + '.' + prop + ' = ' + _so.data[key]);
				}
				delete _changed[comp];
			}
			_so.flush();
		}


		public function get saveDelay():Number {
			return _timer.delay;
		}


		public function set saveDelay(value:Number):void {
			_timer.delay = value;
		}
	}
}
