package net.saqoosha.util {
	
	import flash.display.SimpleButton;
	
	public function getSimpleButtonByLinkageId(id:String):SimpleButton {
		return new (getDefinitionByName(id))();
	}
	
}