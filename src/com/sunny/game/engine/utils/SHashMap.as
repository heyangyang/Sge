package com.sunny.game.engine.utils
{
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的哈希表
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
	public class SHashMap implements SIMap
	{
		private var _keys : Array = null;
		private var _length : uint;
		private var props : Dictionary = null;

		public function SHashMap()
		{
			this.clear();
		}

		/**
		 * 清除hashMap数据
		 */
		public function clear() : void
		{
			this.props = new Dictionary();
			this._keys = new Array();
		}

		/**
		 * 检测对象是否存在
		 * @param	key		要找的对象的key
		 * @return	Boolean		true存在 	false不存在
		 */
		public function containsKey(key : Object) : Boolean
		{
			return this.props[key] != null;
		}

		/**
		 * 检测对象是否存在
		 * @param	value	要找的对象的引用
		 * @return	Boolean		true存在 	false不存在
		 */
		public function containsValue(value : Object) : Boolean
		{
			var result : Boolean = false;
			var len : uint = this.size();
			if (len > 0)
			{
				for (var i : uint = 0; i < len; i++)
				{
					if (this.props[this._keys[i]] == value)
						return true;
				}
			}
			return result;
		}

		/**
		 * 得到key关联的一个对象
		 * @param	key
		 * @return	Object
		 */
		public function get(key : Object) : Object
		{
			return this.props[key];
		}

		/**
		 * 装入一个对象
		 * @param	key
		 * @param	value
		 * @return
		 */
		public function put(key : Object, value : Object) : Object
		{
			var result : Object = null;
			if (this.containsKey(key))
			{
				result = this.get(key);
				this.props[key] = value;
			}
			else
			{
				this.props[key] = value;
				this._keys.push(key);
			}
			return result;
		}

		/**
		 * 得到key对象的一个索引
		 * @param	key
		 * @return	uint	key对象的一个索引
		 */
		public function getKeyIndex(key : Object) : int
		{
			var len : uint = _keys.length;
			for (var i : uint = 0; i < len; i++)
			{
				if (_keys[i] == key)
				{
					return i;
				}
			}
			return -1;
		}

		/**
		 * 删除一个对象
		 * @param	key
		 * @return
		 */
		public function remove(key : Object) : Object
		{
			var result : Object = null;
			if (this.containsKey(key))
			{
				delete this.props[key];
				var index : int = this._keys.indexOf(key);
				if (index > -1)
				{
					this._keys.splice(index, 1);
				}
			}
			return result;
		}

		/**
		 * 装入一个哈西表
		 * @param	map
		 */
		public function putAll(map : SIMap) : void
		{
			this.clear();
			var len : uint = map.size();
			if (len > 0)
			{
				var arr : Array = map.keys;
				for (var i : uint = 0; i < len; i++)
				{
					this.put(arr[i], map.get(arr[i]));
				}
			}
		}

		/**
		 * 返回hashmap的长度
		 * @return	uint
		 */
		public function size() : uint
		{
			return this._keys.length;
		}

		/**
		 * 判断表是否为空
		 * @return
		 */
		public function isEmpty() : Boolean
		{
			return this.size() < 1;
		}

		/**
		 * 返回所有对象的一个数组
		 * @return
		 */
		public function values() : Array
		{
			var result : Array = new Array();
			var len : uint = this.size();
			if (len > 0)
			{
				for (var i : uint = 0; i < len; i++)
				{
					result.push(this.props[this._keys[i]]);
				}
			}
			return result;
		}

		/**
		 * 返回所有key的一个数组
		 */
		public function get keys() : Array
		{
			return _keys;
		}

		public function get length() : uint
		{
			return _keys.length;
		}
	}

}