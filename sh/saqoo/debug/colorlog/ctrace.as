package sh.saqoo.debug.colorlog {


	public function ctrace(color:*, ...args):void {
		ColorLog.setColor.apply(null, color);
		ColorLog.out.apply(null, args);
		ColorLog.flush();
	}
}
