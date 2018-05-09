package com.sunny.game.engine.effect
{
	import com.sunny.game.engine.animation.SAnimationManager;
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.manager.SFileSystemManager;
	import com.sunny.game.engine.manager.SResourceManager;
	import com.sunny.game.engine.resource.SResource;
	
	import flash.system.System;
	import flash.utils.ByteArray;

	/**
	 *
	 * <p>
	 * SunnyGame的特效资源
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
	public class SEffectResource extends SObject implements SIDestroy
	{
		/**
		 * avatar构建完成回调函数，通知构建完成
		 * signature: void complete(builder : AvatarBuilder) : void
		 */
		private var _notifyCompleteds : Array;
		private var _effectId : String;
		protected var _isDisposed : Boolean;

		public function SEffectResource(effectId : String)
		{
			super();
			if(effectId=="VIP")
				trace(111111)
			SAnimationManager.getInstance().effectResourceInstanceCount++;
			_isDisposed = false;
			_effectId = effectId;
		}

		public function load(priority : int = 0) : void
		{
			var effectDescription : SEffectDescription = SEffectDescription.getEffectDescription(_effectId);
			if (effectDescription)
			{
				invokeComplete();
			}
			else
			{
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(this, "加载特效资源：" + _effectId);
				SResourceManager.getInstance().createResource(_effectId, SFileSystemManager.getInstance().effectFileSystem).priority(priority).onComplete(onLoadComplete).load();
			}
		}

		public function onComplete(notifyCompleted : Function) : SEffectResource
		{
			if (!_notifyCompleteds)
				_notifyCompleteds = [];
			_notifyCompleteds.push(notifyCompleted);
			return this;
		}

		public function removeComplete(notifyCompleted : Function) : void
		{
			if (_notifyCompleteds)
			{
				var index : int = _notifyCompleteds.indexOf(notifyCompleted);
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

		public var isLoaded : Boolean;

		private function onLoadComplete(res : SResource) : void
		{
			if (isDisposed) //已经被取消了
				return;
			var effectDescription : SEffectDescription = createEffectDescription(res, _effectId);
			if (effectDescription)
			{
				isLoaded = true;
				invokeComplete();
			}
		}

		public static function createEffectDescription(res : SResource, effectId : String) : SEffectDescription
		{
			var effectDescription : SEffectDescription = SEffectDescription.getEffectDescription(effectId);
			if (!effectDescription)
			{
				var bytes : ByteArray = res.getBinary(true);
				if (bytes)
				{
					bytes.position = 0;
					var configData : XML = XML(bytes.readUTFBytes(bytes.bytesAvailable));
					SEffectDescription.addEffectDescription(effectId, configData, configData.@version);
					effectDescription = SEffectDescription.getEffectDescription(effectId);
					System.disposeXML(configData);
				}
			}
			return effectDescription;
		}


		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		/**
		 * 调用此方向可以清除构建器，如果正在构建中，则会取消操作
		 */
		public function destroy() : void
		{
			if (_isDisposed)
				return;
			_notifyCompleteds = null;
			SAnimationManager.getInstance().effectResourceInstanceCount--;
			_isDisposed = true;
		}
	}
}