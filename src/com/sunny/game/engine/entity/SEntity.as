package com.sunny.game.engine.entity
{
	import com.sunny.game.engine.component.SIComponent;
	import com.sunny.game.engine.core.SComponent;
	import com.sunny.game.engine.core.SIResizable;
	import com.sunny.game.engine.core.SIUpdatable;
	import com.sunny.game.engine.core.SUpdatable;
	import com.sunny.game.engine.data.SEntityData;
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.rpg.component.animation.SRoleAnimationComponent;

	import flash.utils.Dictionary;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的基础实体对象
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
	public class SEntity extends SUpdatable implements SIEntity, SIResizable
	{
		/**
		 * 乘骑武器特效
		 */
		public static const RIDE_WEAPON_EFFECT : String = "ride_weapon_effect";
		/**
		 * 套装特效
		 */
		public static const SUIT_EFFECT : String = "suit_effect";
		/**
		 * 强化特效
		 */
		public static const STRENGTHEN_EFFECT : String = "strengthen_effect";
		/**
		 * 组队光环
		 */
		public static const EXP_GUANGHUAN : String = "expGuangHuan";
		/**
		 * 法宝固定id
		 */
		public static const MAGIC_WEAPON_ID_CONST : int = 100000000;

		public static const ADD_COMPONENT_SUCCESS : int = 0;
		public static const ADD_COMPONENT_COMP_NULL : int = 1;
		public static const ADD_COMPONENT_EXIST_GROUP_TYPE : int = 2;
		public static const ADD_COMPONENT_EXIST_OWNER : int = 3;

		private static var _updaters : int;

		private var _componentByType : Dictionary;
		private var _attrs : Dictionary;

		private var _compAdditionIndex : int;
		protected var _id : int;
		protected var _name : String;
		protected var _data : SEntityData;
		private var _numUpdatable : uint;
		/**
		 * 更新权限
		 * */
		public var power : int;

		/**
		 * 状态
		 */
		protected var _state : SIEntityState;

		public function SEntity(id : int, name : String)
		{
			_id = id;
			_name = name;
			_componentByType = new Dictionary(true);
			super();
		}

		public function addComponent(comp : SIComponent, priority : int = 0) : int
		{
			if (!isActive)
				return 4;
			if (!comp)
			{
				return ADD_COMPONENT_COMP_NULL;
			}
			if (!comp.type)
				throw new SunnyGameEngineError("添加组件类型为空！");

			if (_componentByType[comp.type])
			{
				return ADD_COMPONENT_EXIST_GROUP_TYPE;
			}

			if (comp.owner)
			{
				return ADD_COMPONENT_EXIST_OWNER;
			}
			comp.additionIndex = _compAdditionIndex++;
			if (comp is SIUpdatable)
			{
				(comp as SIUpdatable).priority = priority;
				_updatables.push(comp);
				if (priority != 0)
					_updatables.sortOn(['priority', 'additionIndex'], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC]);
			}
			_componentByType[comp.type] = comp;
			comp.owner = this;

			comp.notifyAdded();
			if (comp is SRoleAnimationComponent)
				_roleAnimationComp = comp as SRoleAnimationComponent;

			return ADD_COMPONENT_SUCCESS;
		}

		public function removeComponentByType(type : *) : void
		{
			removeComponent(getComponent(type));
		}

		public function removeComponent(comp : SIComponent) : void
		{
			if (!comp)
				return;
			if (!isActive)
				return;
			if (!comp.type)
				throw new SunnyGameEngineError("移除组件类型为空！");
			if (_roleAnimationComp == comp)
				_roleAnimationComp = null;

			if (comp && _componentByType[comp.type] == comp && comp.owner == this)
			{
				var index : int = _updatables.indexOf(comp);
				if (index != -1)
					_updatables.splice(index, 1);
				delete _componentByType[comp.type];
				comp.notifyRemoved();
				comp.owner = null;
			}
		}

		public function getComponent(type : *) : SIComponent
		{
			return _componentByType ? _componentByType[type] : null;
		}

		private function notifyResetComponent() : void
		{
			for each (var comp : SComponent in _componentByType)
			{
				comp.notifyReset();
			}
		}
		private var _isShowAvatar : Boolean = true;
		private var _roleAnimationComp : SRoleAnimationComponent;

		public function showAvatar(value : Boolean) : void
		{
			if (_isShowAvatar == value)
				return;
			_isShowAvatar = value;
			if (_roleAnimationComp)
				_roleAnimationComp.showAvatar(_isShowAvatar);
		}

		override public function update() : void
		{
			if (_isDisposed || !_enabled)
				return;
			_numUpdatable = 0;
			var updatable : SIUpdatable;
			for each (updatable in _updatables)
			{
				if (_isDisposed)
					break;

				if (updatable.checkUpdatable())
				{
					updatable.update();
					_numUpdatable++;
					_numUpdatable += updatable.numUpdatable;
				}
			}
		}

		public function resize(w : int, h : int) : void
		{

		}

		public function get attrs() : Dictionary
		{
			if (!_attrs)
			{
				_attrs = new Dictionary();
			}
			return _attrs;
		}

		public function get id() : int
		{
			return _id;
		}

		public function get isActive() : Boolean
		{
			return !isDisposed;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			_roleAnimationComp = null;
			if (_componentByType)
			{
				for each (var comp : SComponent in _componentByType) //这里不要用--，因为destroy可能有多处调用并从数组中移除
				{
					if (comp)
						comp.destroy();
				}
				_componentByType = null;
			}
			if (_data)
			{
				_data.destroy();
				_data = null;
			}
			_attrs = null;
			if (_state)
			{
				_state.destroy();
				_state = null;
			}
			super.destroy();
		}

		public function get name() : String
		{
			return _name;
		}

		public function set name(value : String) : void
		{
			_name = value;
		}

		override public function get numUpdatable() : uint
		{
			return _numUpdatable;
		}

		public function get state() : SIEntityState
		{
			return _state;
		}

		public function get data() : SEntityData
		{
			return _data;
		}

		public function set data(value : SEntityData) : void
		{
			_data = value;
		}
	}
}
