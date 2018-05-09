package com.sunny.game.engine.animation
{
	import com.sunny.game.engine.enum.SDirection;

	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的动画集合描述
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
	public class SAnimationCollectionDescription
	{
		/**
		 * 动画的id
		 */
		public var id : String;

		public function SAnimationCollectionDescription()
		{
			_animationIdByDir = new Dictionary();
		}

		/**
		 * 动作拥有的方向
		 */
		public var directions : Array = [SDirection.EAST];

		/**
		 * 由方向记录的动画id，即可以根据一个方向得到一个动画的id
		 */
		private var _animationIdByDir : Dictionary;

		public function addAnimationIdByDir(dir : uint, id : String) : void
		{
			_animationIdByDir[dir] = id;
		}

		public function getAnimationIdByDir(dir : uint) : String
		{
			var mode : uint = SDirection.checkDirsDirMode(directions);
			dir = SDirection.correctDirection(mode, dir, dir);
			return _animationIdByDir[dir];
		}

		public function getAvaliableAnimation() : String
		{
			for each (var animationId : String in _animationIdByDir)
			{
				if (animationId)
					return animationId;
			}
			return null;
		}
	}
}