package com.sunny.game.engine.utils.core
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class STimeControl
	{
		/**
		 *计时器
		 */
		private var timer : Timer;
		/**
		 *更新延迟
		 */
		private var delay : uint;
		/**
		 *需要更新列表
		 */
		private var list : Dictionary;
		/**
		 *每个元素都有一个id
		 */
		private var id : uint = 1;
		private var totalTime : uint;
		/**
		 *计时器更新间隔
		 */
		private const DELAY : uint = int(1000 / 60);

		/**
		 * 当前计时器数量
		 */
		private var m_count : int = 0;

		private static var instance : STimeControl;

		public function STimeControl()
		{
			if (instance != null)
			{
				throw new Error("单例");
			}
			init();
		}

		public static function getInstance() : STimeControl
		{
			if (instance == null)
			{
				instance = new STimeControl();
			}
			return instance;
		}

		private function init() : void
		{
			list = new Dictionary();
			timer = new Timer(DELAY);
			timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
		}

		/**
		 *更新列表
		 * @param evt
		 *
		 */
		private function onTimerEvent(evt : TimerEvent) : void
		{
			delay = getTimer() - totalTime;
			totalTime = getTimer();
			var timeData : TimeData;
			for (var key : * in list)
			{
				timeData = list[key];
				if (timeData.isStop)
				{
					removeRegisterById(key);
					continue;
				}
				timeData.update(delay);
			}
		}

		/**
		 *注册延时执行
		 * @param handler 执行函数
		 * @param delay 间隔时间
		 * @param duration 执行次数
		 * @param list 函数参数
		 *
		 */
		public function register(handler : Function, delay : int, count : int, array : Array) : int
		{
			if (m_count == 0)
				start();
			var timeId : int = ++id;
			list[timeId] = new TimeData(handler, delay, count, array);
			m_count++;
			return timeId;
		}

		/**
		 * 根据次数实行
		 * @param handle
		 * @param delay
		 * @param count
		 * @param args
		 * @return
		 *
		 */
		public static function setInterval(handle : Function, delay : uint, count : uint, ... args) : uint
		{
			if (instance == null)
				getInstance();
			return instance.register(handle, delay, count, args);
		}

		/**
		 *只执行一次
		 * @param handle
		 * @param delay
		 * @param duration
		 * @param args
		 * @return
		 *
		 */
		public static function setTimeOut(handle : Function, delay : uint, ... args) : uint
		{
			if (instance == null)
				getInstance();
			return instance.register(handle, delay, 1, args);
		}

		/**
		 *无限次数执行
		 * @param handle
		 * @param delay
		 * @param duration
		 * @param args
		 * @return
		 *
		 */
		public static function setTimer(handle : Function, delay : uint, ... args) : uint
		{
			if (instance == null)
				getInstance();
			return instance.register(handle, delay, 0, args);
		}

		/**
		 *清除节点
		 * @param timerId
		 *
		 */
		public static function clearTimer(timerId : uint) : void
		{
			if (instance == null)
				getInstance();
			instance.removeRegisterById(timerId);
		}

		/**
		 *移除注册点
		 * @param _id
		 *
		 */
		private function removeRegisterById(_id : uint) : void
		{
			if (list.hasOwnProperty(_id))
			{
				list[_id].destroy();
				list[_id] = null;
				delete list[_id];
				m_count--;
			}
			if (m_count == 0)
				stop();
		}

		/**
		 *开始
		 *
		 */
		public function start() : void
		{
			timer.start();
			totalTime = getTimer();
		}

		/**
		 *停止
		 *
		 */
		public function stop() : void
		{
			timer.stop();
		}

		/**
		 *销毁
		 *
		 */
		public function destroy() : void
		{
			timer.removeEventListener(TimerEvent.TIMER, onTimerEvent);
			list = null;
		}

	}
}

class TimeData
{
	/**
	 *需要执行函数
	 */
	private var runFunc : Function;
	/**
	 *间隔
	 */
	private var delay : uint;
	/**
	 *当前间隔
	 */
	private var updateTime : uint = 0;
	/**
	 *当前次数
	 */
	private var currTimes : uint = 0;
	/**
	 *总次数，0表示无限
	 */
	private var endTimes : uint;
	private var parameters : Array;

	public function TimeData(runFunc : Function, delay : uint, count : uint = 0, parameters : Array = null)
	{
		this.runFunc = runFunc;
		this.delay = delay;
		this.endTimes = count;
		this.parameters = parameters;
	}

	/**
	 *是否停止
	 * @return
	 *
	 */
	internal function get isStop() : Boolean
	{
		if (endTimes == 0 || currTimes < endTimes)
		{
			return false;
		}
		return true;
	}

	/**
	 *更新队列
	 * @param _delay
	 *
	 */
	internal function update(_delay : uint) : void
	{
		if (runFunc == null)
		{
			currTimes = endTimes;
			return;
		}
		updateTime += _delay;
		if (updateTime < delay)
			return;
		updateTime %= delay;
		runFunc.apply(null, parameters);
		currTimes++;
	}

	/**
	 *销毁
	 *
	 */
	internal function destroy() : void
	{
		runFunc = null;
		parameters = null;
	}
}