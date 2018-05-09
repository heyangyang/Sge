package com.sunny.game.engine.component.animation
{
	import com.sunny.game.engine.animation.SAnimation;
	import com.sunny.game.engine.animation.SAnimationFrame;
	import com.sunny.game.engine.component.render.SRenderableComponent;
	import com.sunny.game.engine.utils.SCommonUtil;


	/**
	 *
	 * <p>
	 * SunnyGame的一个带动画行为组件
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
	public class SAnimatableComponent extends SRenderableComponent
	{
		/**
		 * 正在需要更新的动画
		 */
		private var _updateAnimationFrame : SAnimationFrame;
		protected var _currAnimation : SAnimation;
		protected var _curAnimationFrame : SAnimationFrame;
		//动画循环的次数
		protected var _loops : int;
		/**
		 * 当前方向
		 */
		protected var _cur_dir : int;
		//设定一个特定的全局渲染位置 
		protected var _mapX : int = -1;
		protected var _mapY : int = -1;

		//渲染深度偏移，是在父对象前（1），还是后（-1），或是按高度或先后顺序
		protected var _renderDepth : int = 0;

		//动画渲染位置相对于父对象的中心点的偏移值
		protected var _offsetX : int = 0;
		protected var _offsetY : int = 0;

		//播放的帧速度比例
		protected var _frameDurationScale : Number = 1;

		/**
		 * 动画延时显示时间
		 */
		protected var _animationDelay : int;
		protected var _runnedTime : int;

		internal var rotatePointX : int;
		internal var rotatePointY : int;

		protected var _rotation : int;

		protected var _renderVisible : Boolean;
		/**
		 * 必要的时候是否能取消显示
		 * */
		public var isCanDisable : Boolean;

		public function SAnimatableComponent(type : * = null, loop : int = 0)
		{
			super(type ? type : SAnimatableComponent);
			_loops = loop;
			_renderVisible = true;
		}

		override public function notifyAdded() : void
		{
			super.notifyAdded();
			currAnimation = null;
			_updateAnimationFrame = null;
		}

		public function set currAnimation(value : SAnimation) : void
		{
			_curAnimationFrame = null;
			_currAnimation = value;
		}

		public function get currAnimation() : SAnimation
		{
			return _currAnimation;
		}

		/**
		 *
		 * @param animation
		 * @param delay 延时显示的时间
		 * @param rotation 要对动画进行旋转的角度
		 * @return
		 */
		public function setAnimation(animation : SAnimation, delay : int = 0, rotation : int = 0) : SAnimatableComponent
		{
			currAnimation = animation;
			if (_currAnimation)
			{
				gotoFrame(1);
				resume();
				setBlendMode(_currAnimation.blendMode);
			}
			_runnedTime = 0;
			_animationDelay = delay;
			setRotation(rotation);
			return this;
		}

		override public function setRotation(value : Number) : void
		{
			_rotation = value;
		}

		/**
		 * 设置动画在场景中的渲染位置
		 * @param mapX
		 * @param mapY
		 *
		 */
		public function setRenderPos(mapX : int, mapY : int) : void
		{
			_mapX = mapX;
			_mapY = mapY;
		}

		public function setRenderVisible(value : Boolean) : void
		{
			_renderVisible = value;
		}
		private var _isRenderDisable : Boolean = true;

		public function setRenderDisable(value : Boolean) : void
		{
			if (_isRenderDisable == value)
				return;
			_isRenderDisable = value;
		}

		/**
		 * 动画播放速度比例
		 * @param scale
		 *
		 */
		public function setFrameDurationScale(scale : Number) : void
		{
			if (scale > 0)
				_frameDurationScale = scale;
		}

		/**
		 * 设置动画相对于主体的一个偏移值
		 * @param offsetX
		 * @param offsetY
		 *
		 */
		public function setPositionOffset(x : int, y : int) : void
		{
			_offsetX = x;
			_offsetY = y;
		}

		protected function updateFrame(elapsedTime : int) : void
		{
			gotoNextFrame(elapsedTime, 0, _frameDurationScale);
		}

		override public function update() : void
		{
			if (_animationDelay > 0)
			{
				//延时将动画显示
				_runnedTime += elapsedTimes;
				if (_runnedTime >= _animationDelay)
				{
					_animationDelay = 0;
					_runnedTime = 0;
					_renderVisible = true;
				}
				else
				{
					_renderVisible = false;
				}
			}

			super.update();
			if (isEnd)
			{
				timeOut();
				return;
			}
		}

		/**
		 * 设置一个特定的场景渲染深度偏移值，如果为-1则使用父对象的深度 -1,即在父对象后面 ， 如果为1，则母体前
		 * @param depthOffset
		 */
		public function setRenderDepth(depthOffset : int) : void
		{
			_renderDepth = depthOffset;
		}

		override protected function updateRender(bufferX : Number, bufferY : Number) : void
		{
			if (_isDisposed || !_enabled || _animationDelay > 0 || _render == null)
				return;
			if (!_isRenderDisable)
			{
				if (_render.visible)
					_render.visible = false;
				return;
			}
			if (_updateAnimationFrame)
			{
				_render.x = bufferX + (_updateAnimationFrame.x + _offsetX);
				_render.y = bufferY + (_updateAnimationFrame.y + _offsetY);
				if (_renderUseCenterY)
					_render.y = _render.y + (_entity.centerOffsetY - _entity.centerOffsetZ);
				if (_renderUseMapZ)
					_render.y = _render.y - _entity.mapZ;
				_render.depth = _entity.depth;
				_render.layer = _entity.layer + _renderDepth;
				_render.visible = _renderVisible;
				if (_rotation != 0) //按中心点旋转
				{
					rotatePointX = -_updateAnimationFrame.x;
					rotatePointY = -_updateAnimationFrame.y;
					_render.rotate(SCommonUtil.getRotateByAngle(_rotation), rotatePointX, rotatePointY);
				}
			}
		}

		override protected function updateRenderProperty(elapsedTime : int) : void
		{
			if (_isDisposed || !_enabled || _animationDelay > 0 || _render == null)
				return;
			if (_currAnimation == null)
			{
				_render.bitmapData = null;
				return;
			}
			updateFrame(elapsedTime);

			if (_curAnimationFrame && _render.bitmapData != _curAnimationFrame.frameData)
			{
				_updateAnimationFrame = _curAnimationFrame;
				if (_curAnimationFrame.needReversal)
					_curAnimationFrame.reverseData();
				_render.scaleX = _curAnimationFrame.needReversal ? -1 : 1;
				_render.bitmapData = _curAnimationFrame.frameData;

				if (_bounds && _curAnimationFrame.rect)
				{
					_bounds.left = _entity.screenX + _offsetX + _curAnimationFrame.x;
					_bounds.top = _entity.screenY + _offsetY + _entity.centerOffsetY - _entity.centerOffsetZ + _curAnimationFrame.y;
					_bounds.width = _curAnimationFrame.rect.width;
					_bounds.height = _curAnimationFrame.rect.height;
				}
			}
		}

		/**
		 * 当前动画已持续的时间
		 */
		protected var _curAnimationDurations : int;

		/**
		 * 当前帧逝去时间
		 */
		protected var _curFrameElapsedTime : int;

		/**
		 * 当前帧持续的时间
		 */
		protected var _curFrameDuration : int;

		/**
		 * 当前的动画帧索引
		 */
		protected var _curFrameIndex : int;

		/**
		 * 是否暂停播放
		 */
		protected var _isPaused : Boolean;

		/**
		 * 当前帧是否到最后一帧
		 */
		protected var _isEnd : Boolean;

		/**
		 *  是否播放次数结束
		 */
		protected var _isLoopEnd : Boolean;


		/**
		 * 刚开始播放
		 */
		protected var _isJustStarted : Boolean;

		/**
		 * 当前已经循环的次数
		 */
		protected var _curLoop : int;

		public function get curFrameIndex() : int
		{
			return _curFrameIndex;
		}

		public function get totalFrame() : int
		{
			return _currAnimation ? _currAnimation.totalFrame : 1;
		}

		public function get isEnd() : Boolean
		{
			return _isEnd && _isLoopEnd;
		}

		public function get curAnimationFrame() : SAnimationFrame
		{
			return _curAnimationFrame;
		}

		// 恢复播放动画
		public function resume(elapsedTime : int = 0) : void
		{
			_isPaused = false;
			_curFrameElapsedTime = 0;
			_isEnd = false;
			_isLoopEnd = false;
			_curAnimationDurations = 0;
			_isJustStarted = true;
			_curLoop = 0;
		}

		public function get curFrame() : int
		{
			return _curFrameIndex + 1;
		}

		// 暂定播放动画
		public function pause() : void
		{
			_isPaused = true;
		}

		public function get isReachEnd() : Boolean
		{
			return _isEnd;
		}

		public function gotoNextFrame(elapsedTime : int, frameDuration : int = 0, durationScale : Number = 1, checkAttackFrame : Boolean = false) : SAnimationFrame
		{
			if (!_currAnimation)
				return null;
			if (!_curAnimationFrame)
				return gotoFrame(1);
			if (_isPaused)
				return _curAnimationFrame;

			if (frameDuration == 0)
				frameDuration = _curAnimationFrame.duration;

			if (durationScale != 1)
				frameDuration = Math.round(frameDuration * durationScale);

			_isJustStarted = false;

			_curFrameElapsedTime += elapsedTime;
			_curAnimationDurations += elapsedTime;

			//如果该帧停留的次数超过了定义的次数，获取下一帧
			if (_curFrameElapsedTime >= frameDuration)
			{
				//要强制跳的帧数
				var skipFrames : int = (frameDuration > 0 ? (_curFrameElapsedTime / frameDuration) : _curFrameElapsedTime);
				if (skipFrames >= 2)
				{
					//大于一帧的跳帧情况
					do
					{
						_curFrameElapsedTime -= frameDuration;
						_curFrameIndex += 1;
						if (_curFrameIndex >= totalFrame)
						{
							_curFrameIndex = totalFrame;
							break;
						}
						else
						{
							frameDuration = 0;
							var nextFrame : SAnimationFrame = getFrame(_curFrameIndex + 1);
							if (nextFrame)
							{
								frameDuration = nextFrame.duration;
								if (durationScale != 1)
									frameDuration = Math.round(frameDuration * durationScale);
							}
						}
					} while (_curFrameElapsedTime >= frameDuration)
				}
				else
				{
					//求余值 
					_curFrameElapsedTime = _curFrameElapsedTime % frameDuration;
					_curFrameIndex += skipFrames;
				}

				//如果播放到动画尾，重新从第一帧开始播放
				if (_curFrameIndex >= totalFrame)
				{
					_curLoop++;
					//从0帧开始跳转 当前帧索引 相对于 总帧数 的余数
					var startFameIndex : int = _curFrameIndex % totalFrame;
					//如果需要记录结束 ，则不跳转
					if (_loops > 0 && _curLoop >= _loops)
					{
						gotoFrame(totalFrame);
						_isLoopEnd = true;
					}
					else
					{
						_curAnimationDurations = 0;
						_isJustStarted = true;
						gotoFrame(startFameIndex + 1);
					}
				}
				else
				{
					gotoFrame(_curFrameIndex + 1);
				}
			}
			_curFrameDuration = frameDuration;

			if (_curFrameIndex >= totalFrame && _curFrameElapsedTime >= frameDuration)
				_isEnd = true;
			return _curAnimationFrame;
		}

		public function getFrame(frame : int) : SAnimationFrame
		{
			return _currAnimation ? _currAnimation.getFrame(frame - 1) : null;
		}

		public function gotoFrame(frame : int) : SAnimationFrame
		{
			if (!_currAnimation)
				return null;
			if (frame < 1)
				frame = 1;
			if (frame > totalFrame)
				frame = totalFrame;
			_curFrameElapsedTime = 0;
			_curFrameIndex = frame - 1;

			if (_currAnimation)
			{
				_currAnimation.constructFrames(frame);
				_curAnimationFrame = _currAnimation.getFrame(_curFrameIndex);
				while (_curAnimationFrame && _curAnimationFrame.duration <= 0)
				{
					frame++;
					_curFrameIndex = frame - 1;
					if (_curFrameIndex >= 0 && _curFrameIndex < totalFrame)
					{
						_currAnimation.constructFrames(frame);
						_curAnimationFrame = _currAnimation.getFrame(_curFrameIndex);
					}
					else
					{
						frame = totalFrame;
						_curFrameIndex = frame - 1;
						_currAnimation.constructFrames(frame);
						_curAnimationFrame = _currAnimation.getFrame(_curFrameIndex);
						break;
					}
				}
			}
			if (frame < totalFrame)
				_isEnd = false;
			else
				_isEnd = true;
			return _curAnimationFrame;
		}


		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			_updateAnimationFrame = null;
			currAnimation = null;
			super.destroy();
		}
	}
}