package com.sunny.game.engine.utils
{

	/**
	 *
	 * <p>
	 * SunnyGame的物理学工具
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
	public class SPhysicsUtil
	{
		/**
		 * 重力加速度
		 */
		public static const GRAVITY_ACCELERATED_SPEED : Number = 0.0019; //0.0014;

		/**
		 * 跳跃初始速度
		 */
		public static var JUMP_INITIAL_VELOCITY : Number = 0.75; //0.68;

		public function SPhysicsUtil()
		{
		}
	}
}