package com.sunny.game.engine.lang
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	/**
	 *
	 * <p>
	 * SunnyGame的一个短整型数据类型
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
	public class SShort
	{
		private var _short : int;

		public function SShort(value : int = 0)
		{
			setShort(value);
		}

		public function getShort() : int
		{
			return _short;
		}

		public function setShort(value : int) : SShort
		{
			if (value > 65535 || value < -32768)
			{
				throw new SunnyGameEngineError("非短整型数据类型，值范围应该在-32768到65535！");
			}
			_short = value;
			return this;
		}
	}
}