package com.sunny.game.engine.core
{
	import com.sunny.game.engine.ns.sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个对象基类
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
	public class SObject extends Object
	{
		public function SObject()
		{
			super();
		}

		sunny_engine function getClass() : Class
		{
			return this["constructor"];
		}
	}
}