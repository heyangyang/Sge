package com.sunny.game.engine.utils
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个数学相关方法
	 * </p>
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @see SEvent
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public class SMathUtil
	{
		public static const TWO_PI : Number = Math.PI * 2.0;

		/**
		 * 将数值限制在一个区间内
		 *
		 * @param v	数值
		 * @param min	最大值
		 * @param max	最小值
		 *
		 */
		public static function limitIn(v : Number, min : Number, max : Number) : Number
		{
			return v < min ? min : v > max ? max : v;
		}

		/**
		 * 返回的是数学意义上的atan（坐标系与Math.atan2上下颠倒）
		 *
		 * @param dx
		 * @param dy
		 * @return
		 *
		 */
		public static function atan2(dx : Number, dy : Number) : Number
		{
			var a : Number;
			if (dx == 0)
				a = Math.PI / 2;
			else if (dx > 0)
				a = Math.atan(Math.abs(dy / dx));
			else
				a = Math.PI - Math.atan(Math.abs(dy / dx));

			return dy >= 0 ? a : -a;

		}

		/**
		 * 求和
		 *
		 * @param arr
		 * @return
		 *
		 */
		public static function sum(arr : Array) : Number
		{
			var result : Number = 0.0;
			for each (var num : Number in arr)
				result += num;
			return result;
		}

		/**
		 * 平均值
		 *
		 * @param arr
		 * @return
		 *
		 */
		public static function avg(arr : Array) : Number
		{
			return sum(arr) / arr.length;
		}

		/**
		 * 最大值
		 *
		 * @param arr
		 * @return
		 *
		 */
		public static function max(arr : Array) : Number
		{
			var result : Number = NaN;
			for (var i : int = 0; i < arr.length; i++)
			{
				if (isNaN(result) || arr[i] > result)
					result = arr[i];
			}
			return result;
		}

		/**
		 * 最小值
		 *
		 * @param arr
		 * @return
		 *
		 */
		public static function min(arr : Array) : Number
		{
			var result : Number = NaN;
			for (var i : int = 0; i < arr.length; i++)
			{
				if (isNaN(result) || arr[i] < result)
					result = arr[i];
			}
			return result;
		}

		/**
		 * 两个角的最小差
		 *
		 * @param r1 起点
		 * @param r1终点
		 * @return
		 *
		 */
		public static function shortRotation(r1 : Number, r2 : Number, useRadians : Boolean = true) : Number
		{
			var cap : Number = useRadians ? Math.PI * 2 : 360;
			var dif : Number = (r2 - r1) % cap;
			if (dif != dif % (cap / 2))
			{
				dif = (dif < 0) ? dif + cap : dif - cap;
			}
			return dif;
		}
	}
}