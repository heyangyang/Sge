package com.sunny.game.engine.lang.thread
{
	

	/**
	 *
	 * <p>
	 * SunnyGame的一个线程消息
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
	public class SThreadMessage
	{
		public var id : int;
		public var type : int;
		protected var _args : Array;

		public function SThreadMessage()
		{
			super();
		}

		public function setArgs(... args) : void
		{
			_args = args;
		}

		public function get args() : Array
		{
			return _args;
		}

		public function set args(value : Array) : void
		{
			_args = value;
		}

		public function free() : void
		{
			_args = null;
		}
	}
}