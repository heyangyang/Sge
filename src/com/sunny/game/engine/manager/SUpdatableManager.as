package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.cfg.SEngineConfig;
	import com.sunny.game.engine.core.SIUpdatable;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.lang.STime;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.utils.STimer;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * 一个可更新管理器
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
	public class SUpdatableManager
	{
		private static var _instance : SUpdatableManager;

		public static function getInstance() : SUpdatableManager
		{
			if (!_instance)
				_instance = new SUpdatableManager();
			return _instance;
		}

		public static const PRIORITY_LAYER_HIGH : int = 1;
		public static const PRIORITY_LAYER_MEDIUM : int = 2;
		public static const PRIORITY_LAYER_LOW : int = 3;

		public static const EVENT_QUICKEN : String = "EVENT_QUICKEN";

		private var _lastFrameTimestamp : Number;
		private var _currFrameTimestamp : Number;

		private var _unthrottler : SFpsUnthrottler;

		private var _highPriorUpdatables : Vector.<SIUpdatable> = new Vector.<SIUpdatable>();
		private var _mediumPriorUpdatables : Vector.<SIUpdatable> = new Vector.<SIUpdatable>();
		private var _lowPriorUpdatables : Vector.<SIUpdatable> = new Vector.<SIUpdatable>();

		private var _deleteUpdatables : Array = [];
		private var _regisiterIndex : int;
		private var _timeScale : Number = 1;

		private var _isStarted : Boolean;

		public var highUpdateTime : int;
		public var mediumUpdateTime : int;
		public var lowUpdateTime : int;
		public var passedTime : int;

		/**
		 * 加速检查
		 */
		private var _quickenTimer : STimer;
		private var _quickenCount : int = 0;
		private var _prevQuickenDate : Number = 0;
		private var _prevQuickenTime : Number = 0;
		public var quickenTime : int = 0;
		public var quickenDate : int = 0;
		public var quickenMaxDelta : int = 100;
		public var quickenMaxCount : int = 3;


		public function get isStarted() : Boolean
		{
			return _isStarted;
		}

		public function SUpdatableManager()
		{
			_unthrottler = new SFpsUnthrottler();
			_quickenTimer = new STimer(1000);
		}

		public function startQuickenCheck() : void
		{
			_quickenTimer.addEventListener(TimerEvent.TIMER, quickenTimerHandler);
			_quickenTimer.reset();
			_quickenTimer.start();
			_prevQuickenTime = getTimer();
			_prevQuickenDate = new Date().getTime();
		}

		public function stopQuickenCheck() : void
		{
			_quickenTimer.removeEventListener(TimerEvent.TIMER, quickenTimerHandler);
			_quickenTimer.stop();
			_prevQuickenTime = 0;
			_prevQuickenDate = 0;
		}

		private function quickenTimerHandler(event : TimerEvent) : void
		{
			var newTime : int = getTimer();
			var newDate : Number = new Date().getTime();

			quickenTime = newTime - _prevQuickenTime;
			quickenDate = newDate - _prevQuickenDate;

			//FLASH运行的时间 差值  - 系统运行的时间差值，如果相差大于误差 则认定是开了加速了
			if (_quickenCount < quickenMaxCount && Math.abs(quickenTime - quickenDate) > quickenMaxDelta)
			{
				_quickenCount++;
				if (_quickenCount >= quickenMaxCount) //超过3次认定该客户羰正在使用加速软件 
				{
					stopQuickenCheck();
					SEvent.dispatchEvent(EVENT_QUICKEN);
				}
			}
			_prevQuickenDate = newDate;
			_prevQuickenTime = newTime;
		}

		public function set timeScale(value : Number) : void
		{
			SDebug.error("timeScale can't use");
			//_timeScale = value;
		}

		/**
		 * 注册到主驱动器中
		 * @param updatable
		 * @param priorityLayer 高-低 1 、 2 、 3
		 * @priority 优先级
		 */
		public function register(updatable : SIUpdatable, priorityLayer : int = PRIORITY_LAYER_LOW, priority : int = 0) : void
		{
			var index : int = _deleteUpdatables.indexOf(updatable);
			if (index != -1)
				_deleteUpdatables.splice(index, 1);
			updatable.notifyRegistered();
			switch (priorityLayer)
			{
				case PRIORITY_LAYER_HIGH:
					updatable.priority = priority;
					index = _highPriorUpdatables.indexOf(updatable);
					if (index > -1)
						return;
					_highPriorUpdatables.push(updatable);
					if (updatable.priority != 0)
						_highPriorUpdatables.sort(sortPriorityFunc);
					break;

				case PRIORITY_LAYER_MEDIUM:
					updatable.priority = priority;
					index = _mediumPriorUpdatables.indexOf(updatable);
					if (index > -1)
						return;
					_mediumPriorUpdatables.push(updatable);
					if (updatable.priority != 0)
						_mediumPriorUpdatables.sort(sortPriorityFunc);
					break;

				case PRIORITY_LAYER_LOW:
					updatable.priority = priority;
					index = _lowPriorUpdatables.indexOf(updatable);
					if (index > -1)
						return;
					_lowPriorUpdatables.push(updatable);
					if (updatable.priority != 0)
						_lowPriorUpdatables.sort(sortPriorityFunc);
					break;
				default:
					return;
			}
		}

		public function unregister(updatable : SIUpdatable) : void
		{
			var index : int = _deleteUpdatables.indexOf(updatable);
			if (index == -1)
			{
//				_lowPriorUpdatables.splice(index, 1);
				_deleteUpdatables.push(updatable);
				updatable.notifyUnregistered();
			}
		}

		/**
		 * 重置优先级
		 * @param updatable
		 * @param priority
		 */
		sunny_engine function changePriority(updatable : SIUpdatable, priority : int) : void
		{
			var index : int = _lowPriorUpdatables.indexOf(updatable);
			if (index != -1)
			{
				_lowPriorUpdatables.sort(sortPriorityFunc);
				return;
			}

			index = _mediumPriorUpdatables.indexOf(updatable);
			if (index != -1)
			{
				_mediumPriorUpdatables.sort(sortPriorityFunc);
				return;
			}

			index = _highPriorUpdatables.indexOf(updatable);
			if (index != -1)
			{
				_highPriorUpdatables.sort(sortPriorityFunc);
				return;
			}
		}

		/**
		 * 降序
		 * @param updatable1
		 * @param updatable2
		 * @return
		 *
		 */
		private function sortPriorityFunc(updatable1 : SIUpdatable, updatable2 : SIUpdatable) : Number
		{
			if (updatable1.priority > updatable2.priority)
			{
				return -1;
			}
			else if (updatable1.priority < updatable2.priority)
			{
				return 1;
			}
			return 0;
		}

		public function start() : void
		{
			_timeScale = 1;
			SShellVariables.nativeStage.addEventListener(Event.ENTER_FRAME, onEnterFrameUpdate, false, 0, true);
			_lastFrameTimestamp = getTimer();
			_isStarted = true;
			SUpdatableManager.getInstance().register(_unthrottler, SUpdatableManager.PRIORITY_LAYER_HIGH);
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "所有可更新对象更新状态改变 运行");
		}

		/**
		 * 停止所有的逻辑和输入处理，有效地冻结的应用程序中的当前状态。
		 *
		 */
		public function stop() : void
		{
			_timeScale = 1;
			SShellVariables.nativeStage.removeEventListener(Event.ENTER_FRAME, onEnterFrameUpdate, false);
			_isStarted = false;
			SUpdatableManager.getInstance().unregister(_unthrottler);
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "所有可更新对象更新状态改变", "停止");
		}

		private function onEnterFrameUpdate(e : Event) : void
		{
			if (_isStarted)
				nextFrame();
		}

		public var frameCount : int = 0;
		public static var FRAME_STEP : int = 2; //每隔多少帧运行一次god的Update

		/**
		 * 计算上一帧到当前通过的时间，方法 <code>nextFrame</code>在每一帧调用
		 *
		 */
		private function nextFrame() : void
		{
			SShellVariables.getTimer = _currFrameTimestamp = getTimer();
			STime.deltaTime = _currFrameTimestamp - _lastFrameTimestamp;
			_lastFrameTimestamp = _currFrameTimestamp;
			// 限制动画的基本时间，最大值不能超过1秒，超过将截断 
			if (STime.deltaTime > 1000)
				STime.deltaTime = 1000;
			update();
			passedTime = getTimer() - _currFrameTimestamp;
		}

		private function update() : void
		{
			SEngineConfig.curCharacterRenderNum = 0;
			if (_isStarted)
			{
				clearDeleteUpatables();

				highUpdateTime = updateUpdatable(_highPriorUpdatables);
				mediumUpdateTime = updateUpdatable(_mediumPriorUpdatables);
				lowUpdateTime = updateUpdatable(_lowPriorUpdatables);
			}
		}

		private var _updatablesLen : int;
		private var _currTime : int;
		private var _updatable : SIUpdatable;

		private function updateUpdatable(updatables : Vector.<SIUpdatable>) : int
		{
			_currTime = getTimer();
			_updatablesLen = updatables.length - 1;

			while (_updatablesLen >= 0)
			{
				_updatable = updatables[_updatablesLen--];
				if (_updatable == null || !_updatable.isRegistered)
					continue;

				if (_updatable.checkUpdatable())
				{
					_updatable.update();
				}
			}
			return getTimer() - _currTime;
		}

		private function clearDeleteUpatables() : void
		{
			var index : int = 0;
			var i : int = _deleteUpdatables.length;
			while (--i >= 0)
			{
				var updatable : SIUpdatable = _deleteUpdatables[i];
				if (updatable == null)
					continue;
				index = _mediumPriorUpdatables.indexOf(updatable);
				if (index != -1)
				{
					_mediumPriorUpdatables.splice(index, 1);
					continue;
				}
				index = _highPriorUpdatables.indexOf(updatable);
				if (index != -1)
				{
					_highPriorUpdatables.splice(index, 1);
					continue;
				}
				index = _lowPriorUpdatables.indexOf(updatable);
				if (index != -1)
				{
					_lowPriorUpdatables.splice(index, 1);
					continue;
				}
			}
			_deleteUpdatables.length = 0;
		}

		public function dispose() : void
		{
			clearDeleteUpatables();
			var updatable : SIUpdatable;
			var len : int = 0;
			len = _highPriorUpdatables.length;
			for (i = len - 1; i >= 0; i--)
			{
				updatable = _highPriorUpdatables[i];
				if (!updatable.isDisposed)
					updatable.destroy();
			}
			len = _mediumPriorUpdatables.length;
			for (i = len - 1; i >= 0; i--)
			{
				updatable = _mediumPriorUpdatables[i];
				if (!updatable.isDisposed)
					updatable.destroy();
			}
			len = _lowPriorUpdatables.length;
			for (var i : int = len - 1; i >= 0; i--)
			{
				updatable = _lowPriorUpdatables[i];
				if (!updatable.isDisposed)
					updatable.destroy();
			}
			clearDeleteUpatables();

			SShellVariables.nativeStage.removeEventListener(Event.ENTER_FRAME, onEnterFrameUpdate, false);
		}

		public function updateStageIsNotActive() : void
		{
			if (!SShellVariables.stageIsActive && _isStarted)
			{
				onEnterFrameUpdate(null);
			}
		}

		public function get validHighPriorCount() : int
		{
			return _highPriorUpdatables.length;
		}

		public function get validMediumPriorCount() : int
		{
			return _mediumPriorUpdatables.length;
		}

		public function get validLowPriorCount() : int
		{
			return _lowPriorUpdatables.length;
		}

		public function get timeScale() : Number
		{
			return _timeScale;
		}

		public function get currFrameTimestamp() : Number
		{
			return _currFrameTimestamp;
		}

	}
}
