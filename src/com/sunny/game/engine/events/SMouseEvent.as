package com.sunny.game.engine.events
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个鼠标事件
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
	public class SMouseEvent extends SEvent
	{
		public static const EVENT_CLICK : String = "EVENT_CLICK";
		public static const EVENT_DOUBLE_CLICK : String = "EVENT_DOUBLE_CLICK";
		public static const RIGHT_CLICK : String = "RIGHT_CLICK";

		public function SMouseEvent(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

		public static function dispatchEvent(type : String, data : * = null) : void
		{
			new SMouseEvent(type, data).dispatch();
		}
	}
}