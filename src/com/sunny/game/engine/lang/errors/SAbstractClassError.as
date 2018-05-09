package com.sunny.game.engine.lang.errors
{
	import com.sunny.game.engine.lang.errors.SAbstractError;

	/**
	 *
	 * <p>
	 * SunnyGame的一个abstractclasserror抛出，当您试图创建抽象类的实例。
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
	public class SAbstractClassError extends SAbstractError
	{
		/** Creates a new AbstractClassError object. */
		public function SAbstractClassError(message : String = "Cannot instantiate abstract class", id : uint = 0)
		{
			super(message, id);
		}
	}
}