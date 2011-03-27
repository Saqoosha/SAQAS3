package sh.saqoo.logging {

	import sh.saqoo.util.ObjectDumper;

	/**
	 * @author Saqoosha
	 */
	public function dump(...args:*):void {
		if (args.length == 1) {
			ObjectDumper.dump(args[0]);
		} else {
			ObjectDumper.dump(args);
		}
	}
}
