package com.sunny.game.engine.events
{
	import flash.events.Event;

	/**
	 *
	 * <p>
	 * SunnyGame的一个指令事件
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
	public class SActionEvent extends Event
	{
		/**
		 * 指令事件
		 */
		public static const ACTION : String = "action";

		/**
		 * 指令
		 */
		public var action : String;

		/**
		 * 参数
		 */
		public var parameters : Array;

		public function SActionEvent(type : String, bubbles : Boolean = true, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		public override function clone() : Event
		{
			var evt : SActionEvent = new SActionEvent(type, bubbles, cancelable);
			evt.action = this.action;
			evt.parameters = this.parameters;
			return evt;
		}
	}
}