package com.sunny.game.engine.transition.tween.easing
{

	/**
	 * 正弦曲线的缓动（sin(t)）；
	 * 像正弦一样的变化
	 * @author Administrator
	 *
	 */
	public class SEaseSinusoidal //Sine
	{
		private static const _HALF_PI : Number = Math.PI * 0.5;

		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return -c * Math.cos(t / d * _HALF_PI) + c + b;
		}

		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * Math.sin(t / d * _HALF_PI) + b;
		}

		public static const easeInOut : Function = easeInOutFunc;

		private static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return -c * 0.5 * (Math.cos(Math.PI * t / d) - 1) + b;
		}
	}
}