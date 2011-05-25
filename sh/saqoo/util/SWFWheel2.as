package sh.saqoo.util {

	import org.osflash.signals.Signal;

	import flash.external.ExternalInterface;
	
	/**
	 * SWFWheel alternative which supports horizontal mouse wheel scroll.
	 * @see http://flexamphetamine.blogspot.com/2010/03/horizontal-mouse-wheel-swipe-gesture.html
	 */
	public class SWFWheel2 {
		
		
		private static const _sig:Signal = new Signal(Number, Number);

		
		public static function init():Boolean {
			if (!ExternalInterface.available || !ExternalInterface.objectID) return false;
			
			ExternalInterface.call('eval', SCROLL_SCRIPT);
			ExternalInterface.call('eval', 'setupScrolling("' + ExternalInterface.objectID + '");');
			ExternalInterface.call('eval', 'true;');
			ExternalInterface.addCallback('scrollEvent', _sig.dispatch);
			return true;
		}


		public static function add(listener:Function):Function { return _sig.add(listener); }
		public static function remove(listener:Function):Function { return _sig.remove(listener); }
		public static function removeAll():void { _sig.removeAll(); }


		private static const SCROLL_SCRIPT:String = (<![CDATA[
			function setupScrolling(objectID) {
				var flashObject = document.getElementsByName(objectID)[0];
				var eventListenerObject = flashObject;
				var isWebkit = false;
			
				if (navigator && navigator.vendor) {
					isWebkit = navigator.vendor.match("Apple") || navigator.vendor.match("Google");
				}
			
				// some events will need to point to the containing object tag
				if (isWebkit && flashObject.parentNode.tagName.toLowerCase() == "object") {
					eventListenerObject = flashObject.parentNode;
				}
			
				var scrollHandler = function (event) {
						var xDelta = 0;
						var yDelta = 0;
			
						// IE special case
						if (!event) event = window.event;
			
						// IE/Webkit/Opera
						if (event.wheelDelta) {
							// horizontal scrolling is supported in Webkit
							if (event.wheelDeltaX) {
								// Webkit can scroll two directions simultaneously
								xDelta = event.wheelDeltaX;
								yDelta = event.wheelDeltaY;
							} else {
								// fallback to standard scrolling interface
								yDelta = event.wheelDelta;
							}
			
							// you'll have to play with these,
							// browsers on Windows and OS X handle them differently
							xDelta /= 120;
							yDelta /= 120;
			
							// Opera special case
							if (window.opera) {
								yDelta = -yDelta;
								// Opera doesn't support hscroll; vscroll is also buggy
							}
						}
						// Firefox (Mozilla)
						else if (event.detail) {
							yDelta = -event.detail / 1.5;
							// hscroll supported in FF3.1+
							if (event.axis) {
								if (event.axis == event.HORIZONTAL_AXIS) {
									// FF can only scroll one dirction at a time
									xDelta = yDelta;
									yDelta = 0;
								}
							}
						}
			
						try {
							flashObject.scrollEvent(xDelta, yDelta);
						} catch (e) {};
			
						if (event.preventDefault) event.preventDefault();
						event.returnValue = false;
					}
			
				if (window.addEventListener) {
					// not IE
					eventListenerObject.addEventListener('mouseover', function (e) {
						if (isWebkit) {
							window.onmousewheel = scrollHandler;
						} else {
							window.addEventListener("DOMMouseScroll", scrollHandler, false);
						}
					}, false);
				} else {
					// IE
					flashObject.onmouseover = function (e) {
						document.onmousewheel = scrollHandler;
					};
				}
			}
		]]>).toString();
	}
}
