package com.sunny.game.engine.avatar
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.manager.SFileSystemManager;
	import com.sunny.game.engine.manager.SResourceManager;
	import com.sunny.game.engine.resource.SResource;
	import com.sunny.game.engine.utils.SAvatarUtil;

	import flash.system.System;
	import flash.utils.ByteArray;

	/**
	 *
	 * <p>
	 * SunnyGame的纸娃娃资源
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
	public class SAvatarResource
	{
		/**
		 * avatar构建完成回调函数，通知构建完成
		 * signature: void complete(builder : AvatarBuilder) : void
		 */
		private var _notifyCompleteds : Array;

		/**
		 * 需要构建的部分，例如"body1","weapon1"
		 */
		private var _parts : Array;
		private var _partProps : Object;

		/**
		 * avatar的id
		 */
		private var _avatarId : String;
		private var priority : int;

		/**
		 * 需要反转的部件
		 */
		private var _needReversalPart : Boolean;

		public var avatar : SAvatar;

		public var isDisposed : Boolean;

		public var isLoaded : Boolean;

		public var isShowModelData : Boolean;

		public function SAvatarResource(avatarId : String, priority : int, isShowModelData : Boolean = true)
		{
			_avatarId = avatarId;
			this.priority = priority;
			this.isShowModelData = isShowModelData;
		}

		public function onComplete(notifyCompleted : Function) : SAvatarResource
		{
			if (!_notifyCompleteds)
			{
				_notifyCompleteds = [];
			}
			_notifyCompleteds.push(notifyCompleted);
			return this;
		}

		public function removeOnComplete(notifyCompleted : Function) : void
		{
			if (_notifyCompleteds)
			{
				var index : int = _notifyCompleteds.indexOf(notifyCompleted);
				if (index != -1)
					_notifyCompleteds.splice(index, 1);
			}
		}

		private function invokeComplete() : void
		{
			var notifies : Array = null;
			if (_notifyCompleteds)
			{
				notifies = _notifyCompleteds.concat();
				cleanNotify();
			}
			for each (var notify : Function in notifies)
			{
				notify(this);
			}
		}

		private function cleanNotify() : void
		{
			_notifyCompleteds = null;
		}

		private function initAvatar(avatarDescription : SAvatarDescription) : void
		{
			if (!_parts || _parts.length == 0)
				_parts = avatarDescription.getAvaliableParts();
			//因为生成解释器需要部件，则这边需要额外处理
			if (_parts.length > 1)
				_parts = [_parts[0]];
			avatar = SAvatarUtil.createAvatar(avatarDescription, priority, _parts, _partProps, _needReversalPart, isShowModelData);
			if (!avatar && SDebug.OPEN_ERROR_TRACE)
				SDebug.errorPrint(this, "SAvatarResource-initAvatar-Avatatr创建失败！");
		}

		/**
		 *
		 * @param parts 所有要构建的部件
		 * @param mainPart 指定一个主部件，比如身体
		 * @param partProps 部件的一些属性，比如 滤镜等
		 * @param priority 加载的优先级
		 * @param needReversalPart 是否需要进行5向反转
		 */
		public function load(parts : Array, partProps : Object = null, priority : int = 0, needReversalPart : Boolean = false) : void
		{
			_parts = parts;
			_partProps = partProps;
			_needReversalPart = needReversalPart;
			var avatarDescription : SAvatarDescription = SAvatarManager.getInstance().getAvatarDescription(_avatarId);
			if (avatarDescription)
			{
				initAvatar(avatarDescription);
				invokeComplete();
			}
			else
			{
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(this, "加载纸娃娃资源：" + _avatarId);

				var resource : SResource = SResourceManager.getInstance().createResource(_avatarId, SFileSystemManager.getInstance().avatarFileSystem);

				if (resource)
				{
					if (resource.isLoading)
						resource.onComplete(onLoadComplete);
					if(resource.isLoaded)
						onLoadComplete(resource);
					else
						resource.priority(priority).onComplete(onLoadComplete).load();
				}
			}
		}

		public static function createAvatarDescription(res : SResource, avatarId : String) : SAvatarDescription
		{
			var avatarDescription : SAvatarDescription = SAvatarManager.getInstance().getAvatarDescription(avatarId);
			if (!avatarDescription)
			{
				var bytes : ByteArray = res.getBinary(true);
				if (bytes)
				{
					bytes.position = 0;
					var configData : XML = XML(bytes.readUTFBytes(bytes.bytesAvailable));
					avatarDescription = SAvatarManager.getInstance().addAvatarDescription(avatarId, configData, configData.@version);
					//清理XML
					System.disposeXML(configData);
				}
			}
			return avatarDescription;
		}

		private function onLoadComplete(res : SResource) : void
		{
			if (isDisposed) //已经被取消了
				return;
			var avatarDescription : SAvatarDescription = createAvatarDescription(res, _avatarId);
			if (avatarDescription)
			{
				initAvatar(avatarDescription);
				isLoaded = true;
				invokeComplete();
			}
		}

		/**
		 * 调用此方向可以清除构建器，如果正在构建中，则会取消操作
		 */
		public function dispose() : void
		{
			if (avatar)
				avatar.dispose();
			avatar = null;
			_parts = null;
			_partProps = null;
			_notifyCompleteds = null;
			isDisposed = true;
		}

		public function get avatarId() : String
		{
			return _avatarId;
		}
	}
}