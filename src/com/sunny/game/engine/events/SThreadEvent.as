package com.sunny.game.engine.events
{
	import com.sunny.game.engine.lang.thread.SThreadMessage;

	/**
	 *
	 * <p>
	 * SunnyGame的一个线程事件
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
	public class SThreadEvent extends SEvent
	{
		public static const LOAD_SEND : String = "0";
		public static const EVENT_MAIN_THREAD_SEND : String = "1";
		public static const EVENT_BACK_THREAD_SEND : String = "3";

		public function SThreadEvent(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

		public function get message() : SThreadMessage
		{
			return (data as SThreadMessage);
		}

		public static function dispatchEvent(type : String, data : * = null) : void
		{
			new SThreadEvent(type, data).dispatch();
		}
	}
}