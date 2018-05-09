package com.sunny.game.engine.enum
{
	import com.sunny.game.engine.debug.SDebug;

	/**
	 *
	 * <p>
	 * SunnyGame的动作类型
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
	public final class SActionType
	{

		/**
		 * 无动作
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
		 * 跳跃
		 */
		public static const JUMP : uint = 3;
		/**
		 * 骑乘空闲
		 */
		public static const RIDE_IDLE : uint = 4;
		/**
		 * 骑乘行走
		 */
		public static const RIDE_WALK : uint = 5;
		/**
		 * 骑乘奔跑
		 */
		public static const RIDE_RUN : uint = 6;
		/**
		 * 坐下
		 */
		public static const SIT : uint = 7;
		/**
		 * 死亡
		 */
		public static const DIE : uint = 8;
		/**
		 * 起身
		 */
		public static const GET_UP : uint = 9;
		/**
		 * 击飞
		 */
		public static const LAUNCH : uint = 10;
		/**
		 * 跌落
		 */
		public static const LAND : uint = 11;
		/**
		 * 冲刺
		 */
		public static const DASH : uint = 12;

		/**
		 * 攻击
		 */
		public static const ATTACK : uint = 13;

		/**
		 * 行走
		 */
		public static const WALK : uint = 14;

		/**
		 * 受击
		 */
		public static const HIT : uint = 15; //BEEN_ATTACKE
		/**
		 * 备战
		 */
		public static const PREWAR : uint = 16;

//		/**
//		 * 攻击1
//		 */
//		public static const ATTACK1 : uint = 101;
//		/**
//		 * 攻击2
//		 */
//		public static const ATTACK2 : uint = 102;
//		/**
//		 * 攻击3
//		 */
//		public static const ATTACK3 : uint = 103;
//		/**
//		 * 攻击4
//		 */
//		public static const ATTACK4 : uint = 104;
//		/**
//		 * 攻击5
//		 */
//		public static const ATTACK5 : uint = 105;
//		/**
//		 * 攻击6
//		 */
//		public static const ATTACK6 : uint = 106;
//		/**
//		 * 攻击7
//		 */
//		public static const ATTACK7 : uint = 107;
//		/**
//		 * 攻击8
//		 */
//		public static const ATTACK8 : uint = 108;
//		/**
//		 * 攻击9
//		 */
//		public static const ATTACK9 : uint = 109;
//		/**
//		 * 攻击10
//		 */
//		public static const ATTACK10 : uint = 110;
//		/**
//		 * 攻击11
//		 */
//		public static const ATTACK11 : uint = 111;
//		/**
//		 * 攻击12
//		 */
//		public static const ATTACK12 : uint = 112;
//		/**
//		 * 攻击13
//		 */
//		public static const ATTACK13 : uint = 113;
//		/**
//		 * 攻击14
//		 */
//		public static const ATTACK14 : uint = 114;
//		/**
//		 * 攻击15
//		 */
//		public static const ATTACK15 : uint = 115;
//		/**
//		 * 攻击16
//		 */
//		public static const ATTACK16 : uint = 116;
//		/**
//		 * 攻击17
//		 */
//		public static const ATTACK17 : uint = 117;
//		/**
//		 * 攻击18
//		 */
//		public static const ATTACK18 : uint = 118;
//		/**
//		 * 攻击19
//		 */
//		public static const ATTACK19 : uint = 119;
//		/**
//		 * 攻击20
//		 */
//		public static const ATTACK20 : uint = 120;
//
//		/**
//		 * 受击1
//		 */
//		public static const HIT1 : uint = 201;
//		/**
//		 * 受击2
//		 */
//		public static const HIT2 : uint = 202;


		/* public static const STAND   : String = "和平站立";

		public static const FIGHTSTAND   : String = "战斗站立";


		public static const ATTACKDELAY  : String = "单手近战延时";


		public static const ATTACK1DELAY : String = "单手一连击延时";


		public static const ATTACK2DELAY : String = "单手二连击延时";


		public static const ATTACK3DELAY : String = "单手三连击延时";

		public static const ROTATE  : String = "附加五";


		public static const CASTSPELL : String  = "单手近战";


		public static const MOUNT_WALK : String  = "坐骑移动";
		public static const MOUNT_STAND : String  = "坐骑战斗站立";
		*/

//		public static const ACTION_MULTI_TYPE_MAP:Array=[null,null,null,null,null,//
//			null,null,null,null,null,//
//			null,null,null,null,//
//			[ATTACK1,ATTACK2,ATTACK3,ATTACK4,ATTACK5,ATTACK6,ATTACK7,ATTACK8,ATTACK9,ATTACK10,ATTACK11,ATTACK12,ATTACK13,ATTACK14,ATTACK15,ATTACK16,ATTACK17,ATTACK18,ATTACK19,ATTACK20],[HIT1,HIT2]//
//		];

		public static const ACTION_TYPE_MAP : Array = [IDLE, RUN, JUMP, RIDE_IDLE, RIDE_WALK, //
			RIDE_RUN, SIT, DIE, GET_UP, LAUNCH, //
			LAND, DASH, ATTACK, WALK, HIT, PREWAR //
			/*,//
			ATTACK1,ATTACK2,ATTACK3,ATTACK4,ATTACK5,ATTACK6,ATTACK7,ATTACK8,ATTACK9,ATTACK10,//
			ATTACK11,ATTACK12,ATTACK13,ATTACK14,ATTACK15,ATTACK16,ATTACK17,ATTACK18,ATTACK19,ATTACK20,//
			HIT1,HIT2*/];
		public static const ACTION_NAME_MAP : Array = ["idle", "run", "jump", "ride_idle", "ride_walk", //
			"ride_run", "sit", "die", "getup", "launch", //
			"land", "dash", "attack", "walk", "hit", "prewar" /*,//
			//
			"attack1","attack2","attack3","attack4","attack5","attack6","attack7","attack8","attack9","attack10",//
			"attack11","attack12","attack13","attack14","attack15","attack16","attack17","attack18","attack19","attack20",//
			"hit1","hit2"*/];
		public static const ACTION_CHINESE_NAME_MAP : Array = ["空闲", "奔跑", "跳跃", "骑乘空闲", "骑乘行走", //
			"骑乘奔跑", "坐下", "死亡", "起身", "击飞", //
			"跌落", "冲刺", "攻击", "行走", "受击", "备战" /*,//
			//
			"攻击一","攻击二","攻击三","攻击四","攻击五","攻击六","攻击七","攻击八","攻击九","攻击十",//
			"攻击十一","攻击十二","攻击十三","攻击十四","攻击十五","攻击十六","攻击十七","攻击十八","攻击十九","攻击二十",
			"受击一","受击二"*/];

		public static function getActionTypeByName(name : String) : uint
		{
			var index : int = ACTION_NAME_MAP.indexOf(name.toLowerCase());
			if (index != -1)
				return ACTION_TYPE_MAP[index];
			if (SDebug.OPEN_WARNING_TRACE)
				SDebug.warningPrint(name, "没有动作名称为%s的动作类型！", name);
			return 0;
		}

		public static function getActionTypeByChineseName(name : String) : uint
		{
			var index : int = ACTION_CHINESE_NAME_MAP.indexOf(name.toLowerCase());
			if (index != -1)
				return ACTION_TYPE_MAP[index];
			if (SDebug.OPEN_WARNING_TRACE)
				SDebug.warningPrint(name, "没有动作中文名称为%s的动作类型！", name);
			return 0;
		}

		public static function getActionNameByType(type : uint) : String
		{
			var index : int = ACTION_TYPE_MAP.indexOf(type);
			if (index != -1)
				return ACTION_NAME_MAP[index];
			if (SDebug.OPEN_WARNING_TRACE)
				SDebug.warningPrint(type, "没有动作类型为%s的动作名称！", type);
			return null;
		}

		public static function getActionChineseNameByType(type : uint) : String
		{
			var index : int = ACTION_TYPE_MAP.indexOf(type);
			if (index != -1)
				return ACTION_CHINESE_NAME_MAP[index];
			if (SDebug.OPEN_WARNING_TRACE)
				SDebug.warningPrint(type, "没有动作类型为%s的动作中文名称！", type);
			return null;
		}

		public static function getActionChineseNameByName(name : String) : String
		{
			var action : uint = getActionTypeByName(name);
			return getActionChineseNameByType(action);
		}

		public static function getTypeAndKindByName(name : String) : Array
		{
			if (!name)
				return null;
			name = name.toLowerCase();
			for each (var actionName : String in ACTION_NAME_MAP)
			{
				if (name.indexOf(actionName) == 0)
				{
					var kind : uint = parseInt(name.substring(actionName.length));
					var index : int = ACTION_NAME_MAP.indexOf(actionName);
					return [ACTION_TYPE_MAP[index], kind];
				}
			}
			if (SDebug.OPEN_WARNING_TRACE)
				SDebug.warningPrint(name, "没有动作名称为%s的动作类型！", name);
			return null;
		}

//		public static function isAttackAction(action : uint) : Boolean
//		{
//			switch (action)
//			{
//				case ATTACK:
//					return true;
//				case ATTACK1:
//					return true;
//				case ATTACK2:
//					return true;
//				case ATTACK3:
//					return true;
//				case ATTACK4:
//					return true;
//				case ATTACK5:
//					return true;
//				case ATTACK6:
//					return true;
//				case ATTACK7:
//					return true;
//				case ATTACK8:
//					return true;
//				case ATTACK9:
//					return true;
//				case ATTACK10:
//					return true;
//				case ATTACK11:
//					return true;
//				case ATTACK12:
//					return true;
//				case ATTACK13:
//					return true;
//				case ATTACK14:
//					return true;
//				case ATTACK15:
//					return true;
//				case ATTACK16:
//					return true;
//				case ATTACK17:
//					return true;
//				case ATTACK18:
//					return true;
//				case ATTACK19:
//					return true;
//				case ATTACK20:
//					return true;
//			}
//			return false;
//		}
	}
}