package com.sunny.game.engine.component.avatar
{
	import com.sunny.game.engine.avatar.SAvatar;
	import com.sunny.game.engine.component.SPastDataComponent;
	import com.sunny.game.engine.component.render.SRenderableComponent;
	import com.sunny.game.engine.component.state.SStateAnimation;
	import com.sunny.game.engine.data.SRoleData;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.entity.SRoleEntity;
	import com.sunny.game.engine.loader.SLoadPriorityType;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的纸娃娃组件，用于Avatar初始化及播放控制
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
	public class SAvatarComponent extends SRenderableComponent
	{
		protected var _role : SRoleEntity;
		protected var _avatar : SAvatar;
		protected var lazyAvatar : SLazyAvatar;

		protected var _animationByClass : Dictionary = new Dictionary();
		protected var _animation : SStateAnimation;
		protected var _animationClass : Class;

		protected var _pastDataComp : SPastDataComponent;

		protected var _curParts : Array;
		private var _notifyComplete : Function = null;

		protected var mouseRect : Rectangle;

		public function SAvatarComponent(isMe : Boolean = false)
		{
			super(SAvatarComponent);
			mouseRect = new Rectangle();
			lazyAvatar = new SLazyAvatar(true, SLoadPriorityType.ROLE + (isMe ? 1 : 0));
		}

		public function modelStatus(value : Boolean) : void
		{
			lazyAvatar.modelStatus(value);
		}

		override public function notifyAdded() : void
		{
			super.notifyAdded();
			_role = owner as SRoleEntity;
			removeRender(_render);

			enableFilter = true;
			enableColorTransform = true;
		}

		public function setPastDataComponent(pastDataComp : SPastDataComponent) : SAvatarComponent
		{
			_pastDataComp = pastDataComp;
			return this;
		}

		public function onNotifyComplete(func : Function) : void
		{
			_notifyComplete = func;
		}

		protected function disposeAvatar() : void
		{
			if (_avatar)
			{
				removeRender(_avatar.render);
				_avatar = null;
			}
		}

		public function setAvatarId(avatarId : String, parts : Array, partProps : Object = null /*, notifyComplete : Function = null*/) : void
		{
			if (!avatarId)
				SDebug.error(_role.name + "角色资源ID配置错误，初始Avatar失败！");
			if (_curParts && _curParts.length == 0)
				SDebug.error(this + "parts=0");
			lazyAvatar.setAvatarId(avatarId, partProps);
			_curParts = parts;
		}

		/**
		 * 加载纸娃娃资源
		 * @param avatarId
		 * @param parts
		 * @param mainPart
		 * @param partProps
		 * @param notifyComplete
		 *
		 */
		protected function loadResource() : void
		{
			if (_role == null || !lazyAvatar.isChangeAvatar)
				return;
			disposeAvatar();
			if (!_entity.isInScreen || !_curParts)
				return;
			lazyAvatar.notifyComplete = notifyAvatarBuildCompleted;
			lazyAvatar.loadResource(_curParts.length == 1 ? _curParts[0] : _curParts.join(","));
		}

		/**
		 * avatar动作改变时，用来改变武器的状态
		 *
		 */
		protected function changeAnimation() : void
		{

		}

		/**
		 * 全部动画加载完成
		 *
		 */
		protected function notifyAvatarLoadedCompleted() : void
		{
			_role.displayWidth = _role.width = _avatar.width;
			_role.displayHeight = _role.height = _avatar.height;
		}

		protected function notifyAvatarBuildCompleted() : void
		{
			_avatar = lazyAvatar.avatar;
			notifyAvatarLoadedCompleted();
//			_avatar.loaderComplement = notifyAvatarLoadedCompleted;
			if (_avatar)
			{
				if (_role)
				{
					_role.dirMode = _avatar.dirMode;
					_role.displayWidth = _role.width = _avatar.width;
					_role.displayHeight = _role.height = _avatar.height;
				}

				showAvatar(_avatarVisible);
				_avatar.changeAnimation = changeAnimation;

				for each (var roleAnimation : SStateAnimation in _animationByClass)
				{
					roleAnimation.notifyAvatarChanged(_avatar, roleAnimation == _animation);
				}
			}

			if (_notifyComplete != null)
				_notifyComplete();
		}



		protected var _avatarVisible : Boolean = true;

		public function showAvatar(visible : Boolean) : void
		{
			_avatarVisible = visible;
			if (_avatar == null)
				return;
			visible ? addRender(_avatar.render) : removeRender(_avatar.render);
		}

		override protected function updateRenderProperty(elapsedTime : int) : void
		{
			if (_isDisposed || !_enabled || !_role)
				return;
			if (_role.isInScreen)
			{
				loadResource();
			}

			if (_avatar && _animation)
			{
				if (_avatar.correctDir == _role.correctDirection)
				{
					if (!_avatar.isPaused)
						_animation.next(elapsedTime);
				}
				else
				{
					_animation.play(elapsedTime);
				}
			}

			if (_avatar && _avatar.render)
			{
				_avatar.updateRenderProperty();
				if (_bounds)
				{
					_bounds.left = _entity.screenX + _avatar.mouseRect.left;
					_bounds.top = _entity.screenY + _avatar.mouseRect.top + _role.centerOffsetY - _entity.centerOffsetZ - _role.mapZ;
					_bounds.width = _avatar.mouseRect.width;
					_bounds.height = _avatar.mouseRect.height;
				}
			}
			else
			{
				if (_bounds)
				{
					_bounds.width = 0;
					_bounds.height = 0;
					_bounds.left = 0;
					_bounds.top = 0;
				}
			}

			if (_avatar && _avatar.currRender)
			{
				if (enableFilter && _avatar.currRender.filters != _entity.filters)
					_avatar.currRender.filters = _entity.filters;
				if (enableColorTransform && _entity.colorTransform && _avatar.currRender.colorTransform != _entity.colorTransform)
					_avatar.currRender.colorTransform = _entity.colorTransform;
			}

			if (!_avatarVisible && _bounds)
			{
				_bounds.width = 0;
				_bounds.height = 0;
				_bounds.left = 0;
				_bounds.top = 0;
			}
		}

		protected function updateBounds(rect : Rectangle) : void
		{
			if (mouseRect)
			{
				mouseRect.left = Math.min(mouseRect.left, rect.left);
				mouseRect.top = Math.min(mouseRect.top, rect.top);
				mouseRect.right = Math.max(mouseRect.right, rect.right);
				mouseRect.bottom = Math.max(mouseRect.bottom, rect.bottom);
			}
		}

		override protected function updateRender(bufferX : Number, bufferY : Number) : void
		{
			if (_isDisposed || !_enabled)
				return;
			if (_avatar && _avatar.render)
			{
				_avatar.scaleX = _role.scaleX;
				_avatar.scaleY = _role.scaleY;
				_avatar.render.depth = _role.depth;
				_avatar.render.layer = _role.layer; //两个渲染对象在同一点时将以对象的偏移值来计算前后
				_avatar.updateRender(bufferX + _role.shakeX, bufferY + (_role.centerOffsetY - _entity.centerOffsetZ) - _role.mapZ + _role.shakeY);
			}
		}

		public function play(animationClass : Class = null) : SStateAnimation
		{
			if (animationClass)
			{
				if (_animationClass == animationClass)
				{
					if (_pastDataComp.pastData.dir == _role.direction)
					{
						return _animation;
					}
				}

				_animation = _animationByClass[animationClass];
				if (_avatar && !_animation)
				{
					_animation = new animationClass(_role, _avatar);
					_animationByClass[animationClass] = _animation;
				}
				if (_animation)
				{
					_animationClass = animationClass;
					_animation.play();
				}
			}
			else
			{
				_animationClass = null;
				_animation = null;
			}
			return _animation;
		}

		public function getAnimation(clase : Class) : SStateAnimation
		{
			return _animationByClass[clase];
		}

		public function get currentAnimation() : SStateAnimation
		{
			return _animation;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			disposeAvatar();
			for each (var roleAnimation : SStateAnimation in _animationByClass)
			{
				roleAnimation.destroy();
			}
			if (lazyAvatar)
			{
				lazyAvatar.destroy();
				lazyAvatar = null;
			}
			super.destroy();
			mouseRect = null;
			_animation = null;
			_role = null;
			_pastDataComp = null;
			_animationByClass = null;
			_animationClass = null;
			_notifyComplete = null;
		}

		public function get avatar() : SAvatar
		{
			return _avatar;
		}

		public function get avatarId() : String
		{
			return lazyAvatar.avatarId;
		}

		/**
		 * 替换合成部件
		 * @param newComposeParts
		 * @return
		 *
		 */
		public function substituteComposeParts(newComposeParts : Array) : void
		{
			if (newComposeParts.length <= 1)
			{
				if (SDebug.OPEN_ERROR_TRACE)
				{
					SDebug.errorPrint(this, "替换合成部件至少需要两个以上!");
				}
				return;
			}
			if (_role && _role.data)
				(_role.data as SRoleData).avatarParts = newComposeParts;
		}
	}
}