package sh.saqoo.util {
	import flash.net.registerClassAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @see http://jafferhaider.wordpress.com/2009/10/18/the-complete-solution-for-implementing-a-deep-copy-clone-method-in-actionscript-3/
	 */
	public function registerClass(object:*):void {
		var qualifiedClassName:String = getQualifiedClassName(object).replace('::', '.'); 
        registerClassAlias(qualifiedClassName, getDefinitionByName(qualifiedClassName) as Class);
	}
}
