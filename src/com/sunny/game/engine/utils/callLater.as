package com.sunny.game.engine.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 延时调用函数
	 *
	 */
	public function callLater(func : Function, timeDelay : int, ... arg) : void
	{
		var timer : Timer = new Timer(timeDelay, 1);
		timer.addEventListener(TimerEvent.TIMER, function(e : TimerEvent) : void
		{
			func.apply(null, arg);
		}, false, 0, true);
		timer.start();
	}
}