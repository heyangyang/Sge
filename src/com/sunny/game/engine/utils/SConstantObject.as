package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.lang.exceptions.IllegalOperationException;

	/**
	 *
	 * <p>
	 * 常量对象。以对象形式来创建常量。子类继承
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
	public class SConstantObject
	{
		private static var _allowInstance : Boolean = false;

		private var _type : Object = null;

		/**
		 * 创建常量对象
		 *
		 * @param	type	字符串表示形式
		 * @param	definition	类定义
		 *
		 * @return	返回创建的常量对象
		 */
		protected static function createInstance(type : Object = null, definition : Class = null) : *
		{
			_allowInstance = true;
			var instance : SConstantObject = definition == null ? new SConstantObject() : new definition();
			instance._type = type;
			_allowInstance = false;

			return instance;
		}

		public function SConstantObject()
		{
			if (!_allowInstance)
			{
				throw new IllegalOperationException("不能创建实例！");
			}
		}

		public function valueOf() : Object
		{
			return _type;
		}

		public function toString() : String
		{
			return "[object ConstantObject(type:" + _type + ")]";
		}
	}
}