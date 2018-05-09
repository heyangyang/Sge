package com.sunny.game.engine.enum
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个线程消息类型
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
	public class SThreadMessageType
	{
		public static const THREAD_MESSAGE_LOAD : int = 0;

		public static const ERROR : int = 2;
		
		public static const THREAD_MESSAGE_PARSE : int = 3;
		public static const THREAD_MESSAGE_UNLOAD : int = 4;

		public static const THREAD_MESSAGE_INIT_ASTAR : int = 5;
		public static const THREAD_MESSAGE_SET_BLOCK_BORDER : int = 6;
		public static const THREAD_MESSAGE_ADD_UNWALK_BLOCK : int = 7;
		public static const THREAD_MESSAGE_RESET_BLOCKS : int = 8;
		public static const THREAD_MESSAGE_SEEK_ROAD : int = 9;

		public function SThreadMessageType()
		{
		}
	}
}