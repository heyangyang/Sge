package com.sunny.game.engine.lang
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	/**
	 *
	 * <p>
	 * SunnyGame的一个长整形数据类型
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
	public class SLong
	{
		public static const POW_2_63 : Number = Math.pow(2, 63);
		private var _long : Number;

		public function SLong(value : Number = 0)
		{
			setLong(value);
		}

		public function getLong() : Number
		{
			return _long;
		}

		public function setLong(value : Number) : SLong
		{
			if (value > POW_2_63 - 1 || value < -POW_2_63)
			{
				throw new SunnyGameEngineError("非长整型数据类型，值范围应该在" + Number(-POW_2_63) + "到" + Number(POW_2_63 - 1) + "！");
			}
			_long = value;
			return this;
		}
	}
}