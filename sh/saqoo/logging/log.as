package sh.saqoo.logging {
	import sh.saqoo.debug.mtrace;
	import sh.saqoo.util.ArrayUtil;

	import flash.utils.getQualifiedClassName;
	
	
	public function log(caller:*, ...args):void {
		if (args && !(args[0] is String)) {
			mtrace.apply(null, args);
		} else {
			var arr:Array = ArrayUtil.fromArguments(args);
			var className:String = caller ? getQualifiedClassName(caller).replace('::', '.') : '';
			arr.unshift('[' + className + ']');
			mtrace.apply(null, arr);
		}
	}
}
