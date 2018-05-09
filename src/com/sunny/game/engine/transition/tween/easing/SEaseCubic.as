package com.sunny.game.engine.transition.tween.easing
{

	/**
	 * Cubic
	 * 三次方的缓动（t^3）；
	 * 立方体变化，跟圆形变化差不多，不过更平滑些。
	 * @author Administrator
	 *
	 */
	public class SEaseCubic //Cubic 
	{
		public static const power : uint = 2;

		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * (t /= d) * t * t + b;
		}

		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * ((t = t / d - 1) * t * t + 1) + b;
		}

		public static const easeInOut : Function = easeInOutFunc;

		private static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			if ((t /= d * 0.5) < 1)
				return c * 0.5 * t * t * t + b;
			return c * 0.5 * ((t -= 2) * t * t + 2) + b;
		}
	}
}