package com.sunny.game.engine.utils.core
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个弱引用包装类
	 * 利用Dictionary的特性使得弱引用特性可以延展到其他对象上。
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
	dynamic public class SWeakReference extends Proxy
	{
		private var _dictionary : Dictionary;

		public function SWeakReference(o : Object)
		{
			super();
			_dictionary = new Dictionary(true);
			_dictionary[o] = null;
		}

		/**
		 * 获取对象。
		 * 虽然这个类是代理类，可以直接设置属性，一般不建议这样使用，而是使用value属性将保存的对象取出，
		 * 并用强制类型转换来使用它。
		 *
		 * @return
		 *
		 */
		public function get value() : Object
		{
			for (var n : Object in _dictionary)
				return n;

			//Debug.error("无法找到对象引用，它可能已经被回收了。");
			return null;
		}

		flash_proxy override function callProperty(methodName : *, ... args) : *
		{
			var metrod : * = value[methodName];
			(metrod as Function).apply(null, args);
		}

		flash_proxy override function getProperty(property : *) : *
		{
			return value[property];
		}

		flash_proxy override function setProperty(property : *, value : *) : void
		{
			value[property] = value;
		}

		flash_proxy override function deleteProperty(property : *) : Boolean
		{
			return delete(value[property]);
		}
	}
}