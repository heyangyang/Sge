package com.sunny.game.engine.utils
{
	import flash.utils.getTimer;

	/**
	 *
	 * <p>
	 * SunnyGame的一个随机种子
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
	public class SRandom
	{
		private const MAX_RATIO : Number = 1 / uint.MAX_VALUE;
		private var r : uint;

		public function SRandom(seed : uint = 0)
		{
			r = seed || getTimer();
		}

		//  returns a random Number from 0 – 1
		public function getNext() : Number
		{
			r ^= (r << 21);
			r ^= (r >>> 35);
			r ^= (r << 4);
			return (r * MAX_RATIO);
		}
	}
}