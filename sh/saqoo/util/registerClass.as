package sh.saqoo.util {

	import flash.net.registerClassAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @see http://jafferhaider.wordpress.com/2009/10/18/the-complete-solution-for-implementing-a-deep-copy-clone-method-in-actionscript-3/
	 */
	public function registerClass(object:*, ...args):void {
		var objs:Array = [object];
		if (args.length) objs = objs.concat(args);
		for each (var o:* in objs) {
			var qualifiedClassName:String = getQualifiedClassName(o).replace('::', '.');
			trace('registerClassAlias:', qualifiedClassName);
			registerClassAlias(qualifiedClassName, getDefinitionByName(qualifiedClassName) as Class);
		}
	}
}
