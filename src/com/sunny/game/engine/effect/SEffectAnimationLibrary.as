package com.sunny.game.engine.effect
{
	import com.sunny.game.engine.animation.SAnimation;
	import com.sunny.game.engine.animation.SAnimationManager;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.enum.SDirection;
	import com.sunny.game.engine.lang.SReference;
	import com.sunny.game.engine.ns.sunny_engine;

	import flash.utils.Dictionary;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的画库，方向拥有的所有动画
	 * 一级字典，dir映射到Animation
	 * 通过方向可以映射到8个方向的动画，在从其中取出某个方向的动画
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
	public class SEffectAnimationLibrary extends SReference
	{
		private var _animationByDir : Dictionary;
		/**
		 * 当前effect的描述
		 */
		public var effectDesc : SEffectDescription;
		private var _width : int;
		private var _height : int;
		private var _dirMode : uint = SDirection.DIR_MODE_HOR_ONE;

		public function SEffectAnimationLibrary(desc : SEffectDescription, needReversal : Boolean)
		{
			_animationByDir = new Dictionary();
			if (desc.version == "2")
				_dirMode = SDirection.checkDirsDirMode(desc.directions);
			this.effectDesc = desc;
			_width = Math.abs(desc.rightBorder - desc.leftBorder);
			_height = Math.abs(desc.bottomBorder - desc.topBorder);
			createAnimations(desc, needReversal);
		}

		public function gotoAnimation(dir : int) : SAnimation
		{
			if (effectDesc == null)
				return null;

			var cur_dir : int = SDirection.correctDirection(_dirMode, SDirection.EAST, dir); //对方向进行修正

			if (cur_dir != 0 && !hasDir(cur_dir))
			{
				cur_dir = getAvaliableDir();
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(this, effectDesc.id + "配置文件不存在方向" + dir + "的资源，将取有效方向：" + cur_dir);
			}

			return _animationByDir[cur_dir];
		}

		/**
		 * 是否有这个方向
		 * @param curDir
		 * @return
		 */
		public function hasDir(curDir : int) : Boolean
		{
			if (effectDesc == null)
				return false;
			var dirs : Array = effectDesc.animationDirections;
			for each (var dir : int in dirs)
			{
				if (dir == curDir)
					return true;
			}
			return false;
		}

		/**
		 * 得到一个可用的方向
		 * @return
		 */
		public function getAvaliableDir() : int
		{
			if (effectDesc)
			{
				var dirs : Array = effectDesc.animationDirections;
				if (dirs.length > 0)
					return int(dirs[0]);
			}
			return 0;
		}

		public function get dirMode() : uint
		{
			return _dirMode;
		}

		public function get width() : int
		{
			return _width;
		}

		public function get height() : int
		{
			return _height;
		}

		override protected function destroy() : void
		{
			for each (var animation : SAnimation in _animationByDir)
			{
				animation.destroy();
			}
			_animationByDir = null;
			super.destroy();
		}

		public function updateCenter(centerX : int, centerY : int) : void
		{
			for each (var animation : SAnimation in _animationByDir)
			{
				animation.updateCenter(centerX, centerY);
			}
		}

		/**
		 * 创建动画库
		 * @param effectDesc
		 * @param priority
		 * @param needReversal
		 * @return
		 *
		 */
		private function createAnimations(effectDesc : SEffectDescription, needReversal : Boolean) : SEffectAnimationLibrary
		{
			if (effectDesc == null)
				return null;

			var dirs : Array = effectDesc.directions; //当前有的方向数据
			if (needReversal)
				effectDesc.animationDirections = dirs = SDirection.getReversalDirs(dirs);
			else
				effectDesc.animationDirections = dirs;

			//构建每个方向动作的8方向动画
			var isReversal : Boolean;
			var animationId : String;
			var id : String;
			for each (var dir : int in dirs)
			{
				isReversal = needReversal && SDirection.needMirrorReversal(dir);
				animationId = id = effectDesc.getAnimationIdByDir(dir);
				if (isReversal)
				{
					var revrsalDir : int = SDirection.getMirrorReversal(dir);
					animationId = effectDesc.getAnimationIdByDir(revrsalDir);
					id = animationId.substr(0, animationId.length - 1) + dir;
				}
				_animationByDir[dir] = SAnimationManager.getInstance().createAnimation(id, animationId, isReversal);
			}
			return this;
		}

		/**
		 * 根据一个方向得到一堆动画描述（实际上是根据部件描述得到动画，方向位于同一文件内）
		 * @param partDesc
		 * @param dirs
		 * @param needReversalPart
		 * @return
		 *
		 */
		private function getAnimationDescByDirs(effectDesc : SEffectDescription, dirs : Array, needReversal : Boolean) : Array
		{
			var ids : Array = [];
			for each (var dir : int in dirs)
			{
				var dirNeedReversal : Boolean = needReversal && SDirection.needMirrorReversal(dir);
				if (dirNeedReversal)
				{ //如果需要反转
					dir = SDirection.getMirrorReversal(dir);
				}
				var otherComposeingId : String = effectDesc.getAnimationIdByDir(dir);

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
	}
}