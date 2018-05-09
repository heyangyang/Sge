package com.sunny.game.engine.entity
{
	import com.sunny.game.engine.data.SEntityData;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.render.SBaseRenderManager;
	import com.sunny.game.engine.utils.SCommonUtil;
	import com.sunny.game.rpg.entity.SMountEntity;

	/**
	 *
	 * <p>
	 * SunnyGame的角色实体
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
	public class SRoleEntity extends SRenderableEntity
	{
		public static var canRunning : Boolean = true;

		/**
		 * 是否销毁过坐骑
		 */
		public var isDisposeMount : Boolean;

		/**
		 * 是否销毁过光翼
		 */
		public var isDisposeWing : Boolean;

		/**
		 * 是否正在骑乘
		 */
		public var isRiding : Boolean;
		/**
		 * 骑乘类型，站在坐骑上或坐上坐骑上
		 */
		public var rideType : uint;
		/**
		 * 自己的坐骑
		 */
		public var mineMount : SMountEntity;

		/**
		 * 站立骑乘
		 */
		public static const RIDE_TYPE_STAND : uint = 1;
		/**
		 * 盘坐骑乘
		 */
		public static const RIDE_TYPE_SIT : uint = 3;

		/**
		 * 角色已死亡
		 */
		public static const CALL_ROLE_DIED : String = "CALL_ROLE_DIED";
		/**
		 * 角色安全区域改变
		 */
		public static const EVENT_ROLE_SAFE_AREA_CHANGE : String = "EVENT_ROLE_SAFE_AREA_CHANGE";
		public static const CALL_ROLE_RUNNING_CHANGED : String = "CALL_ROLE_RUNNING_CHANGED";

		private var _followEntities : Vector.<SRoleEntity>;

		private var _shakeX : Number = 0;
		private var _shakeY : Number = 0;

		public var hitLeft : int = 0;
		public var hitRight : int = 0;
		public var hitTop : int = 0;
		public var hitBottom : int = 0;
		public var hitOffsetZ : int = 0;

		/**
		 * 拥有者
		 */
		public var owner : SRoleEntity;

		/**
		 * 是否正在寻路
		 */
		private var _isRoadSeeking : Boolean = false;

		public var releaseSpellShake : Boolean = false;

		public var jumpMoving : Boolean = false;

		public function set shakeX(value : Number) : void
		{
			_shakeX = value;
		}

		public function set shakeY(value : Number) : void
		{
			_shakeY = value;
		}

		public function get shakeX() : Number
		{
			return _shakeX;
		}

		public function get shakeY() : Number
		{
			return _shakeY;
		}

		public function get isRoadSeeking() : Boolean
		{
			return _isRoadSeeking;
		}

		public function set isRoadSeeking(value : Boolean) : void
		{
			_isRoadSeeking = value;
		}

		/**
		 * 服务器上是否删除了，客户端标志要清除的，则标志服务器已经删除了
		 */
		//public var isServerRemoved : Boolean = false;

		/**
		 * 是否BUFFER 引起的能否攻击
		 */
		public var fightable : Boolean = true;

		/**
		 * 受击技能动画等引起的能否移动
		 */
		private var _movable : Boolean = true;

		/**
		 * 正在被沉默了
		 */
		public var isHush : Boolean;

		/**
		 * 是否魔法免疫
		 */
		public var isMagicImmunity : Boolean;

		//public var isLossLife : Boolean = false;
		/**
		 * 被攻击中
		 */
		public var isBeenAttacking : Boolean = false;

		/**
		 * 保护中
		 */
		public var isSafeguard : Boolean = false;

		/**
		 * 是否无敌
		 */
		public var isInvincible : Boolean = false;

		public var isRushing : Boolean = false;
		public var isBeatBacking : Boolean = false;
		public var isLaunching : Boolean = false;

		public var forwardMoveSpeed : Number = 0;

		public function get isForwardMoving() : Boolean
		{
			return forwardMoveSpeed > 0;
		}

		/**
		 * 提示信息,npc任务提示信息表，npc提示信息 0代表无提示，1代表感叹号，2代表灰色问号，3代表金黄色问号
		 */
		public var tipType : int;

		public var canAutoWalkToMe : Boolean;

		/**
		 * 当前是否处理变身状态
		 */
		public var isTransformd : Boolean;

		/**
		 * 正在场景选择区域块以释放技能
		 */
		public var isSelectingSpellGround : Boolean;

		/**
		 * 是否需要检测PK
		 */
		public var needCheckPK : Boolean = false;
		/**
		 * 是否在安全区域
		 */
		private var _isInSafeArea : Boolean = false;

		/**
		 * 是否需要检测碰撞
		 */
		public var needCheckCollision : Boolean = false;

		public var needPickEnity : Boolean = true;

		/**
		 * 是否需要继续攻击
		 */
		public var needContinueAttack : Boolean = false;

		/**
		 * 当前攻击目标
		 */
		//public var attackTarget : SRoleEntity;

		public var beenAttactedEnemys : Array = [];

		private var _isMe : Boolean;
		/**
		 * 是否是自己相关的
		 */
		private var _isMineRole : Boolean;

		/**
		 * 当前是否正在挂机，如果正在挂机则显示正在挂机图标
		 */
		public var isTrusteeship : Boolean;
		/**
		 * 是否放弃渲染
		 * */
		private var _isDisableRender : Boolean;


		private var _superArmorTime : int = 0;

		public function set superArmorTime(value : int) : void
		{
			_superArmorTime = value;
		}

		public function get superArmorTime() : int
		{
			return _superArmorTime;
		}

		/**
		 * 是否处于霸体
		 * @return
		 *
		 */
		public function get isSuperArmoring() : Boolean
		{
			return _superArmorTime > 0;
		}

		private var _confuseTime : int;

		public function get confuseTime() : int
		{
			return _confuseTime;
		}

		public function set confuseTime(value : int) : void
		{
			_confuseTime = value;
		}

		/**
		 * 是否处于混乱
		 * @return
		 *
		 */
		public function get isConfusing() : Boolean
		{
			return _confuseTime > 0;
		}

		private var _freezeTime : int;

		public function get freezeTime() : int
		{
			return _freezeTime;
		}

		public function set freezeTime(value : int) : void
		{
			_freezeTime = value;
		}

		/**
		 * 是否处于冻结
		 * @return
		 *
		 */
		public function get isFreezing() : Boolean
		{
			return _freezeTime > 0;
		}

		/**
		 * 开始打坐时间
		 */
		private var _startSitTime : int;

		/**
		 * 当前打坐时间
		 */
		private var _currSitTime : int;

		/**
		 * 是否新手村的鸟
		 */
		public var isBird : Boolean;

		private var _unMovableTicked : int;
		private var _unFightableTicked : int;
		private var _hushTicked : int;

		//public var attackSpellList : Vector.<SSpellData>;

		/**
		 * 构造函数
		 * @param roleXML
		 * @param actionArray
		 *
		 */
		public function SRoleEntity(entityType : int, data : SEntityData, render : SBaseRenderManager = null)
		{
			moveSpeed = 0.18;
			height = 90;
			owner = null;
			//isDying = false;
			//isLossLife = false;
			//isDeathCD = false;
			isSelectingSpellGround = false;
			fightable = true;
			_movable = true;
			canAutoWalkToMe = true;
			_followEntities = new Vector.<SRoleEntity>();

			super(data.id, data.name, entityType, render);
			setData(data);
		}

		protected function setData(data : SEntityData) : void
		{
			this._data = data;
//			id = data.id;
//			name = data.name;
			if (data.gridX < 0 || data.gridY < 0)
			{
				mapX = 200;
				mapY = 200;
			}
			else
			{
				mapX = SCommonUtil.getPixelXByGrid(data.gridX) + data.offsetX;
				mapY = SCommonUtil.getPixelYByGrid(data.gridY) + data.offsetY;
			}
		}

		/*public function setMovable(value : Boolean) : void
		   {
		   //			trace(name ,'设置是否移动:' , value);
		   if (!value)
		   _unMovableTicked++;
		   else
		   _unMovableTicked--;
		   if (value)
		   {
		   if (_unMovableTicked <= 0)
		   {
		   _movable = value;
		   _unMovableTicked = 0;
		   }
		   }
		   else
		   {
		   _movable = value;
		   if (!isJumpState)
		   idle();
		   }
		 }*/

		public function setFightable(value : Boolean) : void
		{
			if (!value)
				_unFightableTicked++;
			else
				_unFightableTicked--;
			if (value)
			{
				if (_unFightableTicked <= 0)
				{
					fightable = value;
					_unFightableTicked = 0;
				}
			}
			else
				fightable = value;
		}

		/**
		 * 设置沉默
		 * @param value
		 */
		public function setHush(value : Boolean) : void
		{
			if (value)
				_hushTicked++;
			else
				_hushTicked--;
			if (!value)
			{
				if (_hushTicked <= 0)
				{
					isHush = value;
					_hushTicked = 0;
				}
			}
			else
			{
				isHush = value;
			}
		}









//		public function get canCastspell() : Boolean
//		{
//			return canAttack;
//		}



//		public function get canStand() : Boolean
//		{
//			return !isDeadState;
//		}
//
//		public function get canStall() : Boolean
//		{
//			return !isDeadState && !isAttackState && !isCastSpellState && !isBeatBackState && !isRunState && !isBlink && !isJumpState;
//		}

//		public function get canSit() : Boolean
//		{
//			return !isDeadState && !isAttackState && !isHitState && !isCastSpellState && !isStall && !isBeatBackState && !isRunState && !isBlink && !isJumpState;
//		}
//
//		
//
//		
//
//		public function get canBlink() : Boolean
//		{
//			return canWalk;
//		}
























//
//		
//
//		/**
//		 * 是否施法状态
//		 * @return
//		 *
//		 */
//		public function get isCastSpellState() : Boolean
//		{
//			return state == SStateType.CAST_SPELL;
//		}
//
//		
//
//		
//
//		
//
//		public function get isStall() : Boolean
//		{
//			return state == SStateType.STALL;
//		}
//
//		public function get isSit() : Boolean
//		{
//			return state == SStateType.SIT;
//		}



//		public function get isBlink() : Boolean
//		{
//			return state == SStateType.BLINK;
//		}

		public function get isRemoteAttack() : Boolean
		{
			return false;
		}

		/**
		 * 被击晕
		 * @return
		 */
		public function get isStun() : Boolean
		{
			return !_movable && !fightable;
		}

		/**
		 * 删除外放坐骑
		 *
		 */
		public function removeMount() : void
		{
			if (mineMount)
			{
				mineMount.destroy();
				mineMount = null;
			}
		}

		override public function destroy() : void
		{
			if (!isActive)
				return;
			removeMount();
			owner = null;

			if (_followEntities)
			{
				for each (var entity : SRoleEntity in _followEntities)
					entity.destroy();
				_followEntities.length = 0;
				_followEntities = null;
			}
			super.destroy();
		}

		/**
		 * 是一个主角
		 * @return
		 *
		 */
		public function isCharacter() : Boolean
		{
			return false;
		}

		/**
		 * 是一个NPC
		 * @return
		 *
		 */
		public function isNonCharacter() : Boolean
		{
			return false;
		}

		/**
		 * 是一个怪物
		 * @return
		 *
		 */
		public function isMonster() : Boolean
		{
			return false;
		}

		/**
		 * 是一个坐骑
		 * @return
		 *
		 */
		public function isMount() : Boolean
		{
			return false;
		}

//		private var _tick : int = 0;
//		private var _enemyCountTime : int;

		/*public function beenAttacked(attacker : SRoleEntity) : void
		   {
		   //_enemyCountTime = 0;
		   _enemy = attacker;
		 }*/

		public function get movable() : Boolean
		{
			return _movable;
		}

		public function set movable(value : Boolean) : void
		{
			_movable = value;
//			if (isMe)
//				SMonitor.getInstance().appendDebugInfo("是否可移动：" + (_movable ? "是" : "否"));
		}

		/**
		 * 是否正在空中
		 * @return
		 *
		 */
		public function get isInTheAir() : Boolean
		{
//			var isJumpState : Boolean = state.isJumpState;
//			if (!isJumpState)
//			{
//				var jumpComp : SJumpComponent = getComponent(SJumpComponent) as SJumpComponent;
//				if (jumpComp && jumpComp.isFlying)
//					isJumpState = true;
//			}
//			return isJumpState;
			return mapZ > 0;
		}

		public function get isInSafeArea() : Boolean
		{
			return _isInSafeArea;
		}

		public function set isInSafeArea(value : Boolean) : void
		{
			if (value == _isInSafeArea)
				return;
			_isInSafeArea = value;
			SEvent.dispatchEvent(EVENT_ROLE_SAFE_AREA_CHANGE, this);
		}

		public function get isMe() : Boolean
		{
			return _isMe;
		}

		public function set isMe(value : Boolean) : void
		{
			_isMe = value;
		}

		public function get isMineRole() : Boolean
		{
			return _isMineRole;
		}

		public function set isMineRole(value : Boolean) : void
		{
			_isMineRole = value;
		}

		public function getFollowEntity(id : int) : SRoleEntity
		{
			for each (var entity : SRoleEntity in _followEntities)
			{
				if (entity.id == id)
					return entity;
			}
			return null;
		}

		public function removeFollowEntity(id : int) : void
		{
			for each (var entity : SRoleEntity in _followEntities)
			{
				if (entity.id == id)
				{
					entity.destroy();
					_followEntities.splice(_followEntities.indexOf(entity), 1);
					return;
				}
			}
		}

		public function addFollowEntity(entity : SRoleEntity) : void
		{
			_followEntities.push(entity);
		}

		/**
		 * 是否处于死亡状态
		 * @return
		 *
		 */
		public function get isDied() : Boolean
		{
			return false;
		}

		public function get isPrepareWar() : Boolean
		{
			return false;
		}

		public function set isDisableRender(value : Boolean) : void
		{
			if (_isDisableRender == value)
				return;
			_isDisableRender = value;
			for each (var f : SRoleEntity in _followEntities)
			{
				f.showAvatar(!_isDisableRender);
			}
		}

		public function get isDisableRender() : Boolean
		{
			return _isDisableRender;
		}

		override public function showAvatar(value : Boolean) : void
		{
			super.showAvatar(value);
			isDisableRender = !value;
		}
	}
}