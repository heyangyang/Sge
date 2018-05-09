package com.sunny.game.engine.lang
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	/**
	 *
	 * <p>
	 * SunnyGame的一个字符串字节数据类型
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
	public class SStringBytes
	{
		private var _string : String;

		public function SStringBytes(value : String)
		{
			setString(value);
		}

		public function getString() : String
		{
			return _string;
		}

		public function setString(value : String) : SStringBytes
		{
			if (value == null)
			{
				throw new SunnyGameEngineError("字符串数据类型不能为空！");
			}
			_string = value;
			return this;
		}
	}
}