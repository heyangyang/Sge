package com.sunny.game.engine.core
{
	import com.sunny.game.engine.events.SCaller;
	import com.sunny.game.engine.lang.STime;
	import com.sunny.game.engine.manager.SUpdatableManager;
	import com.sunny.game.engine.ns.sunny_engine;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个可更新类
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
	public class SUpdatable extends SCaller implements SIUpdatable
	{
		private var _frameRate : int = 0;
		private var _frameTimes : int = 0;

		public var elapsedTimes : int = 0;

		protected var _needCheckUpdatable : Boolean = false;

		private var _priority : int;

		protected var _isDisposed : Boolean;

		protected var _isRegistered : Boolean;

		protected var _updatables : Array = [];
		protected var _enabled : Boolean = true;
		protected var _paused : Boolean;

		public function SUpdatable()
		{
			super();
			_enabled = true;
			_paused = false;
			_isDisposed = false;
		}

		public function update() : void
		{
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			unregister();
			if (_updatables)
			{
				_updatables.length = 0;
				_updatables = null;
			}
			_paused = false;
			_enabled = false;
			_isDisposed = true;
		}

		public function set paused(value : Boolean) : void
		{
			_paused = value;
		}

		public function get paused() : Boolean
		{
			return _paused;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function checkUpdatable() : Boolean
		{
			if (!_needCheckUpdatable)
			{
				elapsedTimes = STime.deltaTime;
				return true;
			}
			if (elapsedTimes >= _frameTimes)
				elapsedTimes = STime.deltaTime;
			else
				elapsedTimes += STime.deltaTime;
			
			if (elapsedTimes >= _frameTimes)
			{
				return true;
			}
			return false;
		}

		public function set frameRate(value : Number) : void
		{
			if (value < 1 || value > SShellVariables.frameRate)
			{
				_frameRate = SShellVariables.frameRate;
				_needCheckUpdatable = false;
				return;
			}

			_frameRate = value;
			if (value != SShellVariables.frameRate)
			{
				_frameTimes = 1000 / _frameRate;
				_needCheckUpdatable = true;
			}
			else
			{
				_needCheckUpdatable = false;
			}
		}

		public function get frameRate() : Number
		{
			if (!isNaN(_frameRate))
				return _frameRate;
			else if (!isNaN(SShellVariables.frameRate))
				return SShellVariables.frameRate;
			else if (SShellVariables.nativeStage)
				return SShellVariables.nativeStage.frameRate;
			else
				return NaN;
		}

		/**
		 * frametimes即“帧渲染时间”,也就是显卡绘制一帧画面所消耗的时间。
		 * @param value
		 *
		 */
		public function set frameTimes(value : int) : void
		{
			value = Math.max(0, value);
			_frameTimes = value;
			if (value == 0)
				_needCheckUpdatable = false;
			else
				_needCheckUpdatable = true;
		}

		public function get frameTimes() : int
		{
			return _frameTimes;
		}

		/**
		 * @param priorityLayer 1high 2mid 3low
		 */
		public function register(priorityLayer : int = 3, priority : int = 0) : void
		{
			if (_isRegistered)
				return;
			SUpdatableManager.getInstance().register(this, priorityLayer, priority);
		}

		public function unregister() : void
		{
			if (!_isRegistered)
				return;
			SUpdatableManager.getInstance().unregister(this);
		}

		public function notifyRegistered() : void
		{
			_isRegistered = true;
		}

		public function notifyUnregistered() : void
		{
			_isRegistered = false;
		}

		public function get priority() : int
		{
			return _priority;
		}

		public function set priority(value : int) : void
		{
			if (_priority == value)
				return;
			_priority = value;
			if (_isRegistered)
				SUpdatableManager.getInstance().changePriority(this, _priority);
		}

		/**
		 * 是否已经在主驱动器中注册
		 * @return
		 */
		public function get isRegistered() : Boolean
		{
			return _isRegistered;
		}

		public function get numUpdatable() : uint
		{
			return _updatables.length;
		}

		/**
		 * 是否激活时基（时基即时间显示的基本单位），当为false时将禁用对象的操作
		 */
		public function get enabled() : Boolean
		{
			return _enabled;
		}

		/**
		 * @private
		 */
		public function set enabled(value : Boolean) : void
		{
			_enabled = value;
		}
	}
}