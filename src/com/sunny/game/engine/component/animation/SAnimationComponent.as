package com.sunny.game.engine.component.animation
{
	import com.sunny.game.engine.animation.SAnimation;
	import com.sunny.game.engine.animation.SAnimationFrame;
	import com.sunny.game.engine.effect.SEffectAnimationLibrary;
	import com.sunny.game.engine.effect.SEffectDescription;
	import com.sunny.game.engine.effect.SEffectResource;
	import com.sunny.game.engine.enum.SDirection;
	import com.sunny.game.engine.loader.SLoadPriorityType;
	import com.sunny.game.engine.manager.SMemoryManager;
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.utils.SCommonUtil;

	import flash.display.BlendMode;

	/**
	 *
	 * <p>
	 * SunnyGame的一个动画组件
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
	public class SAnimationComponent extends SAnimatableComponent
	{
		private var _curEffectId : String;
		protected var _resource : SEffectResource;
		protected var _isEffectChanging : Boolean;
		protected var _isEffectChange : Boolean;
		private var _notifyComplete : Function = null;

		protected var _priority : int = 0;
		protected var _animationDelayTime : int = 0;
		protected var _duration : int;
		protected var _useMapZ : Boolean;
		protected var _zIndexOffset : int;
		protected var _blendMode : String;
		private var _durationScale : Number;

		protected var _collection : SEffectAnimationLibrary;
		protected var _around : Boolean;

		/**
		 * 为目标添加一个特定的动画
		 * @param target
		 * @param animationUnqueId 动画在对象中的唯一标志，用于查找删除
		 * @param animationId 动画ID
		 * @param animationPosition 动画在对象上的偏移，百分比
		 * @param zIndexOffset 渲染深度偏移，-1是身后，1是身前
		 * @param duration 持续时间
		 * @param loop 循环次数，0表示无限循环
		 * @param animationSpeed 动画速度
		 * @param animationDelay 动画延时显示
		 * @param disposeAnimation 是否在动画结束之后清除内存
		 * @param renderWidthPointOffset 是否将渲染中心点由原始对象中心点+中心偏移值来计算渲染位置，如果为FALSE则在原始中心点渲染， 默认为true
		 * @param rotation ,要进行旋转的角度，比如90度。如果非等于0则认为是需要旋转的
		 * @param blendMode 混合模式
		 * @param isReplace 替换资源会导致重新加载
		 */
		public function SAnimationComponent(type : * = null, loop : int = 0)
		{
			super(type ? type : SAnimationComponent, loop);
		}

		public function setType(type : * = null, loop : int = 0) : void
		{
			if (_render == null)
				_render = new _renderDataClass();
			else
				_render.recycle();
			_isDisposed = false;
			_type = type;
			_loops = loop;

			_curEffectId = null;
			_enabled = true;
			_offsetX = _offsetY = 0;
			elapsedTimes = 0;
			_renderVisible = true;
			_curLoop = _curAnimationDurations = _curFrameElapsedTime = _curFrameDuration = _curFrameIndex = 0;
			_isJustStarted = _isPaused = _isLoopEnd = _isEnd = false;
			_isEffectChanging = false;
			_isEffectChange = false;
			_renderUseCenterY = true
			_blendMode = null;
		}

		public function setAnimationInfomation(duration : int = 0, delayTime : int = 0, rotation : Number = 0, priority : int = SLoadPriorityType.EFFECT, useMapZ : Boolean = true, around : Boolean = false) : void
		{
			_rotation = rotation;
			_animationDelayTime = delayTime;
			_duration = duration;
			_useMapZ = useMapZ;
			_around = around;
			_priority = priority;
			_durationScale = 1;
			_zIndexOffset = 0;
		}

		override public function notifyAdded() : void
		{
			super.notifyAdded();
			setRenderUseMapZ(_useMapZ);
			setFrameDurationScale(_durationScale);
			disposeType = _disposeType;
			setLifeTick(_duration);
		}

		public function clear() : void
		{
			disposeCollect();
		}

		public function set collection(value : SEffectAnimationLibrary) : void
		{
			if (_collection)
				_collection.release();
			_collection = value;
		}

		public function get collection() : SEffectAnimationLibrary
		{
			return _collection;
		}

		protected function disposeCollect() : void
		{
			if (_resource)
			{
				_resource.removeComplete(notifyResourceCompleted);
				_resource.destroy();
				_resource = null;
			}
			_isEffectChanging = false;
			_isEffectChange = false;
			_currAnimation = null;
			_curAnimationFrame = null;
		}

		public function setEffectId(effectId : String) : void
		{
			if (!effectId)
				throw new ArgumentError(_entity.name + '特效资源ID配置错误,初始Effect失败!');
			if (_curEffectId == effectId)
				return;
			if (_collection)
			{
				_collection = null;
				disposeCollect();
			}
			_curEffectId = effectId;
			_isEffectChange = true;
		}

		public function get effectId() : String
		{
			return _curEffectId;
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
			if (_entity == null)
				return;
			collection = null;
			disposeCollect();
			if (!_entity.isInScreen)
				return;
			if (!_curEffectId)
				return;

			_isEffectChanging = true;
			_resource = new SEffectResource(_curEffectId);
			_resource.onComplete(notifyResourceCompleted);
			_resource.load(_priority);
		}

		public function onNotifyComplete(func : Function) : void
		{
			_notifyComplete = func;
		}

		protected function notifyResourceCompleted(resource : SEffectResource) : void
		{
			if (isDisposed)
				return;
			_isEffectChanging = false;
			collection = SReferenceManager.getInstance().createEffectCollection(SEffectDescription.getEffectDescription(_curEffectId), true);
			gotoAnimation(_entity.correctDirection);

			if (_notifyComplete != null)
				_notifyComplete();
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			collection = null;
			disposeCollect();
			_notifyComplete = null;
			SMemoryManager.recycle(this, SAnimationComponent);
			super.destroy();
		}

		override protected function updateRender(bufferX : Number, bufferY : Number) : void
		{
			if (_isDisposed)
				return;
			if (!_enabled)
				return;
			if (_animationDelay > 0)
				return;
			if (_render == null || _currAnimation == null)
				return;
			var frame : SAnimationFrame = _curAnimationFrame;
			if (frame && frame == _curAnimationFrame)
			{
				super.updateRender(bufferX, bufferY);
				if (_around)
				{
					var angle : Number = SCommonUtil.getAngleByDir(_entity.direction);
					var dx : Number = SCommonUtil.cosd(angle);
					var dy : Number = SCommonUtil.sind(angle);
					var ox : int = _currAnimation.width * 0.5 - _currAnimation.centerX;
					var oy : int = _currAnimation.height * 0.5 - _currAnimation.centerY;
					var px : int = Math.round(dx * ox) - Math.round(dy * oy);
					var py : int = Math.round(dx * oy) + Math.round(dy * ox);

					_render.x = bufferX + (frame.x + _offsetX - ox + px);
					_render.y = bufferY + (frame.y + _offsetY - oy + py);
					if (_renderUseCenterY)
						_render.y = _render.y + (_entity.centerOffsetY - _entity.centerOffsetZ);
					if (_renderUseMapZ)
						_render.y = _render.y - _entity.mapZ;
				}
			}
		}

		override protected function updateRenderProperty(elapsedTime : int) : void
		{
			if (_isDisposed)
				return;
			if (!_enabled)
				return;
			if (_animationDelay > 0)
				return;
			if (!_entity)
				return;
			if (_entity.isInScreen)
			{
				if (!_collection && _isEffectChange && !_isEffectChanging)
					loadResource();
			}

			if (_collection)
			{
				if (!SDirection.equalsDirection(_collection.dirMode, _cur_dir, _cur_dir, _entity.correctDirection))
				{
					if (_currAnimation)
						gotoAnimation(_entity.correctDirection, curFrame);
					else
						gotoAnimation(_entity.correctDirection);
				}

				super.updateRenderProperty(elapsedTime);
				if (_bounds)
				{
					_bounds.left = _entity.screenX;
					_bounds.top = _entity.screenY + _entity.centerOffsetY - _entity.centerOffsetZ - _entity.mapZ;
					_bounds.width = _collection.width;
					_bounds.height = _collection.height;
				}
			}
		}

		public function updateCenter(centerX : int, centerY : int) : void
		{
			_collection && _collection.updateCenter(centerX, centerY);
		}

		/**
		 * 播放 指定动画
		 * @param action  动作名称
		 * @param dir 方向
		 * @param index 跳到 Frame
		 * @return
		 *
		 */
		public function gotoAnimation(dir : int = 0, frame : int = 1) : SAnimation
		{
			if (_collection)
			{
				_cur_dir = dir;
				setAnimation(_collection.gotoAnimation(dir), _animationDelayTime, _rotation);
				if (_currAnimation)
				{
					setRenderDepth(_zIndexOffset == 0 ? _currAnimation.depth : _zIndexOffset);
					setBlendMode(_blendMode || _currAnimation.blendMode || BlendMode.NORMAL);
					gotoFrame(frame);
					return _currAnimation;
				}
			}
			return null;
		}
	}
}