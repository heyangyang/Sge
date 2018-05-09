package com.sunny.game.engine.component.render
{
	import com.sunny.game.engine.component.SDisposableComponent;
	import com.sunny.game.engine.component.bound.SBoundingComponent;
	import com.sunny.game.engine.core.SIRenderable;
	import com.sunny.game.engine.entity.SRenderableEntity;
	import com.sunny.game.engine.render.base.SBaseRenderData;
	import com.sunny.game.engine.render.interfaces.SIRenderData;
	
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;

	/**
	 *
	 * <p>
	 * SunnyGame的一个可渲染组件
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
	public class SRenderableComponent extends SDisposableComponent implements SIRenderable
	{
		protected var _render : SIRenderData;
		protected var _entity : SRenderableEntity;

		protected var _bounds : SBoundingComponent;

		/**
		 * 是否将渲染中心点由原始对象中心点+中心偏移值来计算渲染位置，如果为FALSE则在原始中心点渲染
		 */
		protected var _renderUseCenterY : Boolean = true;

		protected var _renderUseMapZ : Boolean = true;

		/**
		 *  是否允许鼠标
		 */
		public var mouseEnabled : Boolean ;

		/**
		 * 是否允许滤镜
		 */
		public var enableFilter : Boolean;
		/**
		 * 是否允许调色板
		 */
		public var enableColorTransform : Boolean;

		protected var _originFrameRate : int;
		protected var _propertyElapsedTime : int = 0;
		private var _propertyUpdateDelay : int = 30;

		protected var _renderDataClass : Class;

		public function SRenderableComponent(type : * = null, renderDataClase : Class = null)
		{
			super(type || SRenderableComponent);

			_renderDataClass = renderDataClase || SBaseRenderData.renderClass;
			_render = new _renderDataClass();
		}

		override public function notifyAdded() : void
		{
			super.notifyAdded();
			mouseEnabled = false;
			enableFilter = false;
			enableColorTransform = false;

			_entity = owner as SRenderableEntity;
			_originFrameRate = frameRate;
			_render.name = _entity.name + '_render';
			addRender(_render);
		}

		override public function notifyRemoved() : void
		{
			super.notifyRemoved();
		}

		public function setBoundsComponent(comp : SBoundingComponent) : void
		{
			_bounds = comp;
		}

		public function setBlendMode(blendMode : String) : void
		{
			if (_render)
				_render.blendMode = blendMode ? blendMode : BlendMode.NORMAL;
		}

		public function setScale(value : Number) : void
		{
			if (_render)
				_render.scaleX = _render.scaleY = value;
		}

		public function setRotation(value : Number) : void
		{
			if (_render)
				_render.rotation = value;
		}

		public function setFilters(value : Array) : void
		{
			if (_render)
				_render.filters = value;
		}

		public function setColorTransform(value : ColorTransform) : void
		{
			if (_render)
				_render.colorTransform = value;
		}

		/**
		 * 是否将渲染中心点由原始对象中心点+中心偏移值来计算渲染位置，如果为FALSE则在原始中心点渲染
		 * ,比如骑上坐骑后是否要将动画渲染到角色上还是在坐骑脚底下
		 */
		public function setRenderUseCenterY(value : Boolean) : void
		{
			_renderUseCenterY = value;
		}

		public function setRenderUseMapZ(value : Boolean) : void
		{
			_renderUseMapZ = value;
		}

		override public function update() : void
		{
			if (_isDisposed)
				return;
			if (!_enabled)
				return;
			super.update();
			if (_entity == null)
				return;
			if (updatable)
			{
				var propertyElapsedTime : int = propertyUpdatable();
				if (propertyElapsedTime > 0)
					updateRenderProperty(propertyElapsedTime);
				if (_entity)
					updateRender(_entity.screenX, _entity.screenY);
			}
		}

		protected function updateRender(bufferX : Number, bufferY : Number) : void
		{
			if (_isDisposed)
				return;
			if (!_enabled)
				return;
			if (_render)
			{
				if (_render.bitmapData)
				{
					_render.x = bufferX - _render.width * 0.5 * _entity.scaleX;
					_render.y = bufferY - _render.height * 0.5 * _entity.scaleY;
					if (_renderUseCenterY)
						_render.y = _render.y + (_entity.centerOffsetY - _entity.centerOffsetZ) * _entity.scaleY;
					if (_renderUseMapZ)
						_render.y = _render.y - _entity.mapZ;
					_render.depth = _entity.depth;
					_render.layer = _entity.layer;
				}
			}
		}

		/**
		 * 更新主渲染对象的属性
		 * @param elapsedTime
		 * @param bufferX
		 * @param bufferY
		 *
		 */
		protected function updateRenderProperty(elapsedTime : int) : void
		{
			if (_isDisposed)
				return;
			if (!_enabled)
				return;
			if (_entity.isInScreen && _render)
			{
				if (enableFilter && _render.filters != _entity.filters)
					_render.filters = _entity.filters;
				if (enableColorTransform && _render.colorTransform != _entity.colorTransform)
					_render.colorTransform = _entity.colorTransform;

				if (_bounds)
				{
					_bounds.left = _entity.screenX - _render.width / 2;
					_bounds.top = _entity.screenY - _render.height / 2;
					if (_renderUseCenterY)
						_bounds.top = _bounds.top + _entity.centerOffsetY - _entity.centerOffsetZ;
					if (_renderUseMapZ)
						_bounds.top = _bounds.top - _entity.mapZ;
					_bounds.width = _render.width;
					_bounds.height = _render.height;
				}
			}
			else
			{
				if (_bounds)
				{
					_bounds.left = 0;
					_bounds.top = 0;
					_bounds.width = 0;
					_bounds.height = 0;
				}
			}
		}

		/**
		 * 是否能够更新
		 * @return
		 */
		protected function get updatable() : Boolean
		{
			if (_entity)
				return _entity.isInScreen;
			return false;
		}

		private function propertyUpdatable() : int
		{
			if (_entity)
			{
				if (_entity.isInScreen)
				{
					var propertyElapsedTime : int = 0;
					_propertyElapsedTime += elapsedTimes;
					if (_propertyElapsedTime >= _propertyUpdateDelay)
					{
						propertyElapsedTime = _propertyElapsedTime;
						_propertyElapsedTime = 0;
					}
					return propertyElapsedTime;
				}
			}
			_propertyElapsedTime = 0;
			return 0;
		}

		public function addRender(render : SIRenderData) : void
		{
			if (_entity)
				_entity.addRender(render);
		}

		public function removeRender(render : SIRenderData) : void
		{
			if (_entity)
				_entity.removeRender(render);
		}

		public function get render() : SIRenderData
		{
			return _render;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_render)
			{
				removeRender(_render);
				_render.dispose();
			}
			_entity = null;
			_bounds = null;
			super.destroy();
		}
	}
}