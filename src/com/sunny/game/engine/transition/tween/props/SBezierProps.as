package com.sunny.game.engine.transition.tween.props
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.ns.sunny_tween;

	import flash.geom.Point;

	/**
	 *
	 * <p>
	 * SunnyGame的一个贝塞尔曲线属性
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
	public class SBezierProps extends SObject
	{
		public var through : Boolean;
		private var _curvePoints : Vector.<Point>;

		public function SBezierProps()
		{
			super();
			through = false;
			_curvePoints = new Vector.<Point>();
		}

		/**
		 * 向某个点弯曲
		 * @param x
		 * @param y
		 *
		 */
		public function curveTo(x : Number, y : Number) : void
		{
			_curvePoints.push(new Point(x, y));
		}

		sunny_tween function get curvePoints() : Vector.<Point>
		{
			return _curvePoints;
		}
	}
}