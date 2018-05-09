package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.events.SEventDispatcher;
	import com.sunny.game.engine.events.STickEvent;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.manager.SUpdatableManager;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;

	[SEvent(name="tick", type="com.sunny.game.engine.events.STickEvent")]

	/**
	 * 这个类提供了发布ENTER_FRAME事件的功能，唯一的区别在于在发布的事件里会包含一个interval属性，表示两次事件的间隔毫秒数。
	 * 利用这种机制，接收事件方可以根据interval来动态调整动画播放间隔，单次移动距离，以此实现动画在任何客户机上的恒速播放，
	 * 不再受ENTER_FRAME发布频率的影响，也就是所谓的“跳帧”。
	 *
	 * GMovieClip便是一个实现实例。
	 *
	 * 相比其他同样利用getTimer()的方式，这种方法并不会进行多余的计算。
	 *
	 *
	 */
	public class STick extends SEventDispatcher implements SIDestroy
	{
		static private var _instance : STick;

		static public function getInstance() : STick
		{
			if (!_instance)
				_instance = new STick();
			return _instance;
		}

		/**
		 * 全局默认帧频
		 */
		static public var frameRate : Number = NaN;

		/**
		 * 最大两帧间隔（防止待机后返回卡死）
		 */
		static public var MAX_INTERVAL : int = 3000;
		static public var MIN_INTERVAL : int = 0;

		static public var tickUpdatable : Boolean = true;

		/**
		 * 速度系数
		 * 可由此实现慢速播放
		 *
		 */
		public var speed : Number = 1.0;

		/**
		 * 是否停止发布Tick事件
		 *
		 * Tick事件的发布影响的内容非常多，一般情况不建议设置此属性，而是设置所有需要暂停物品的pause属性。
		 */
		public var pause : Boolean = false;

		private var displayObject : Shape; //用来提供事件的对象
		private var prevTime : int; //上次记录的时间

		private var _tickEvent : STickEvent;

		public function STick()
		{
			displayObject = new Shape();
			_tickEvent = new STickEvent(STickEvent.TICK);
			displayObject.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}

		/**
		 * 清除掉积累的时间（在暂停之后）
		 *
		 */
		public function clear() : void
		{
			this.prevTime = 0;
		}

		private function enterFrameHandler(event : Event) : void
		{
			if (!SUpdatableManager.getInstance().isStarted || !tickUpdatable)
				return;
			var nextTime : int = getTimer();
			if (!pause)
			{
				if (prevTime == 0)
					_tickEvent.interval = 0;
				else
				{
					_tickEvent.interval = Math.max(MIN_INTERVAL, Math.min(nextTime - prevTime, MAX_INTERVAL)) * speed;
					dispatchEvent(_tickEvent);
				}
			}
			prevTime = nextTime;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			clear();
			if (displayObject)
			{
				displayObject.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				displayObject = null;
			}
			if (_tickEvent)
			{
				_tickEvent.destroy();
				_tickEvent = null;
			}
			super.destroy();
		}
	}
}
