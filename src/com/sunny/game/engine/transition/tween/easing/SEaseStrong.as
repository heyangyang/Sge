package com.sunny.game.engine.transition.tween.easing
{
	/**
	 * 直接加速过中点再加速至目标停止；一次函数式移动加速度为直线；起速快减速慢 
	 * 很强的变化 
	 * @author Administrator
	 * 
	 */
	public class SEaseStrong
	{
		public static const power : uint = 4;

		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * (t /= d) * t * t * t * t + b;
		}

		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}

		public static const easeInOut : Function = easeInOutFunc;

		private static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			if ((t /= d * 0.5) < 1)
				return c * 0.5 * t * t * t * t * t + b;
			return c * 0.5 * ((t -= 2) * t * t * t * t + 2) + b;
		}
	}
}
