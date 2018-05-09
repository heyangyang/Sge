package com.sunny.game.engine.data
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个动态请求
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
	public class SDynamicRequest
	{
		private var _dataType : Class;
		private var _id : int;

		public function SDynamicRequest(dataType : Class, id : int)
		{
			_dataType = dataType;
			_id = id;
		}

		public function get dataType() : Class
		{
			return _dataType;
		}

		public function get id() : int
		{
			return _id;
		}
	}
}