package com.sunny.game.engine.transition.tween
{
	import com.sunny.game.engine.core.SObject;

	/**
	 *
	 * <p>
	 * SunnyGame的一个滤镜属性
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
	public class SFilterProps extends SObject
	{
		public var index : int = -1;
		public var remove : Boolean = false;

		public function SFilterProps()
		{
			super();
		}
	}
}