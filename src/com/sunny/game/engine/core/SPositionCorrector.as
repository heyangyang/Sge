package com.sunny.game.engine.core
{
	import com.sunny.game.engine.enum.SDirection;
	import com.sunny.game.engine.utils.SCommonUtil;

	/**
	 *
	 * <p>
	 * SunnyGame的一个位置校正器
	 * </p>
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public class SPositionCorrector
	{
		public var x : Number = 0;
		public var y : Number = 0;
		public var dir : int;
		public var dist : int;

		private var _dx : Number = 0;
		private var _dy : Number = 0;
		private var _orignX : int;
		private var _orignY : int;
		private var _correctTime : int;

		public function SPositionCorrector()
		{
		}

		public function init(curX : int, curY : int, targetX : int, targetY : int, correctTime : int) : void
		{
			dist = SCommonUtil.getDistance(curX, curY, targetX, targetY);
			var correctAngle : int = SCommonUtil.getAngle(curX, curY, targetX, targetY);
			dir = SCommonUtil.getDirection(correctAngle);

			_dx = dist * SDirection.COS_DIR[dir];
			_dy = dist * SDirection.SIN_DIR[dir];

			_orignX = curX;
			_orignY = curY;
			_correctTime = correctTime;
		}

		public function calculate(time : int) : void
		{
			// 角色的运动轨迹 orign到dst，根据t进行线性插值, 0 <= t <= 1;
			var t : Number = time / _correctTime;
			x = _orignX + t * _dx;
			y = _orignY + t * _dy;
		}
	}
}