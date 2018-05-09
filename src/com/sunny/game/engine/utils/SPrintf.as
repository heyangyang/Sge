package com.sunny.game.engine.utils
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个格式化输出
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
	public class SPrintf
	{
		/**
		 * 替换format字符串中的%s或所有 $ 开头的单词
		 * 例如 printf('hello, %s!', 'dj') ==> 'hello, dj!'
		 * 例如 printf('hello, $name!', 'dj') ==> 'hello, dj!'
		 */
		public static function printf(format : String, ... params) : String
		{
			var str : String = '';
			var subs : Array = format.split(/%s|\$[a-zA-Z]+\$/);

			var last : String = subs.pop();
			if (last != '')
			{
				subs.push(last);
			}

			var len : int = subs.length < params.length ? subs.length : params.length;
			for (var i : int = 0; i < len; ++i)
			{
				str += subs[i] + params[i];
			}

			if (subs.length > len)
			{
				i = len;
				len = subs.length;
				for (; i < len; ++i)
				{
					str += subs[i];
				}
			}

			return str;
		}

		public static function tracef(format : String, ... params) : void
		{
			trace(printf.apply(null, [format].concat(params)));
		}

		public static function tracef2(format : String, ... params) : void
		{
			trace(printf.apply(null, [format].concat(params)));
		}


	}
}