package com.sunny.game.engine.desc
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个类描述
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
	public class SClassDescribe
	{
		/**
		 * 构造函数
		 */
		public function SClassDescribe(item : XML = null)
		{
			if (item)
			{
				id = String(item.@id);
				name = String(item.@name);
				if (item.hasOwnProperty("@superName"))
					superName = String(item.@superName);
				if (item.hasOwnProperty("@defaultProp"))
					defaultProp = String(item.@defaultProp);
				if (item.hasOwnProperty("@array"))
					isArray = Boolean(item.@array == "true");
				if (item.hasOwnProperty("@state"))
					states = String(item.@state).split(",");
			}
		}
		/**
		 * （短名）ID
		 */
		public var id : String;
		/**
		 * （完整）类名
		 */
		public var name : String;
		/**
		 * 父级类名
		 */
		public var superName : String = "";
		/**
		 * 默认属性
		 */
		public var defaultProp : String = "";
		/**
		 * 默认属性是否为数组类型
		 */
		public var isArray : Boolean = false;
		/**
		 * 视图状态列表
		 */
		public var states : Array;
		public var order : int = 0;
	}
}