package com.sunny.game.engine.lang.utils
{
	import com.sunny.game.engine.lang.exceptions.IllegalParameterException;
	import com.sunny.game.engine.lang.exceptions.SNullPointerException;

	/**
	 *
	 * <p>
	 * SunnyGame的一个断言assertion。使用true/false 命题验证单元测试中的条件。
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
	public class SAssert
	{
		public static var switchOn : Boolean = true;

		/**
		 * 判断如果是null，则直接抛出异常。
		 *
		 * @param	...args
		 */
		public static function checkNull(... args) : void
		{
			if (!switchOn)
			{
				return;
			}

			for each (var arg : Object in args)
			{
				if (arg == null)
				{
					throw new SNullPointerException("Null object");
				}
			}
		}

		public static function checkNotNull(... args) : void
		{
			if (!switchOn)
			{
				return;
			}

			for each (var arg : Object in args)
			{
				if (arg != null)
				{
					throw new SNullPointerException("Not null object");
				}
			}
		}

		public static function checkTrue(bool : Boolean) : void
		{
			if (!switchOn)
			{
				return;
			}

			if (bool)
			{
				throw new IllegalParameterException("Assert is true");
			}
		}

		public static function checkFalse(bool : Boolean) : void
		{
			if (!switchOn)
			{
				return;
			}

			if (!bool)
			{
				throw new IllegalParameterException("Assert is false");
			}
		}
	}
}