package com.sunny.game.engine.lang.errors
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个抽象错误
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
	public class SAbstractError extends Error
	{
		/**
		 * @param message 与 SAbstractError 对象关联的字符串；此参数为可选。
		 * @param id 与特定错误消息关联的引用数字。
		 *
		 */
		public function SAbstractError(message : String = "", id : uint = 0)
		{
			super(message, id);
			name = "SAbstractError";
		}
	}
}