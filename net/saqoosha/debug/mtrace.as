package net.saqoosha.debug{
	import nl.demonsters.debugger.MonsterDebugger;


	public function mtrace(...args):void {
		MonsterDebugger.trace(null, (args.length == 1) ? args[0] : args.join(' '));
	}
}
