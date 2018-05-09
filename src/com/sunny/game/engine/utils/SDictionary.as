package com.sunny.game.engine.utils
{
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的字典
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
	public class SDictionary
	{
		private var _dic : Dictionary;
		private var _length : uint;

		public function SDictionary(weakKeys : Boolean = false)
		{
			_dic = new Dictionary(weakKeys);
			_length = 0;
		}

		public function setValue(key : *, value : *) : void
		{
			if (_dic[key] == null)
				_length++;
			_dic[key] = value;
		}

		public function getValue(key : *) : *
		{
			return _dic[key];
		}

		public function deleteValue(key : *) : void
		{
			if (_dic[key] != null)
			{
				_length--;
				_dic[key] = null;
				delete _dic[key];
			}
		}

		public function hasValue(key : *) : Boolean
		{
			return _dic[key] != null;
		}

		public function get length() : uint
		{
			return _length;
		}

		public function concat(value : SDictionary) : SDictionary
		{
			var dic : SDictionary = new SDictionary();
			var key : *;
			for (key in _dic)
				dic.setValue(key, _dic[key]);
			for (key in value.dic)
				dic.setValue(key, value.dic[key]);
			return dic;
		}

		public function clear() : void
		{
			for (var key : * in _dic)
			{
				_dic[key] = null;
				delete _dic[key];
			}
			_length = 0;
		}

		public function get dic() : Dictionary
		{
			return _dic;
		}
	}
}