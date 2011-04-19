package sh.saqoo.minimalcomps {

	import fl.motion.easing.*;

	import com.bit101.components.ComboBox;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Saqoosha
	 */
	public class EasingComboBox extends ComboBox {
		
		
		public static const EASINGS:Array = [
			{label: 'Linear.easeNone', func: Linear.easeNone},
			{label: 'Sine.easeIn', func: Sine.easeIn},
			{label: 'Sine.easeOut', func: Sine.easeOut},
			{label: 'Sine.easeInOut', func: Sine.easeInOut},
			{label: 'Quadratic.easeIn', func: Quadratic.easeIn},
			{label: 'Quadratic.easeOut', func: Quadratic.easeOut},
			{label: 'Quadratic.easeInOut', func: Quadratic.easeInOut},
			{label: 'Cubic.easeIn', func: Cubic.easeIn},
			{label: 'Cubic.easeOut', func: Cubic.easeOut},
			{label: 'Cubic.easeInOut', func: Cubic.easeInOut},
			{label: 'Quartic.easeIn', func: Quartic.easeIn},
			{label: 'Quartic.easeOut', func: Quartic.easeOut},
			{label: 'Quartic.easeInOut', func: Quartic.easeInOut},
			{label: 'Quintic.easeIn', func: Quintic.easeIn},
			{label: 'Quintic.easeOut', func: Quintic.easeOut},
			{label: 'Quintic.easeInOut', func: Quintic.easeInOut},
			{label: 'Exponential.easeIn', func: Exponential.easeIn},
			{label: 'Exponential.easeOut', func: Exponential.easeOut},
			{label: 'Exponential.easeInOut', func: Exponential.easeInOut},
			{label: 'Circular.easeIn', func: Circular.easeIn},
			{label: 'Circular.easeOut', func: Circular.easeOut},
			{label: 'Circular.easeInOut', func: Circular.easeInOut},
			{label: 'Elastic.easeIn', func: Elastic.easeIn},
			{label: 'Elastic.easeOut', func: Elastic.easeOut},
			{label: 'Elastic.easeInOut', func: Elastic.easeInOut},
			{label: 'Back.easeIn', func: Back.easeIn},
			{label: 'Back.easeOut', func: Back.easeOut},
			{label: 'Back.easeInOut', func: Back.easeInOut},
			{label: 'Bounce.easeIn', func: Bounce.easeIn},
			{label: 'Bounce.easeOut', func: Bounce.easeOut},
			{label: 'Bounce.easeInOut', func: Bounce.easeInOut}
		];


		public function get selectedEasing():Function { return selectedItem ? selectedItem.func : Linear.easeNone; }


		public function EasingComboBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) {
			super(parent, xpos, ypos, EASINGS[0].label, EASINGS);
			width = 120;
		}
	}
}
