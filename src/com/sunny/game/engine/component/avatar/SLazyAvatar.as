package com.sunny.game.engine.component.avatar
{
	import com.sunny.game.engine.animation.SAnimationManager;
	import com.sunny.game.engine.avatar.SAvatar;
	import com.sunny.game.engine.avatar.SAvatarResource;

	public class SLazyAvatar
	{
		protected var resource : SAvatarResource;
		protected var partProps : Object;
		protected var oldPart : String;
		public var isChangeAvatar : Boolean;
		public var avatarId : String;
		public var avatar : SAvatar;
		public var notifyComplete : Function;
		private var isShowModelData : Boolean;
		private var priority : int;

		public function SLazyAvatar(isShowModelData : Boolean, priority : int)
		{
			super();
			this.priority = priority;
			this.isShowModelData = isShowModelData;
			SAnimationManager.getInstance().avatarResourceInstanceCount++;
		}

		public function modelStatus(value : Boolean) : void
		{
			isShowModelData = value;
		}

		public function setAvatarId(id : String, props : Object = null) : void
		{
			if (avatarId == id)
				return;
			avatarId = id;
			partProps = props;
			isChangeAvatar = true;
		}

		public function loadResource(part : String = "whole1") : void
		{
			if (!avatarId || !isChangeAvatar)
				return;
			isChangeAvatar = false;
			//资源小于5向
			if (resource)
				resource.dispose();
			oldPart = part;
			resource = new SAvatarResource(avatarId, priority, isShowModelData);
			resource.onComplete(notifyAvatarBuildCompleted);
			resource.load(part.indexOf(",") >= 0 ? part.split(",") : [part], partProps, priority, true);
		} 

		protected function notifyAvatarBuildCompleted(avatarResource : SAvatarResource) : void
		{
			avatar = avatarResource.avatar;
			if (notifyComplete != null)
				notifyComplete();
		}

		public function destroy() : void
		{
			if (resource)
				resource.dispose();
			partProps = null;
			avatar = null;
			notifyComplete = null;
			SAnimationManager.getInstance().avatarResourceInstanceCount--;

		}
	}
}