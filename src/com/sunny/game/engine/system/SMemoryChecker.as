package com.sunny.game.engine.system
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.utils.core.STimeControl;

	import flash.events.Event;
	import flash.system.System;

	/**
	 * 内存检测类
	 *
	 *
	 *
	 */
	public class SMemoryChecker
	{
		private static var instance : SMemoryChecker;

		public static function getInstance() : SMemoryChecker
		{
			if (instance == null)
				instance = new SMemoryChecker();
			return instance;
		}
		/**
		 * 是否可以清理内存，一般过场景的时候不能清理
		 */
		public var enable : Boolean = true;
		/**
		 * 清理释放内存
		 */
		public static const CALL_CLEAR_MEMORY : String = "CALL_CLEAR_MEMORY";

		/**
		 * 根据时间清理内存
		 */
		public static const CLEAR_MEMORY_BY_TIME : String = "CLEAR_MEMORY_BY_TIME";

		private var timer_id : int;

		private var clearMemoryFunction : Function;

		private var checkTimes : uint = 0;

		public function get status() : String
		{
			return enable + "," + SShellVariables.isPrimordial + "," + checkTimes;
		}

		/**
		 * 开始检测
		 * @param interval
		 *
		 */
		private function start() : void
		{
			//15秒检测一次是否有闲置对象
			STimeControl.setTimer(clearMemoryByTime, 15000);
		}

		/**
		 * 清理清理需要用到的函数
		 * @param fun
		 *
		 */
		public function setClearMemoryFunction(fun : Function) : void
		{
			if (clearMemoryFunction == null)
			{
				clearMemoryFunction = fun;
				start();
			}
		}

		/**
		 * 根据时间清理内存
		 *
		 */
		public function clearMemoryByTime() : void
		{
			if (enable)
			{
				SDebug.debugPrint(null, "暂时不可清理内存");
				return;
			}

			if (SShellVariables.isPrimordial)
				SEvent.dispatchEvent(CLEAR_MEMORY_BY_TIME);
			checkTimes++;
			//如果超过900M，则手动清理一次
			if (System.totalMemory >= 900000000)
			{
				clearMemory();
			}
			if (clearList.length > 0)
			{
				startClearTimer();
			}
		}

		public function clearMemory() : void
		{
			if (enable)
			{
				SDebug.debugPrint(null, "暂时不可清理内存");
				return;
			}
			SEvent.dispatchEvent(CALL_CLEAR_MEMORY);
			startClearTimer();
		}

		private function startClearTimer() : void
		{
			stopClearTimer();
			if (timer_id == 0)
				timer_id = STimeControl.setTimer(clearComplete, 100);
		}

		public function get clearNum() : int
		{
			return clearList.length;
		}

		private function stopClearTimer() : void
		{
			if (timer_id > 0 && clearList.length == 0)
			{
				STimeControl.clearTimer(timer_id);
				timer_id = 0;
			}
		}
		/**
		 * 销毁队列
		 */
		private var clearList : Vector.<Object> = new Vector.<Object>();
		/**
		 * 每次销毁的数量
		 */
		private var clearCount : int = 20;

		public function addClearFun(type : String, res : String) : void
		{
			clearList.push({type: type, res: res});
		}

		private function clearComplete(event : Event = null) : void
		{
			if (enable)
			{
				SDebug.debugPrint(null, "暂时不可清理内存");
				return;
			}

			if (clearMemoryFunction == null)
				SDebug.errorPrint(null, "clearMemoryFunction=null");
			var len : int = clearList.length;
			if (len > 0)
			{
				var clear_target : Object;
				len = Math.min(len, clearCount);

				for (var i : int = 0; i < len; i++)
				{
					clear_target = clearList[i];
					if (clear_target == null)
						continue;
					clearMemoryFunction(clear_target.type, clear_target.res);
				}
				clearList.splice(0, clearCount);
				return;
			}
			//没有可清理的，则清楚计时器
			stopClearTimer();
		}
	}
}