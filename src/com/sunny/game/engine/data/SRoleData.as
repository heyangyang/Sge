package com.sunny.game.engine.data
{
	import com.sunny.game.engine.enum.SDirection;

	/**
	 *
	 * <p>
	 * SunnyGame的一个角色数据
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
	public class SRoleData extends SEntityData
	{
		/**
		 * 资源
		 */
		public var avatarId : String;
		public var avatarParts : Array;
		/**
		 * 当前是否正在挂机
		 */
		public var isTrusteeship : Boolean;
		public var direction : int = SDirection.EAST;

		/**
		 * 类型
		 */
		public var type : int;


		/**
		 * 拥有者ID
		 */
		public var ownerId : int;

		/**
		 * 是否敌人
		 */
		private var _onIsEnemy : Function;

		/**
		 * 是否对受击免疫
		 */
		public var hit_free : Boolean;

		/**
		 * 是否对击飞击退免疫
		 */
		public var beat_back_free : Boolean;

		/**
		 * 是否对技能硬直免疫
		 */
		public var stiff_free : Boolean;

		/**
		 * 躺地保护时间毫秒默认为0
		 */
		public var fall_protect_t : int;

		/**
		 * 是否黄钻
		 * */
		public var isYellowVip : Boolean;
		/**
		 * 年会员
		 * */
		public var isYellowYearVip : Boolean;
		/**
		 * 会员等级
		 * */
		public var vipYellowLevel : int;
		/**
		 * 超级级会员
		 */
		public var isHightYellowVip : Boolean;

		public function SRoleData()
		{

		}

		public function onIsEnemy(func : Function) : void
		{
			_onIsEnemy = func;
		}

		public function isEnemy(target : SRoleData) : Boolean
		{
			if (_onIsEnemy != null)
				return _onIsEnemy(this, target);
			return false;
		}

		override public function destroy() : void
		{
//			if (depot)
//				depot.destroy();
//			depot = null;

//			_spellList = null;
//			_onIsEnemy = null;
//			super.destroy();
		}
	}
}