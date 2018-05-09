package com.sunny.game.engine.enum
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个AI状态类型Defintion
	 * Definition
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
	public class SAiStateType
	{
		/**
		 * 无状态
		 */
		public static const NONE : uint = 0;
		/**
		 * 停留状态
		 */
		public static const STAY : uint = 1;
		/**
		 * 巡逻状态
		 */
		public static const PATROL : uint = 2;
		/**
		 * 追逐状态
		 */
		public static const CHASE : uint = 3;
		/**
		 * 僵持状态
		 */
		public static const STALEMATE : uint = 4;
		/**
		 * 靠近状态
		 */
		public static const APPROACH : uint = 5;
		/**
		 * 攻击状态
		 */
		public static const ATTACK : uint = 6;
		/**
		 * 逃跑状态
		 */
		public static const FLEE : uint = 7;
		/**
		 * 寻路状态
		 */
		public static const SEEK : uint = 8;
		/**
		 * 闪开状态
		 */
		public static const JINK : uint = 9;

		public function SAiStateType()
		{
		}
	}
}