package com.sunny.game.engine.avatar
{
	import com.sunny.game.engine.animation.SAnimation;
	import com.sunny.game.engine.animation.SAnimationManager;
	import com.sunny.game.engine.animation.SLazyAnimation;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.enum.SDirection;
	import com.sunny.game.engine.lang.SReference;
	import com.sunny.game.engine.ns.sunny_engine;

	import flash.utils.Dictionary;


	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的纸娃娃动画库，部件拥有的所有动画
	 * 二级字典，action映射到 dir2Animation, dir映射到Animation
	 * 通过动作名可以映射到8个方向的动画，在从其中取出某个方向的动画
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
	public class SAvatarAnimationLibrary extends SReference
	{
		private var _animationByActionAndDir : Dictionary;
		/**
		 * 部件名称
		 */
		private var _partName : String;
		public var depth : int;

		public function SAvatarAnimationLibrary(priority : int, partName : String, avatarDesc : SAvatarDescription, needReversal : Boolean)
		{
			_partName = partName;
			_animationByActionAndDir = new Dictionary();
			createSinglePartAnimations(priority, avatarDesc, needReversal);
		}

		private function setAnimationByActionAndDir(action : uint, kind : uint, animationByDir : Dictionary) : void
		{
			_animationByActionAndDir[action + "." + kind] = animationByDir;
		}

		private function getAnimationByActionAndDir(action : uint, kind : uint) : Dictionary
		{
			return _animationByActionAndDir[action + "." + kind];
		}

		/**
		 * 拿出去的动画，记得要清理，否则不会销毁
		 * @param action
		 * @param kind
		 * @param dir
		 * @return
		 *
		 */
		public function gotoAnimation(action : uint, kind : uint, dir : int) : SAnimation
		{
			var dir2Animation : Dictionary = getAnimationByActionAndDir(action, kind);
			return dir2Animation[dir];
		}

		/**
		 * 加载所有的动画
		 *
		 */
		private var loader_count : int = 0;
		private var loader_index : int = 0;
		public var onReturnHanlder : Function;

		public function loaderAnimation() : void
		{
			var animation : SLazyAnimation;
			var animationByDir : Dictionary;
			loader_count = loader_index = 0;
			for each (animationByDir in _animationByActionAndDir)
			{
				for each (animation in animationByDir)
				{
					loader_count++;
					animation.constructFrames(1);
					animation.onLoaderComplete = onLoaderComplete;
					break;
				}
			}
		}

		private function onLoaderComplete() : void
		{
			if (++loader_index >= loader_count)
			{
				onReturnHanlder != null && onReturnHanlder();
				onReturnHanlder = null;
			}
		}

		/**
		 * 是否全部加载完毕
		 * @return
		 *
		 */
		public function get isLoaded() : Boolean
		{
			var animation : SAnimation;
			var animationByDir : Dictionary;
			for each (animationByDir in _animationByActionAndDir)
			{
				for each (animation in animationByDir)
				{
					if (!animation.isLoaded)
						return false;
					break;
				}
			}
			return true;
		}

		override protected function destroy() : void
		{
			var animation : SAnimation;
			var animationByDir : Dictionary;
			for each (animationByDir in _animationByActionAndDir)
			{
				for each (animation in animationByDir)
				{
					animation.destroy();
				}
			}
			onReturnHanlder = null;
			_animationByActionAndDir = null;
			super.destroy();
		}

		public function updateCenter(centerX : int, centerY : int) : void
		{
			var animation : SAnimation;
			var animationByDir : Dictionary;
			for each (animationByDir in _animationByActionAndDir)
			{
				for each (animation in animationByDir)
				{
					animation.updateCenter(centerX, centerY);
				}
			}
		}

		/**
		 * 创建单个部件动画库
		 * @param avatarDesc
		 * @param priority
		 * @param allNeedReversalPart
		 * @return
		 *
		 */
		private function createSinglePartAnimations(priority : int, avatarDesc : SAvatarDescription, allNeedReversalPart : Boolean) : void
		{
			if (!_partName || avatarDesc == null)
				return;

			var needReversalPart : Boolean;
			var animationByDir : Dictionary;
			var partDesc : SAvatarPartDescription;
			var dirs : Array;
			var animationId : String;
			var id : String;
			var needReversal : Boolean;
			var revrsalDir : int;
			var dir : int;
			var animation : SLazyAnimation;
			//构建每个动作的8方向动画
			for each (var actionDesc : SAvatarActionDescription in avatarDesc.actionDescByActionMap)
			{
				needReversalPart = allNeedReversalPart;
				animationByDir = new Dictionary();
				setAnimationByActionAndDir(actionDesc.type, actionDesc.kind, animationByDir);
				partDesc = actionDesc.partDescByName[_partName];
				if (!partDesc)
					continue;
				dirs = actionDesc.directions; //当前有的方向数据
				if (needReversalPart)
					actionDesc.directions = dirs = SDirection.getReversalDirs(dirs);


				//构建该动作的方向动画			
				for each (dir in dirs)
				{
					needReversal = needReversalPart && SDirection.needMirrorReversal(dir);
					if (needReversal)
					{
						revrsalDir = SDirection.getMirrorReversal(dir);
						animationId = partDesc.getAnimationIdByDir(revrsalDir);
						if (animationId)
							id = animationId.substr(0, animationId.length - 1) + dir;
					}
					else
					{
						animationId = partDesc.getAnimationIdByDir(dir);
						id = animationId;
					}
					if (animationId && id)
					{
						animation = SAnimationManager.getInstance().createAnimation(id, animationId, needReversal) as SLazyAnimation;
						animation.priority = priority;
						if (animation)
							animationByDir[dir] = animation;
						else
							SDebug.warningPrint(this, "创建纸娃娃动画" + id + "对应的动画" + animationId + "失败！");
					}
					else
						SDebug.warningPrint(this, "创建纸娃娃动画" + id + "对应的方向" + dir + "失败！");
				}
			}
		}

		/**
		 * 根据一个部件描述和某些方向得到一堆动画描述（实际上是根据部件描述得到动画，方向位于同一文件内）
		 * @param partDesc
		 * @param dirs
		 * @param needReversalPart
		 * @return
		 *
		 */
		private function getAnimationDescByPartDescAndDirs(partDesc : SAvatarPartDescription, dirs : Array, needReversalPart : Boolean) : Array
		{
			var ids : Array = [];
			var dirNeedReversal : Boolean;
			var otherComposeingId : String;
			for each (var dir : int in dirs)
			{
				dirNeedReversal = needReversalPart && SDirection.needMirrorReversal(dir);
				if (dirNeedReversal)
				{ //如果需要反转
					dir = SDirection.getMirrorReversal(dir);
				}
				otherComposeingId = partDesc.getAnimationIdByDir(dir);

				if (ids.indexOf(otherComposeingId) == -1)
					ids.push(otherComposeingId);
			}
			var descs : Array = [];
			if (ids != null)
			{
				for each (var id : String in ids)
				{
					descs.push(SAnimationManager.getInstance().getAnimationDescription(id));
				}
			}
			return descs;
		}

		public function get partName() : String
		{
			return _partName;
		}
	}
}