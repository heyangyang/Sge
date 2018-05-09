package com.sunny.game.engine.animation
{
	import com.sunny.game.engine.render.interfaces.SIBitmapData;
	
	import flash.geom.Rectangle;

	/**
	 *
	 * <p>
	 * SunnyGame的动画帧
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
	public class SAnimationFrame
	{
		/**
		 * 当前帧的位图（共享）
		 */
		private var _frameData : SIBitmapData;

		/**
		 * 当前帧需要绘制的区域
		 */
		private var _rect : Rectangle;

		/**
		 * 当前帧X偏移值，此偏移为设置值
		 */
		public var offsetX : int;

		/**
		 * 当前帧Y偏移值，此偏移为设置值
		 */
		public var offsetY : int;

		/**
		 * 当前帧X偏移值，此偏移为中心点相对最小包围框左上角的偏移
		 */
		public var frameX : int;

		/**
		 * 当前帧Y偏移值，此偏移为中心点相对最小包围框左上角的偏移
		 */
		public var frameY : int;

		public function get x() : int
		{
			return frameX + offsetX;
		}

		public function get y() : int
		{
			return frameY + offsetY;
		}

		/**
		 * 当前帧需要播放的持续时间
		 */
		public var duration : int = 120;

		/**
		 * 需要反转
		 */
		public var needReversal : Boolean = false;

		/**
		 * 是否已经反转过了
		 */
		private var _isReversed : Boolean = false;

		/**
		 * 没有翻转的原始值
		 */
		private var _originOffsetX : int;
		private var _originOffsetY : int;
		private var _originFrameX : int;
		private var _originFrameY : int;

		public function SAnimationFrame()
		{
			super();
			SAnimationManager.getInstance().animationFrameInstanceCount++;
		}

		public function clear() : void
		{
			if (!_frameData)
				return;
			_frameData = null;
			_rect = null;
			if (needReversal)
			{
				offsetX = _originOffsetX;
				offsetY = _originOffsetY;
				frameX = _originFrameX;
				frameY = _originFrameY;
			}
			_isReversed = false;
		}

		/**
		 * 将位图反转
		 */
		public function reverseData() : void
		{
			//已经反转过，则直接返回
			if (_isReversed)
				return;
			_originOffsetX = offsetX;
			_originFrameX = frameX;
			frameX = offsetX - frameX;
			offsetX = -offsetX * 2;
			_isReversed = true;
		}

		public function get frameData() : SIBitmapData
		{
			return _frameData;
		}

		public function set frameData(value : SIBitmapData) : void
		{
			_frameData = value;
			_isReversed = false;
			_rect = value ? value.rect : null;
		}


		public function get rect() : Rectangle
		{
			return _rect;
		}

		public function destroy() : void
		{
			clear();
			_frameData = null;
			_rect = null;
			duration = 120;
			offsetX = offsetY = frameX = frameY = 0;
			_originOffsetX = _originOffsetY = _originFrameX = _originFrameY = 0;
			needReversal = _isReversed = false;
			SAnimationManager.getInstance().animationFrameInstanceCount--;
		}
	}
}