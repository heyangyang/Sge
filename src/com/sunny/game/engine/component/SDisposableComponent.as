package com.sunny.game.engine.component
{
	import com.sunny.game.engine.core.SIUpdatable;

	/**
	 *
	 * <p>
	 * SunnyGame的一个可释放资源组件
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
	public class SDisposableComponent extends SUpdatableComponent
	{
		/**
		 * 销毁自身
		 */
		public static const DISPOSE_SELF : int = 1;
		/**
		 * 销毁拥有者
		 */
		public static const DISPOSE_OWNER : int = 2;
		/**
		 * 将拥有者从更新驱动中清除
		 */
		public static const UNREGISTER_OWNER : int = 3;

		protected var _lifeTick : int;
		protected var _needTick : Boolean = false; //默认不开启

		/**
		 *  0 删除自己  1 删除父对象  2  将父对象从主驱动器中清除
		 */
		protected var _disposeType : int = DISPOSE_SELF;

		public function SDisposableComponent(type : * = null, disposeType : int = DISPOSE_SELF)
		{
			super(type || SDisposableComponent);
			_disposeType = disposeType;
		}

		/**
		 *
		 * @param tick 当tick 小于0 时 ，不启动计数自动消毁
		 * @return
		 *
		 */
		public function setLifeTick(tick : int) : SDisposableComponent
		{
			if (tick <= 0)
				_needTick = false;
			else
				_needTick = true;
			_lifeTick = tick;
			return this;
		}

		public function get lifeTick() : int
		{
			return _lifeTick;
		}

		override public function update() : void
		{
			if (_isDisposed)
				return;
			if (!_enabled)
				return;
			if (!_needTick)
				return;

			if (_lifeTick < 0)
				timeOut();
			else
				_lifeTick -= elapsedTimes;
		}

		public function timeOut() : void
		{
			if (_disposeType == DISPOSE_SELF)
			{
				destroy();
			}
			else if (_disposeType == DISPOSE_OWNER)
			{
				if (owner)
					owner.destroy();
			}
			else if (_disposeType == UNREGISTER_OWNER)
			{
				if (owner)
					(owner as SIUpdatable).unregister();
			}
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			super.destroy();
		}

		public function set disposeType(value : int) : void
		{
			_disposeType = value;
		}

		public function get disposeType() : int
		{
			return _disposeType;
		}
	}
}