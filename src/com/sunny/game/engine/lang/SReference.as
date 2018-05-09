package com.sunny.game.engine.lang
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.lang.utils.SAssert;

	/**
	 *
	 * <p>
	 * SunnyGame的一个引用
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
	public class SReference extends SObject
	{
		private var _allowDestroy : Boolean;
		protected var _isDisposed : Boolean;
		private var _referenceCount : uint;
		public var lastUseTime : uint;

		public function SReference()
		{
			super();
			_isDisposed = false;
			_allowDestroy = false;
			_referenceCount = 0;
			retain();
		}

		public function retain() : void
		{
			if (_isDisposed)
				return;
			SAssert.checkFalse(_referenceCount >= 0);
			++_referenceCount;
			_allowDestroy = false;
			lastUseTime = SShellVariables.getTimer;
		}

		public function release() : void
		{
			if (_isDisposed)
				return;
			lastUseTime = SShellVariables.getTimer;
			SAssert.checkFalse(_referenceCount > 0);
			--_referenceCount;
			if (_referenceCount <= 0)
			{
				_allowDestroy = true;
			}
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function tryDestroy() : Boolean
		{
			if (_isDisposed)
				return false;
			if (_allowDestroy)
			{
				destroy();
				return true;
			}
			return false;
		}

		public function forceDestroy() : void
		{
			if (_isDisposed)
				return;
			destroy();
		}

		public function get allowDestroy() : Boolean
		{
			return _allowDestroy;
		}

		/**
		 * 清除内存
		 */
		protected function destroy() : void
		{
			_isDisposed = true;
			_allowDestroy = false;
			_referenceCount = 0;
		}
	}
}