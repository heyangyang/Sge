package com.sunny.game.engine.transition.tween.easing
{

	/**
	 * Circ
	 * 圆形曲线的缓动（sqrt(1-t^2)）；
	 * 圆形变化，运动的曲线是一个圆形的弧度。
	 * @author Administrator
	 *
	 */
	public class SEaseCircular //Circ 
	{
		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
		}

		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
		}

		public static const easeInOut : Function = easeInOutFunc;

		private static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			if ((t /= d * 0.5) < 1)
				return -c * 0.5 * (Math.sqrt(1 - t * t) - 1) + b;
			return c * 0.5 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
		}
	}
}