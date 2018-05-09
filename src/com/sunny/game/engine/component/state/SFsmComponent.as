package com.sunny.game.engine.component.state
{
	import com.sunny.game.engine.component.SUpdatableComponent;
	import com.sunny.game.engine.entity.SRoleEntity;

	/**
	 *
	 * <p>
	 * SunnyGame的状态机组件
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
	public class SFsmComponent extends SUpdatableComponent
	{
		private var _role : SRoleEntity;
		private var _stateMachine : SStateMachine;

		public function SFsmComponent()
		{
			super(SFsmComponent);
			_stateMachine = new SStateMachine();
		}

		override public function notifyAdded() : void
		{
			super.notifyAdded();
			_role = owner as SRoleEntity;
		}

		public function updateNow() : void
		{
			if (_stateMachine == null)
				return;
			if (enabled)
				_stateMachine.updateNow();
		}
		
		override public function update() : void
		{
			if (_stateMachine == null)
				return;
			if (enabled)
				_stateMachine.update(elapsedTimes);
		}

		override public function destroy() : void
		{
			if(_stateMachine)
				_stateMachine.destroy();
			_stateMachine = null;
			_role = null;
			super.destroy();
		}

		public function get stateMachine() : SStateMachine
		{
			return _stateMachine;
		}

		public function set stateMachine(value : SStateMachine) : void
		{
			_stateMachine = value;
		}

	}
}