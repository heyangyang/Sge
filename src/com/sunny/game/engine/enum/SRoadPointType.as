package com.sunny.game.engine.enum
{

	/**
	 *
	 * <p>
	 * SunnyGame的路点类型
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
	public class SRoadPointType
	{
		/**
		 * 可行走区域
		 */
		public static const WALKABLE_VALUE : int = 127;
		/**
		 * 遮罩区域
		 */
		public static const MASKABLE_VALUE : int = 63;
		/**
		 * 不可行走区域
		 */
		public static const UNWALKABLE_VALUE : int = 0;
		/**
		 * PK区域
		 */
		public static const SAFE_VALUE : int = 31;
		/**
		 * PK区域并且遮罩区域
		 */
		public static const SAFE_MASKABLE_VALUE : int = 93;
		/**
		 * 跳跃区域
		 */
		public static const JUMP_VALUE : int = 7;

		public function SRoadPointType()
		{
		}
	}
}