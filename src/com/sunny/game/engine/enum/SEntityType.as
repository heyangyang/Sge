package com.sunny.game.engine.enum
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个实体类型
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
	public final class SEntityType
	{
		/**
		 * 地面类型
		 */
		public static const TYPE_GROUND : uint = 1;
		/**
		 * 特效类型
		 */
		public static const TYPE_EFFECT : uint = 2;
		/**
		 * 主角类型
		 */
		public static const TYPE_CHARACTER : uint = 3;
		/**
		 * 非主角类型
		 */
		public static const TYPE_NON_CHARACTER : uint = 4;
		/**
		 * 传送门类型
		 */
		public static const TYPE_DOOR : uint = 5;
		/**
		 * 怪物类型
		 */
		public static const TYPE_MONSTER : uint = 6;
		/**
		 * 物品类型
		 */
		public static const TYPE_GOODS : uint = 7;
		/**
		 * 坐骑类型
		 */
		public static const TYPE_MOUNT : uint = 8;

		public function SEntityType()
		{
		}
	}
}