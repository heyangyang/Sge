package com.sunny.game.engine.enum
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个角色状态类型Defintion
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
	public final class SRoleStateType
	{
		/**
		 * 无状态
		 */
		public static const NONE : uint = 0;
		/**
		 * 空闲
		 */
		public static const IDLE : uint = 1;
		/**
		 * 奔跑
		 */
		public static const RUN : uint = 2;
		/**
		 * 攻击
		 */
		public static const ATTACK : uint = 3;
		/**
		 * 施法
		 */
		public static const CAST_SPELL : uint = 4;
		/**
		 * 死亡
		 */
		public static const DEAD : uint = 5;
		/**
		 * 受击
		 */
		public static const HIT : uint = 6; //BEENATTACK受击
		/**
		 * 击退
		 */
		public static const BEAT_BACK : uint = 7;
		/**
		 * 摆摊
		 */
		public static const STALL : uint = 8;
		/**
		 * 打坐
		 */
		public static const SIT : uint = 9;
		/**
		 * 冲锋
		 */
		public static const RUSH : uint = 10;
		/**
		 * 闪烁
		 */
		public static const BLINK : uint = 11;
		/**
		 * 跳跃
		 */
		public static const JUMP : uint = 12;
		/**
		 * 站立
		 */
		public static const STAND : uint = 13;
		/**
		 * 行走
		 */
		public static const WALK : uint = 14;
		/**
		 * 击飞
		 */
		public static const LAUNCH : uint = 15;
		/**
		 * 跌落
		 */
		public static const LAND : uint = 16;
		/**
		 * 起身
		 */
		public static const GET_UP : uint = 17;
		/**
		 * 跳跃跌落
		 */
		public static const JUMP_LAND : uint = 18;
		/**
		 * 已死亡
		 */
		public static const DIED : uint = 19;
		/**
		 * 备战
		 */
		public static const PREWAR : uint = 20;
		/**
		 * 特殊
		 */
		public static const SPECIAL : uint = 99; //一些特殊的状态 , 比如状态触发一些特殊的动作

		public function SRoleStateType()
		{
		}
	}
}