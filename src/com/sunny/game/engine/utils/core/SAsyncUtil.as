package com.sunny.game.engine.utils.core
{
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 *
	 * <p>
	 * SunnyGame的一个异步循环方法SAsynchronousUtil
	 * </p>
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public final class SAsyncUtil
	{
		/**
		 * 执行间隔毫秒数，应当是一个小于1000/帧频的值
		 */
		public static var asynInv : int = 10;

		/**
		 * 自动设置执行间隔
		 *
		 * @param stage	舞台实例
		 * @param idleTime	空闲时间
		 * @return
		 *
		 */
		public static function autoSetInv(stage : Stage, idleTime : int = 5) : int
		{
			asynInv = 1000 / stage.frameRate - idleTime;
			return asynInv;
		}

		/**
		 * 执行For
		 *
		 * @param fun	每个循环节执行的方法
		 * @param fromValue	起始值
		 * @param toValue	结束值
		 * @param completeHandler	完成后方法
		 * @return
		 *
		 */
		public static function asynFor(fun : Function, fromValue : int, toValue : int, completeHandler : Function = null) : Timer
		{
			var timer : Timer = new Timer(0, int.MAX_VALUE);
			timer.addEventListener(TimerEvent.TIMER, asynHandler);

			var i : int = fromValue;
			timer.start();
			return timer;

			function asynHandler(event : TimerEvent) : void
			{
				var t : int = getTimer();
				while (getTimer() - t < asynInv)
				{
					if (i < toValue)
					{
						fun(i);
						i++;
					}
					else
					{
						timer.removeEventListener(TimerEvent.TIMER, asynHandler);
						timer.stop();

						if (completeHandler != null)
							completeHandler();

						break;
					}
				}
			}
		}

		/**
		 * 执行While
		 *
		 * @param fun	每个循环节执行的方法
		 * @param endFun	此函数返回false时结束循环
		 * @param completeHandler	完成后方法
		 * @return
		 *
		 */
		public static function asynWhile(fun : Function, endFun : Function, completeHandler : Function = null) : Timer
		{
			var timer : Timer = new Timer(0, int.MAX_VALUE);
			timer.addEventListener(TimerEvent.TIMER, asynHandler);
			timer.start();
			return timer;

			function asynHandler(event : TimerEvent) : void
			{
				var t : int = getTimer();
				while (getTimer() - t < asynInv)
				{
					if (!endFun())
					{
						fun()
					}
					else
					{
						timer.removeEventListener(TimerEvent.TIMER, asynHandler);
						timer.stop();

						if (completeHandler != null)
							completeHandler();

						break;
					}
				}
			}
		}
	}
}