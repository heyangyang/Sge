package com.sunny.game.engine.events
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个屏幕更新事件
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
	public class STickEvent extends SEvent
	{
		/**
		 * 实际上便是ENTER_FRAME
		 */
		public static const TICK : String = "tick";

		/**
		 * 两次发布事件的毫秒间隔
		 */
		public var interval : int;

		/**
		 * 用于Tick的发布事件
		 *
		 * @param type	类型
		 * @param interval	两次事件的毫秒间隔
		 *
		 */
		public function STickEvent(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

		public override function clone() : SEvent
		{
			var evt : STickEvent = new STickEvent(type, data, bubbles, cancelable);
			evt.interval = this.interval;
			return evt;
		}
	}
}