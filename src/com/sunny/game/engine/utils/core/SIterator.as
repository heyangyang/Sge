package com.sunny.game.engine.utils.core
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个迭代器
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
	public class SIterator
	{
		public var data : *;
		public var next : SIterator;

		public function SIterator(data : * = null, prev : SIterator = null)
		{
			if (data)
				this.data = data;

			if (prev)
				prev.next = this;
		}

		public function createNext(data : *) : SIterator
		{
			this.next = new SIterator(data);
			return this.next;
		}

		public static function create(source : Array) : SIterator
		{
			var len : int = source.length;
			if (len == 0)
				return new SIterator();

			var start : SIterator = new SIterator();
			start.data = source[0];
			var cur : SIterator = start;
			for (var i : int = 1; i < len; i++)
			{
				cur.next = new SIterator();
				cur = cur.next;
				cur.data = source[i];
			}
			return start;
		}
	}
}