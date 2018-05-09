package com.sunny.game.engine.transition.tween.easing
{

	/**
	 * Back
	 * 超过范围的三次方缓动（(s+1)*t^3 - s*t^2）；
	 * 先反动，再回摆向目标方向加速过中点减速，冲过目标后回摆；
	 * 在缓动前，会先往回运动一段距离。
	 * @author Administrator
	 *
	 */
	public class SEaseBack //Back 
	{
		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number, s : Number = 1.70158) : Number
		{
			return c * (t /= d) * t * ((s + 1) * t - s) + b;
		}

		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number, s : Number = 1.70158) : Number
		{
			return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
		}

		public static const easeInOut : Function = easeInOutFunc;

		private static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number, s : Number = 1.70158) : Number
		{
			if ((t /= d * 0.5) < 1)
				return c * 0.5 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
			return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
		}
	}
}
