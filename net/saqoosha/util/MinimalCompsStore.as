package net.saqoosha.util {
	import net.saqoosha.logging.dump;

	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.InputText;
	import com.bit101.components.RadioButton;
	import com.bit101.components.RotarySelector;
	import com.bit101.components.Slider;
	import com.bit101.components.UISlider;

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
			var prop:String;
			var event:Event;
			switch (true) {
				case comp is InputText:
					prop = 'text';
					event = new Event(Event.CHANGE);
					comp.addEventListener(Event.CHANGE, _onChange);
					break;
				case comp is Slider:
				case comp is UISlider:
				case comp is ColorChooser:
					prop = 'value';
					event = new Event(Event.CHANGE);
					comp.addEventListener(Event.CHANGE, _onChange);
					break;
				case comp is CheckBox:
				case comp is RadioButton:
					prop = 'selected';
					event = new MouseEvent(MouseEvent.CLICK);
					comp.addEventListener(MouseEvent.CLICK, _onChange);
					break;
				case comp is RotarySelector:
					prop = 'choice';
					event = new Event(Event.CHANGE);
					comp.addEventListener(Event.CHANGE, _onChange);
					break;
				default:
					throw new Error('MinimalCompsStore only supports InputText, Slider, UISlider, ColorChooser, CheckBox, RadioButton and RotarySelector.');
					break;
			}
			if (!(_so.data[name] === undefined)) {
				trace('Restore:', getQualifiedClassName(comp) + '.' + prop + ' (' + name + ') = ' + _so.data[name]);
				comp[prop] = _so.data[name];
				comp.dispatchEvent(event);
			}
			_compInfo[comp] = {name:name, prop:prop};
		}

		
		private function _onChange(e:Event):void {
			_changed[e.currentTarget] = true;
			_timer.reset();
			_timer.start();
		}

		
		private function _onTimer(e:TimerEvent):void {
			for (var comp:* in _changed) {
				var name:String = _compInfo[comp].name;
				var prop:String = _compInfo[comp].prop;
				_so.data[name] = comp[prop];
				trace('Save:', getQualifiedClassName(comp) + '.' + prop + ' (' + name + ') = ' + _so.data[name]);
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
