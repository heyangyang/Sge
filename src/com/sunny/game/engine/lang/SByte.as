package com.sunny.game.engine.lang
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	/**
	 *
	 * <p>
	 * SunnyGame的一个字节数据类型
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
	public class SByte
	{
		private var _byte : int;

		public function SByte(value : int = 0)
		{
			setByte(value);
		}

		public function getByte() : int
		{
			return _byte;
		}

		public function setByte(value : int) : SByte
		{
			if (value > 255 || value < -128)
			{
				throw new SunnyGameEngineError("非字节数据类型，值范围应该在-128到255！");
			}
			_byte = value;
			return this;
		}
	}
}