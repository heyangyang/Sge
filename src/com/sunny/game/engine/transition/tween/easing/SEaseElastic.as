package com.sunny.game.engine.transition.tween.easing
{
	/**
	 * 指数衰减的正弦曲线缓动； 
	 * 从起始点开始运动，围绕起始点作摆幅增大运动，越过中点后向目标点做摆幅递衰运动； 
	 * 橡皮圈变化，跟Back变化有点像，但是会有一个很强的波动。在EaseIn和EaseOut时尤为明显。
	 * @author Administrator
	 *
	 */
	public class SEaseElastic
	{
		private static const TWO_PI : Number = Math.PI * 2.0;
		public static const easeIn : Function = easeInFunc;

		private static function easeInFunc(t : Number, b : Number, c : Number, d : Number, a : Number = 0, p : Number = 0) : Number
		{
			var s : Number;
			if (t == 0)
				return b;
			if ((t /= d) == 1)
				return b + c;
			if (!p)
				p = d * .3;
			if (!a || (c > 0 && a < c) || (c < 0 && a < -c))
			{
				a = c;
				s = p / 4;
			}
			else
				s = p / TWO_PI * Math.asin(c / a);
			return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * TWO_PI / p)) + b;
		}

		public static const easeOut : Function = easeOutFunc;

		private static function easeOutFunc(t : Number, b : Number, c : Number, d : Number, a : Number = 0, p : Number = 0) : Number
		{
			var s : Number;
			if (t == 0)
				return b;
			if ((t /= d) == 1)
				return b + c;
			if (!p)
				p = d * .3;
			if (!a || (c > 0 && a < c) || (c < 0 && a < -c))
			{
				a = c;
				s = p / 4;
			}
			else
				s = p / TWO_PI * Math.asin(c / a);
			return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * TWO_PI / p) + c + b);
		}

		public static const easeInOut : Function = easeOutFunc;

		private static function easeInOutFunc(t : Number, b : Number, c : Number, d : Number, a : Number = 0, p : Number = 0) : Number
		{
			var s : Number;
			if (t == 0)
				return b;
			if ((t /= d * 0.5) == 2)
				return b + c;
			if (!p)
				p = d * (.3 * 1.5);
			if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) //if (!a || a < Math.abs(c))
			{
				a = c;
				s = p / 4;
			}
			else
				s = p / TWO_PI * Math.asin(c / a);
			if (t < 1)
				return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * TWO_PI / p)) + b;
			return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * TWO_PI / p) * .5 + c + b;
		}
	}
}