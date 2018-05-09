package com.sunny.game.engine.component.animation
{
	import com.sunny.game.engine.effect.SEffectResource;
	import com.sunny.game.engine.loader.SLoadPriorityType;
	import com.sunny.game.engine.manager.SMemoryManager;
	import com.sunny.game.engine.utils.SCommonUtil;

	/**
	 *
	 * <p>
	 * SunnyGame的一个动画物件组件
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
	public class SAnimatorComponent extends SAnimationComponent
	{
		public var autorotation : Boolean = false;
		private var _rot : Number;
		private var _originX : int;
		private var _originY : int;
		public var angle : int;
		private var _moveElapsedTime : int;

		public function SAnimatorComponent(loop : int = 0)
		{
			super(SAnimatorComponent, loop);
		}

		override public function setType(type : * = null, loop : int = 0) : void
		{
			super.setType(type, loop);
			angle = 0;
			autorotation = false;
		}

		override public function setAnimationInfomation(duration : int = 0, delayTime : int = 0, rotation : Number = 0, priority : int = SLoadPriorityType.EFFECT, useMapZ : Boolean = true, around : Boolean = false) : void
		{
			super.setAnimationInfomation(duration, delayTime, rotation, priority, useMapZ, around);
			_rot = rotation / 1000; //每秒化毫秒
		}

		override public function notifyAdded() : void
		{
			super.notifyAdded();
			_moveElapsedTime = 0;
			_originX = _entity.mapX;
			_originY = _entity.mapY;
		}

		override protected function notifyResourceCompleted(resource : SEffectResource) : void
		{
			if (isDisposed)
				return;
			super.notifyResourceCompleted(resource);

			if (_entity && _collection)
			{
				_entity.dirMode = _collection.dirMode;
				_entity.displayWidth = _entity.width = _collection.width;
				_entity.displayHeight = _entity.height = _collection.height;
			}
		}

		private function onCollectWidthChanged() : void
		{
			if (_entity && _collection)
				_entity.width = _collection.width;
		}

		private function onCollectHeightChanged() : void
		{
			if (_entity && _collection)
				_entity.height = _collection.height;
		}

		private function onResetDefaultAction() : void
		{
		}

		private function onResetDefaultDir() : void
		{
			if (_entity && _collection)
				_entity.direction = _cur_dir;
		}

		private var _waveformAngle : Number = 0;

		override public function update() : void
		{
			if (_animationDelay == 0)
			{
				if (autorotation)
				{
					_rotation += _rot * elapsedTimes;
				}
				if (_entity.moveSpeed != 0)
				{
					_waveformAngle += 0.5;
					_moveElapsedTime += elapsedTimes;
					_entity.mapX = _originX + SCommonUtil.cosd(angle) * _entity.moveSpeed * _moveElapsedTime + SCommonUtil.sind(_waveformAngle) * 100;
					_entity.mapY = _originY + SCommonUtil.sind(angle) * _entity.moveSpeed * _moveElapsedTime + SCommonUtil.sind(_waveformAngle) * 100;
				}
			}
			super.update();
		}

		override protected function disposeCollect() : void
		{
			super.disposeCollect();
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			SMemoryManager.recycle(this, SAnimatorComponent);
			super.destroy();
		}
	}
}