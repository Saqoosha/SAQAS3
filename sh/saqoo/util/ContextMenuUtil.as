package sh.saqoo.util {

	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * @author Saqoosha
	 */
	public class ContextMenuUtil {
		
		
		public static function build(listener:Function, labels:Array, hideBuiltInItems:Boolean = true):ContextMenu {
			var cm:ContextMenu = new ContextMenu();
			if (hideBuiltInItems) cm.hideBuiltInItems();
			var items:Array = [];
			var separateBefore:Boolean = false;
			for each (var label:String in labels) {
				if (!label) {
					separateBefore = true;
					continue;
				}
				var itm:ContextMenuItem = new ContextMenuItem(label);
				itm.separatorBefore = separateBefore;
				itm.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, listener);
				items.push(itm);
				separateBefore = false;
			}
			cm.customItems = items;
			return cm;
		}
	}
}
