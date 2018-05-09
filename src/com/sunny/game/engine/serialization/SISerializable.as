package com.sunny.game.engine.serialization
{
	/**
	 *
	 * <p>
	 * SunnyGame的一个可序列化接口
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
	public interface SISerializable
	{
		/**
		 * 将对象序列化，这不应该包括主标签定义类本身。
		 * 这个data对象是一个单一的标签包含主类的定义，所以只有这个班的孩子应该被添加到它的。
		 */
		function serialize(data : Object) : void;
		/**
		 * 反序列化对象的data，取决于对象的序列化方法，序列化的方式。
		 *
		 * @param data 包含序列化的类定义。
		 *
		 * @return 返回反序列化的对象。通常这个应该归还，但
		 * 某些情况下它可能返回其他有用的事。可枚举类
		 * 这是迫使所有的值是枚举的成员。
		 */
		function deserialize(data : Object) : *;
	}
}