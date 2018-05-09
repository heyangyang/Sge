package com.sunny.game.engine.events
{
	/**
	 *
	 * <p>
	 * SunnyGame的一个事件池
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
	public class SEventPool extends SEventDispatcher
	{
		private static var _instance : SEventPool;

		public function SEventPool()
		{
			if (_instance == null)
				super();
			else
				throw new Error("SEventPool类不能实例化。");
		}

		public static function getInstance() : SEventPool
		{
			if (!_instance)
				_instance = new SEventPool();
			return _instance;
		}

		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void
		{
			SEventPool.getInstance().addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public static function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void
		{
			SEventPool.getInstance().removeEventListener(type, listener, useCapture);
		}
	}
}
