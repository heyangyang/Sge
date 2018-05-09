package com.sunny.game.engine.events
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个进入帧事件，包含上一帧(last frame)过去的时间，这样可以计算动画帧速率
	 * </p>
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @see SIEventDispatcher
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public class SEnterFrameEvent extends SEvent
	{
		/**
		 * 进入帧事件类型
		 */
		public static const ENTER_FRAME : String = "enterFrame";

		/** Creates an enter frame event with the passed time. */
		public function SEnterFrameEvent(type : String, passedTime : int, bubbles : Boolean = false)
		{
			super(type, passedTime, bubbles);
		}

		/**
		 * 上一帧过去的时间（秒）
		 * @return
		 *
		 */
		public function get passedTime() : int
		{
			return data as int;
		}

		public function set passedTime(value : int) : void
		{
			data = value;
		}
	}
}