package com.sunny.game.engine.component.state
{
	import com.sunny.game.engine.entity.SIEntity;

	/**
	 *
	 * <p>
	 * SunnyGame的一个基础状态
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
	public class SBasicState implements SIState
	{
		private var _type : uint = 0;
		protected var _entity : SIEntity;
		protected var _stateMachine : SIStateMachine;
		protected var _isDisposed : Boolean;

		public function SBasicState(type : uint) : void
		{
			_isDisposed = false;
			_type = type;
		}

		public function enter() : void
		{
		}

		public function exit() : void
		{
		}

		public function execute(elapsedTime : int) : void
		{
		}

		public function set stateMachine(value : SIStateMachine) : void
		{
			_stateMachine = value;
			_entity = _stateMachine.owner;
		}

		public function get type() : uint
		{
			return _type;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			_isDisposed = true;
			_entity = null;
			_stateMachine = null;
		}
	}
}