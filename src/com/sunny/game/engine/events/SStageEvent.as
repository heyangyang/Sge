package com.sunny.game.engine.events
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个舞台事件
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
	public class SStageEvent extends SEvent
	{
		//public static const STAGE_RESIZE_DELTA_EVENT : String = "STAGE_RESIZE_DELTA_EVENT";

		public function SStageEvent(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

		public static function dispatchEvent(type : String, data : * = null) : void
		{
			new SStageEvent(type, data).dispatch();
		}
	}
}