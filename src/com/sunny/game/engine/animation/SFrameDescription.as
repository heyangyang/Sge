package com.sunny.game.engine.animation
{

	/**
	 *
	 * <p>
	 * SunnyGame的动画帧描述
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
	public class SFrameDescription
	{
		/**
		 * 动画帧的持续时间
		 */
		public var duration : uint;

		/**
		 * 动画帧的序号，从1开始
		 */
		public var index : uint;
		public var frame : uint;

		/**
		 * 动画帧的x偏移，为中心点相对最小包围框左上角的偏移
		 */
		public var x : int;
		public var offsetX : int;

		/**
		 * 动画帧的y偏移，为中心点相对最小包围框左上角的偏移
		 */
		public var y : int;
		public var offsetY : int;

		public function SFrameDescription()
		{
		}
	}
}