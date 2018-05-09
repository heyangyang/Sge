package com.sunny.game.engine.core
{
	import com.sunny.game.engine.display.SSprite;
	import com.sunny.game.engine.lang.STime;
	import com.sunny.game.engine.manager.SUpdatableManager;
	import com.sunny.game.engine.ns.sunny_engine;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个可更新精灵
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
	public class SUpdatableSprite extends SSprite implements SIUpdatable
	{
		private var _frameRate : Number = NaN;
		private var _frameElapsedTime : int = 0;
		private var _frameTimes : int = 0;

		public var elapsedTimes : int;

		private var _needCheckUpdatable : Boolean = false;

		private var _priority : int;
		protected var _enabled : Boolean;
		protected var _paused : Boolean;

		protected var _isRegistered : Boolean;
		protected var _batchEnable : Boolean = true;
		protected var _timeScalable : Boolean = false;

		public function SUpdatableSprite()
		{
			super();
			_enabled = true;
			_paused = false;
		}

		public function update() : void
		{
		}

		/**
		 * 当为false时将禁用对象的操作
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

		/** @inheritDoc */
		public function get paused() : Boolean
		{
			return _paused;
		}

		public function set paused(value : Boolean) : void
		{
			if (_paused == value)
				return;
			_paused = value;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			SUpdatableManager.getInstance().unregister(this);
			_enabled = false;
			super.destroy();
		}

		public function checkUpdatable() : Boolean
		{
			if (!_needCheckUpdatable)
			{
				elapsedTimes = STime.deltaTime;
				return true;
			}
			if (_frameElapsedTime == 0)
				elapsedTimes = 0;

			_frameElapsedTime += STime.deltaTime;
			elapsedTimes += STime.deltaTime;

			if (_frameElapsedTime >= _frameTimes)
			{
				_frameElapsedTime = 0;
				return true;
			}
			return false;
		}

		public function resetElapsedTime() : void
		{
			elapsedTimes = 0;
		}

		/**
		 * 设置帧频，设为NaN表示使用默认帧频，负值则为倒放(暂不支持)。
		 */
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

		/**
		 * 注销
		 *
		 */
		public function unregister() : void
		{
			if (!_isRegistered)
				return;
			SUpdatableManager.getInstance().unregister(this);
		}

		private var _errorCount : int;

		public function error() : void
		{
			_errorCount++;
		}

		public function getErrorCount() : int
		{
			return _errorCount;
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

		public function get isRegistered() : Boolean
		{
			return _isRegistered;
		}

		public function notifyRegistered() : void
		{
			_isRegistered = true;
		}

		public function notifyUnregistered() : void
		{
			_isRegistered = false;
		}

		public function get pauseEnable() : Boolean
		{
			return false;
		}

		public function get numUpdatable() : uint
		{
			return 0;
		}

		private var _batchElapsedTimes : int = 0;

		public function get batchElapsedTimes() : int
		{
			return _batchElapsedTimes;
		}

		public function set batchElapsedTimes(value : int) : void
		{
			_batchElapsedTimes = value;
		}

		public function get batchEnable() : Boolean
		{
			return _batchEnable;
		}

		public function get timeScalable() : Boolean
		{
			return _timeScalable;
		}
	}
}