package com.sunny.game.engine.transition.tween.easing
{

	/**
	 * 指数曲线的缓动（2^t）； 
	 * 爆炸变化，一直很平缓，在最后一点完成所有变化。
	 * @author Administrator
	 *
	 */
	public class SEaseExponential //Expo
	{
		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b - c * 0.001;
		}

		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
		}

		public static const easeInOut : Function = easeInOutFunc;

		private static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			if (t == 0)
				return b;
			if (t == d)
				return b + c;
			if ((t /= d * 0.5) < 1)
				return c * 0.5 * Math.pow(2, 10 * (t - 1)) + b;
			return c * 0.5 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
	}
}