package com.sunny.game.engine.utils.core
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * <p>
	 * SunnyGame的一个统一的单例实现
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
	public class SSingleton extends EventDispatcher
	{
		private static var dict : Dictionary = new Dictionary();

		public function SSingleton()
		{
			var ref : Class = this["constructor"] as Class;
			if (dict[ref])
				throw new IllegalOperationError(getQualifiedClassName(this) + " 只允许实例化一次！");
			else
				dict[ref] = this;
		}

		/**
		 * 销毁方法
		 *
		 */
		public function destory() : void
		{
			var ref : Class = this["constructor"] as Class;
			delete dict[ref];
		}

		/**
		 * 获取单例类，若不存在则创建
		 *
		 * @param ref 继承自SSingleton的类
		 * @return
		 *
		 */
		public static function getInstance(ref : Class) : Object
		{
			if (dict[ref] == null)
				dict[ref] = new ref();
			return dict[ref];
		}
	}
}
