package com.sunny.game.engine.component.state
{
	import com.sunny.game.engine.avatar.SAvatar;
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.entity.SRoleEntity;

	/**
	 *
	 * <p>
	 * SunnyGame的控制播放人物动作动画的基类
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
	public class SStateAnimation extends SObject implements SIStateAnimation
	{
		protected var _avatar : SAvatar;
		protected var _role : SRoleEntity;
		protected var _isDisposed : Boolean;

		public function SStateAnimation(role : SRoleEntity, avatar : SAvatar)
		{
			super();
			_role = role;
			_avatar = avatar;
			_isDisposed = false;
		}

		/**
		 * 同一个类型的只能触发一次，改变类型时触发
		 * 上一个动画留下的临时帧余时间
		 * @param elapsedTime
		 *
		 */
		public function play(elapsedTime : int = 0) : void
		{
			if (_avatar)
				_avatar.resume(elapsedTime);
		}

		public function next(elapsedTime : int) : void
		{
		}

		/**
		 * avatar被替换了
		 * @param newAvatar
		 */
		public function notifyAvatarChanged(newAvatar : SAvatar, replay : Boolean) : void
		{
			_avatar = newAvatar;
			if (replay)
				play(0);
		}

		public function get avatar() : SAvatar
		{
			return _avatar;
		}

		public function get role() : SRoleEntity
		{
			return _role;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			_role = null;
			_avatar = null;
			_isDisposed = true;
		}
	}
}