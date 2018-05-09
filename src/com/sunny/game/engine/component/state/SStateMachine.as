package com.sunny.game.engine.component.state
{
	import com.sunny.game.engine.component.avatar.SAvatarComponent;
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.entity.SIEntity;
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的状态机
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
	public class SStateMachine extends SObject implements SIStateMachine
	{
		private var _currentStateType : uint = 0;
		private var _currentState : SIState;
		private var _previousStateType : uint = 0;
		private var _previousState : SIState;
		private var _defaultStateType : uint = 0;
		private var _entity : SIEntity;
		private var _states : Dictionary;
		private var _animation : SAvatarComponent;
		protected var _isDisposed : Boolean;

		public function SStateMachine() : void
		{
			super();
			_states = new Dictionary();
			_isDisposed = false;
		}

		public function init(entity : SIEntity, animation : SAvatarComponent) : void
		{
			_entity = entity;
			_animation = animation;
			changeState(_defaultStateType);
		}

		public function updateNow() : void
		{
			if (_entity && _entity.state)
			{
				if (_entity.state.stateChanged)
					changeState(_entity.state.state);
				if (_currentState)
					_currentState.execute(0);
			}
		}
		
		public function update(elapsedTime : int = 0) : void
		{
			if (_entity && _entity.state)
			{
				if (_entity.state.stateChanged)
					changeState(_entity.state.state);
				if (_currentState)
					_currentState.execute(elapsedTime);
			}
		}

		public function registerState(stateClass : Class) : SIState
		{
			if (stateClass)
			{
				var state : Object = new stateClass();
				if (state is SIState)
				{
					if (_states[(state as SIState).type])
					{
						var type : uint = (state as SIState).type;
						(state as SIState).destroy();
						throw new SunnyGameEngineError("状态类型" + type + "已经存在，注册状态失败！");
					}
					else
					{
						(state as SIState).stateMachine = this;
						_states[(state as SIState).type] = state;
						return state as SIState;
					}
				}
				else
					throw new SunnyGameEngineError("状态" + state + "不是SIState类型！");
			}
			return null;
		}

		public function replaceState(stateClass : Class) : SIState
		{
			if (stateClass)
			{
				var state : Object = new stateClass();
				if (state is SIState)
				{
					var oldState : SIState = _states[(state as SIState).type];
					if (oldState)
					{
						oldState.destroy();
						(state as SIState).stateMachine = this;
						_states[(state as SIState).type] = state;
						if ((state as SIState).type == _entity.state.state)
						{
							_currentStateType = 0;
							changeState(_entity.state.state);
						}
						return state as SIState;
					}
					else
					{
						var type : uint = (state as SIState).type;
						(state as SIState).destroy();
						throw new SunnyGameEngineError("状态类型" + type + "不存在，替换状态失败！");
					}
				}
				else
					throw new SunnyGameEngineError("状态" + state + "不是SIState类型！");
			}
			return null;
		}

		public function getState(type : uint) : SIState
		{
			var state : SIState = _states[type] as SIState;
			return state;
		}

		public function getStateType(state : SIState) : uint
		{
			for (var type : * in _states)
				if (_states[type] == state)
					return type;
			return 0;
		}

		public function changeState(type : uint) : void
		{
			if (_currentStateType == type)
				return;
			if (_currentState)
			{
				_currentState.exit();
			}
			_previousState = _currentState;
			_previousStateType = _currentState ? _currentState.type : 0;
			_currentState = getState(type);
			if (!_currentState)
			{
				_currentState = getState(_defaultStateType);
				if (SDebug.OPEN_WARNING_TRACE)
					SDebug.warningPrint(this, "状态机不存在状态type=" + type + "的状态！");
			}
			if (_currentState)
			{
				_currentStateType = type;
				_currentState.enter();
			}
			else
			{
				throw new SunnyGameEngineError("状态机不存在状态type=" + type + "的状态！");
			}
			if (!_previousState)
			{
				_previousState = _currentState;
				_previousStateType = _currentState ? _currentState.type : 0;
			}
		}

		public function play(animation : Class) : SIStateAnimation
		{
			_entity.state.stateChanged = false;
			if (_animation)
			{
				return _animation.play(animation);
			}
			return null;
		}

		public function get currentStateType() : uint
		{
			return _currentStateType;
		}

		public function get previousStateType() : uint
		{
			return _previousStateType;
		}

		public function get owner() : SIEntity
		{
			return _entity;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_states)
			{
				for (var type : * in _states)
				{
					var state : SIState = _states[type];
					if (state)
						state.destroy();
					_states[type] = null;
					delete _states[type];
				}
				_states = null;
			}
			_entity = null;
			_currentState = null;
			_previousState = null;
			_currentStateType = 0;
			_previousStateType = 0;
			_animation = null;
			_isDisposed = true;
		}
	}
}