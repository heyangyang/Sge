package com.sunny.game.engine.transition.tween.easing
{

	/**
	 * Quad 
	 * 二次方的缓动（t^2）；
	 * 逐渐加速向目标移动再减速停止；二次函数式移动加速度为抛物线；起速慢减速快
	 * 比较普通的缓动。Quadratic平方缓动
	 * @author Administrator
	 *
	 */
	public class SEaseQuadratic //Quad 
	{
		public static const power : uint = 1;

		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return c * (t /= d) * t + b;
		}

		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			return -c * (t /= d) * (t - 2) + b;
		}

		public static const easeInOut : Function = easeInOutFunc;

		private static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number) : Number
		{
			if ((t /= d * 0.5) < 1)
				return c * 0.5 * t * t + b;
			return -c * 0.5 * ((--t) * (t - 2) - 1) + b;
		}
	}
}