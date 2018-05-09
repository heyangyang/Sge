package com.sunny.game.engine.lang
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	import flash.utils.ByteArray;

	/**
	 *
	 * <p>
	 * SunnyGame的一个短字符串数据类型
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
	public class SLessString
	{
		private var _len : uint;
		private var _string : String;

		public function SLessString(value : String)
		{
			setString(value);
		}

		public function getString() : String
		{
			return _string;
		}

		public function setString(value : String) : SLessString
		{
			var bytes : ByteArray = new ByteArray();
			bytes.writeUTFBytes(value);
			_len = bytes.length;
			if (_len > 255 || _len < 0)
			{
				throw new SunnyGameEngineError("非短字符串数据类型，字符串长度范围应该在1到255！");
			}
			_string = value;
			return this;
		}
	}
}