package com.sunny.game.engine.transition.tween.easing
{

	/**
	 * Linear
	 * 无缓动效果；
	 * 匀速平移，无加速度变化；
	 * 线性变化，就是匀速。
	 * @author Administrator
	 *
	 */
	public class SEaseLinear //Linear 
	{
		public static const power : uint = 0;

		public static const easeNone : Function = easeNoneFunc;

		/**
		 *
		 * @param t：current time（当前时间）；
		 * @param b：beginning value（初始值）；
		 * @param c：change in value（变化量）；
		 * @param d：duration（持续时间）。
		 * @return
		 *
		 */
		private static function easeNoneFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * t / d + b;
		}

		/**
		 * 缓动方式（方法）： 从0开始加速的缓动；
		 */
		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * t / d + b;
		}

		/**
		 * 缓动方式（方法）：减速到0的缓动；
		 */
		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * t / d + b;
		}

		/**
		 * 缓动方式（方法）：前半段从0开始加速，后半段减速到0的缓动。
		 */
		public static const easeInOut : Function = easeInOutFunc;

		private static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * t / d + b;
		}
	}
}