package com.sunny.game.engine.core
{

	/**
	 *
	 * <p>
	 * 一个获取和设置类对象已经声明的属性值代理接口
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
	public interface SIValueProxy
	{
		/**
		 * 获取对象的一个已经命名的一个属性值。
		 * @param object 对象
		 * @param name 属性名称
		 * @return 值
		 */
		function getValue(object : Object, name : String) : *;

		/**
		 * 设置对象的一个已经命名的一个属性值。
		 * @param object 对象
		 * @param name 属性名称
		 * @param value 值
		 */
		function setValue(object : Object, name : String, value : *) : void;

		/**
		 * 返回一个用于获取和设置值的代理对象。
		 * @param object 对象
		 * @return 返回一个代理对象后客户可以直接获取和设置属性
		 */
		function $(object : Object) : Object;
	}
}