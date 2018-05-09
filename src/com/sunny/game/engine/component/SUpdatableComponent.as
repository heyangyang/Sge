package com.sunny.game.engine.component
{
	import com.sunny.game.engine.core.SComponent;
	import com.sunny.game.engine.core.SIUpdatable;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.lang.STime;
	import com.sunny.game.engine.ns.sunny_engine;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个可更新组件
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
	public class SUpdatableComponent extends SComponent implements SIUpdatable
	{
		private var _frameRate : int = 0;
		private var _frameTimes : int = 0;

		public var elapsedTimes : int;

		private var _needCheckUpdatable : Boolean;

		private var _priority : int;

		protected var _paused : Boolean;

		public function SUpdatableComponent(type : * = null)
		{
			_needCheckUpdatable = false;
			_paused = false;
			super(type || SUpdatableComponent);
		}

		public function update() : void
		{
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

		public function register(priorityLayer : int = 1, priority : int = 0) : void
		{
		}

		public function unregister() : void
		{
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			_paused = false;
			super.destroy();
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
		}

		public function get isRegisterd() : Boolean
		{
			return false;
		}

		public function get isRegistered() : Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}

		public function notifyRegistered() : void
		{
			// TODO Auto Generated method stub

		}

		public function notifyUnregistered() : void
		{
			// TODO Auto Generated method stub

		}

		public function get numUpdatable() : uint
		{
			return 0;
		}

		public function set paused(value : Boolean) : void
		{
			_paused = value;
		}

		public function get paused() : Boolean
		{
			return _paused;
		}
	}
}
