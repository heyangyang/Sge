package com.sunny.game.engine.transition.tween.easing
{

	/**
	 * 指数衰减的反弹缓动。
	 * 起始点加大弹性系数将物体越弹越远直到越过中点，物体向目标点做弹性系数递衰运动；
	 * 弹跳变化，在变化前会几次回归原点，好像在弹一样。
	 * @author Administrator
	 *
	 */
	public class SEaseBounce
	{
		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			if ((t /= d) < (1 / 2.75))
			{
				return c * (7.5625 * t * t) + b;
			}
			else if (t < (2 / 2.75))
			{
				return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
			}
			else if (t < (2.5 / 2.75))
			{
				return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
			}
			else
			{
				return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
			}
		}

		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c - easeOutFunc(d - t, 0, c, d) + b;
		}

		public static const easeInOut : Function = easeInOutFunc;

		private static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			if (t < d * 0.5)
				return easeInFunc(t * 2, 0, c, d) * .5 + b;
			else
				return easeOutFunc(t * 2 - d, 0, c, d) * .5 + c * .5 + b;
		}
	}
}