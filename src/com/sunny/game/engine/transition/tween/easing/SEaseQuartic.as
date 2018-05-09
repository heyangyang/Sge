package com.sunny.game.engine.transition.tween.easing
{
	/**
	 * 四次方的缓动（t^4）； 
	 * 四分之一变化，Quart是Quarter的意思，有1/4的时间是没有缓动。 
	 * @author Administrator
	 * 
	 */
	public class SEaseQuartic//Quart
	{
		public static const power : uint = 3;

		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * (t /= d) * t * t * t + b;
		}

		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return -c * ((t = t / d - 1) * t * t * t - 1) + b;
		}

		public static const easeInOut : Function = easeInOutFunc;

		public static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			if ((t /= d * 0.5) < 1)
				return c * 0.5 * t * t * t * t + b;
			return -c * 0.5 * ((t -= 2) * t * t * t - 2) + b;
		}
	}
}