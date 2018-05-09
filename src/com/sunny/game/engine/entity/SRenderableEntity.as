package com.sunny.game.engine.entity
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.enum.SDirection;
	import com.sunny.game.engine.render.interfaces.SIRenderData;
	import com.sunny.game.engine.render.SBaseRenderManager;
	import com.sunny.game.engine.render.SSceneRenderManagaer;
	import com.sunny.game.engine.utils.SCommonUtil;

	import flash.display.BlendMode;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;




	/**
	 *
	 * <p>
	 * SunnyGame的可渲染实体
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
	public class SRenderableEntity extends SEntity
	{
		public var entityType : int;

		protected var _renders : Array = [];

		public var isShowAavatar : Boolean = true;
		/**
		 * 显示的宽度
		 */
		public var displayWidth : int;
		/**
		 * 显示 的身高，包括名字，称号等的身高
		 */
		public var displayHeight : int;

		private var _alpha : Number = 1.0;

		/**
		 * 资源的宽度
		 */
		private var _width : int = 50;
		/**
		 * 资源的高度
		 */
		private var _height : int = 100;
		private var _scaleX : Number = 1.0;
		private var _scaleY : Number = 1.0;
		private var _visible : Boolean = true;
		private var _filters : Array = null;
		private var _rotation : Number = 0.0;
		private var _smoothing : Boolean;

		private var _blendMode : String = BlendMode.NORMAL;

		private var _tabIndex : int = -1;
		private var _tabEnabled : Boolean = true;

		private var _mouseEnabled : Boolean = false;
		private var _mouseChildren : Boolean = false;

		public var rotatePointX : Number = 0;
		public var rotatePointY : Number = 0;

		/**
		 * 是否需要检测透明
		 */
		public var needCheckMask : Boolean = true;

		/**
		 * 是否在屏幕内
		 */
		public var isInScreen : Boolean;
		/**
		 * 相对于地图中的位置
		 */
		private var _mapX : Number = 0;
		private var _mapY : Number = 0;
		private var _mapZ : Number = 0;

		private var _depth : int = 0;
		private var _layer : int = 0;

		/**
		 * 移动速度（px/ms）
		 */
		private var _moveSpeed : Number = 0;
		/**
		 * 跳跃速度（px/ms）
		 */
		public var jumpSpeed : Number = 0;

		private var _direction : uint = SDirection.EAST;
		private var _correctDirection : uint = SDirection.EAST;
		public var dx : Number = 0;
		public var dy : Number = 0;
		public var angle : Number = 0;

		/**
		 * 中心点X偏移 ，脚底到原始中心点的距离
		 */
		public var centerOffsetX : int = 0;
		/**
		 * 中心点Y偏移 ，脚底到原始中心点的距离，比如跳跃和骑上坐骑之后角色需要偏离上去
		 */
		public var centerOffsetY : int = 0;

		public var centerOffsetZ : int = 0;

		/**
		 * 透明是否被锁定
		 */
		private var _isAlphaLockd : Boolean;

		/**
		 * 颜色板，调节颜色;
		 * 要修改alpha 请调用 setTransparent 函数
		 */
		public var colorTransform : ColorTransform;

		//将所有的调色板缓存队列，在一个结束之后
		public var colorTransforms : Array = [];

		/**
		 * 是否鼠标经过
		 */
		public var isMouseOver : Boolean;

//		private static var mouseOverGlowFilters : Array = [new GlowFilter(0x00f0ff, 1, 6, 6, 2)];
		private static var mouseOverGlowFilters : Array = [new GlowFilter(0xffff00, 1, 6, 6, 2)];
//		private static var mouseOverColorTransform : ColorTransform = new ColorTransform(1, 1, 1, 1, 60, 60, 60, 0);

		private var _render : SBaseRenderManager;
		private var _lastIsInScreen : Boolean = false;

		private var _saveToCookie : Boolean = false;
		private var _clearMemory : Boolean = true;

		public function SRenderableEntity(id : int, name : String, entityType : int, render : SBaseRenderManager = null)
		{
			super(id, name);
			this.entityType = entityType;
			enabled = true;
			_render = render;
			if (!_render)
				_render = SSceneRenderManagaer.getInstance();
		}

		public function get direction() : uint
		{
			return _direction;
		}

		private var _dirMode : uint = SDirection.DIR_MODE_HOR_ONE;

		public function set dirMode(value : uint) : void
		{
			_dirMode = value;
			direction = _direction;
		}

		public function get dirMode() : uint
		{
			return _dirMode;
		}

		public var lockDirection : Boolean = false;

		public function set direction(value : uint) : void
		{
			if (lockDirection)
				return;
			_direction = value;
			_correctDirection = SDirection.correctDirection(_dirMode, _correctDirection, _direction); //对方向进行修正
//			if (this is SRoleEntity && (this as SRoleEntity).isMe)
//				SMonitor.getInstance().appendDebugInfo("方向" + _direction);
		}

		public function addRender(render : SIRenderData) : Boolean
		{
			if (render == null)
				return false;
			if (isActive == false)
				return false;
			if (_renders.indexOf(render) == -1)
			{
				if (_alpha != 1.0)
					render.alpha = _alpha;
				if (_rotation != 0)
					render.rotation = _rotation;
				if (_scaleX != 1.0)
					render.scaleX = _scaleX;
				if (_scaleY != 1.0)
					render.scaleY = _scaleY;
				if (_blendMode && _blendMode != BlendMode.NORMAL)
					render.blendMode = _blendMode;
				_renders.push(render);
				if (isRendering)
					return _render.addRender(render);
			}
			return false;
		}

		public function removeRender(render : SIRenderData) : Boolean
		{
			if (!render)
				return false;
			if (_isDisposed)
				return false;

			if (_renders)
			{
				var index : int = _renders.indexOf(render);
				if (index != -1)
				{
					_renders.splice(index, 1);
					if (isRendering)
						return _render.removeRender(render);
				}
			}
			return false;
		}

		public function getRenderByName(name : String) : SIRenderData
		{
			for (var i : int = 0; i < _renders.length; i++)
			{
				if (_renders[i].name == name)
					return _renders[i] as SIRenderData;
			}
			return null;
		}

		public function getRenderByIndex(index : int) : SIRenderData
		{
			if (index < 0 || index > _renders.length - 1)
				return null;
			return _renders[index] as SIRenderData;
		}

		public function get renders() : Array
		{
			return _renders;
		}

		override public function update() : void
		{
			if (_isDisposed)
				return;
			if (!_enabled)
				return;
			isInScreen = checkIsInScreen();
			if (isInScreen)
				addToRendering();
			else
				removeFromRendering();
			super.update();

			if (_isStatic)
			{
				if (isInScreen != _lastIsInScreen)
				{
					if (_lastIsInScreen)
						frameRate = 1;
					else
						frameRate = SShellVariables.frameRate;
					_lastIsInScreen = isInScreen;
				}
			}
			else
			{
				if (isInScreen != _lastIsInScreen)
				{
					if (_lastIsInScreen)
						frameRate = SShellVariables.LOW_FRESH_RATE;
					else
						frameRate = SShellVariables.frameRate;
					_lastIsInScreen = isInScreen;
				}
			}
		}

		/**
		 * 上一次是否在屏幕内
		 * @return
		 */
		public function get lastIsInScreen() : Boolean
		{
			return _lastIsInScreen;
		}

		public var isRendering : Boolean = false;

		private function addToRendering() : void
		{
			if (isRendering)
				return;
			isRendering = true;
			for each (var render : SIRenderData in _renders)
				_render.addRender(render);
		}

		private function removeFromRendering() : void
		{
			if (!isRendering)
				return;
			isRendering = false;
			for each (var render : SIRenderData in _renders)
				_render.removeRender(render);
		}

		/**
		 * 是否在屏幕之内
		 * @return
		 */
		protected function checkIsInScreen() : Boolean
		{
			return _visible && SCommonUtil.isInScreenByScreenPoint(screenX, screenY, width, height);
		}

		public function move(elapsedTime : int) : void
		{
			if (elapsedTime == 0)
				return;
			//防止缩略时时间过大导致一步走好远
			if (elapsedTime >= 100)
				elapsedTime = 25;

			var distance : Number = _moveSpeed * elapsedTime;
			dx = SDirection.COS_DIR[direction] * distance;
			dy = SDirection.SIN_DIR[direction] * distance;

			_mapX += dx;
			_mapY += dy;
		}

		/**
		 * 锁定透明，不能被修改
		 */
		public function lockTransparent() : void
		{
			_isAlphaLockd = true;
		}

		/**
		 * 解除锁定透明，能被修改
		 */
		public function unlockTransparent() : void
		{
			_isAlphaLockd = false;
		}

		/**
		 * 设置鼠标滑过
		 * @param value
		 */
		public function setMouseOver(value : Boolean) : void
		{
			if (isMouseOver == value)
				return;
			isMouseOver = value;
			//if (this is SMonsterEntity)
			{
//				colorTransform = isMouseOver ? mouseOverColorTransform : mouseOutColorTransform;
				_filters = isMouseOver ? mouseOverGlowFilters : null;
//				if (isMouseOver)
//					addFilter(mouseOverGlowFilter);
//				else
//					removeFilter(mouseOverGlowFilter);
			}
		}

		private var _blankColorTransform : ColorTransform = new ColorTransform();

		/**
		 * 设置调色板
		 * @param colortf
		 */
		public function setColorTransform(colortf : ColorTransform) : void
		{
			if (colorTransform)
			{
				var index : int = colorTransforms.indexOf(colorTransform);
				if (index == -1)
					colorTransforms.push(colorTransform);
			}
			colortf.alphaMultiplier = _alpha;
			colorTransform = colortf;
		}

		public function removeColorTransform(colortf : ColorTransform) : void
		{
			if (colortf == colorTransform)
			{
				if (colorTransforms.length > 0)
					colorTransform = colorTransforms.pop();
				else
					colorTransform = _blankColorTransform;
			}
			else
			{
				var index : int = colorTransforms.indexOf(colortf);
				if (index != -1)
					colorTransforms.splice(index, 1);
			}
		}

		/**
		 * 为这个对象添加一个滤镜
		 * @param bf
		 */
//		public function addFilter(bf : BitmapFilter) : void
//		{
//			if (bf != null)
//			{
//				if (!filters)
//					filters = [];
//				if (filters.indexOf(bf) == -1)
//				{
//					filters.push(bf);
//				}
//			}
//		}

		/**
		 * 删除一个滤镜
		 * @param bf
		 */
//		public function removeFilter(bf : BitmapFilter) : void
//		{
//			if (bf != null && filters && filters.length > 0)
//			{
//				var index : int = filters.indexOf(bf);
//				if (index != -1)
//				{
//					filters.splice(index, 1);
//				}
//			}
//		}

		private var _isStatic : Boolean;

		/**
		 * 是否为静止物件，如果TRUE 则 在屏幕之外时将其以1帧运行
		 * @param value
		 */
		public function set isStatic(value : Boolean) : void
		{
			_isStatic = value;
//			if (_isStatic)
//				frameRate = 1;
		}

		public function get isStatic() : Boolean
		{
			return _isStatic;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			removeFromRendering();
			if (_renders)
			{
				_renders.length = 0;
				_renders = null;
			}
			_render = null;
			filters = null;
			colorTransform = null;
			super.destroy();
		}

		public function get alpha() : Number
		{
			return _alpha;
		}

		public function set alpha(value : Number) : void
		{
			if (_alpha == value)
				return;
			if (_isAlphaLockd)
				return;
			_alpha = value;

			for each (var render : SIRenderData in _renders)
			{
				if (!render.isDisposed)
					render.alpha = _alpha * render.alphaMultiplier;
			}
		}

		public function get width() : int
		{
			return _width;
		}

		public function set width(value : int) : void
		{
			_width = value;
		}

		public function get height() : int
		{
			return _height;
		}

		public function set height(value : int) : void
		{
			_height = value;
		}

		public function get visible() : Boolean
		{
			return _visible;
		}

		public function set visible(value : Boolean) : void
		{
			if (_visible == value)
				return;
			_visible = value;

			if (_visible)
				addToRendering();
			else
				removeFromRendering();
		}

		public function get filters() : Array
		{
			return _filters;
		}

		public function set filters(value : Array) : void
		{
			_filters = value;
		}

		public function get rotation() : Number
		{
			return _rotation;
		}

		public function set rotation(value : Number) : void
		{
			if (_rotation == value)
				return;
			_rotation = value;

			for each (var render : SIRenderData in _renders)
			{
				if (!render.isDisposed)
					render.rotation = _rotation;
			}
		}

		public function get blendMode() : String
		{
			return _blendMode;
		}

		public function set blendMode(value : String) : void
		{
			if (_blendMode == value)
				return;
			_blendMode = value;
			for each (var render : SIRenderData in _renders)
			{
				if (!render.isDisposed)
					render.blendMode = _blendMode;
			}
		}

		public function get tabIndex() : int
		{
			return _tabIndex;
		}

		public function set tabIndex(value : int) : void
		{
			_tabIndex = value;
		}

		public function get tabEnabled() : Boolean
		{
			return _tabEnabled;
		}

		public function set tabEnabled(value : Boolean) : void
		{
			_tabEnabled = value;
		}

		public function get mouseEnabled() : Boolean
		{
			return _mouseEnabled;
		}

		public function set mouseEnabled(value : Boolean) : void
		{
			_mouseEnabled = value;
		}

		public function get mouseChildren() : Boolean
		{
			return _mouseChildren;
		}

		public function set mouseChildren(value : Boolean) : void
		{
			_mouseChildren = value;
		}

		public function get scaleX() : Number
		{
			return _scaleX;
		}

		public function set scaleX(value : Number) : void
		{
			if (_scaleX == value)
				return;
			_scaleX = value;
			for each (var render : SIRenderData in _renders)
			{
				if (!render.isDisposed)
					render.scaleX = _scaleX;
			}
		}

		public function get scaleY() : Number
		{
			return _scaleY;
		}

		public function set scaleY(value : Number) : void
		{
			if (_scaleY == value)
				return;
			_scaleY = value;
			for each (var render : SIRenderData in _renders)
			{
				if (!render.isDisposed)
					render.scaleY = _scaleY;
			}
		}

		public function get mapX() : Number
		{
			return _mapX;
		}

		public function set mapX(value : Number) : void
		{
			_mapX = value;
		}

		public function get mapY() : Number
		{
			return _mapY;
		}

		public function set mapY(value : Number) : void
		{
			_mapY = value;
		}

		/**
		 * 在屏幕的X位置
		 */
		public function get screenX() : Number
		{
			return _mapX - _render.viewX;
		}

		/**
		 * 在屏幕的Y位置
		 */
		public function get screenY() : Number
		{
			return _mapY - _render.viewY;
		}

		public function get gridX() : int
		{
			return SCommonUtil.getGridXByPixel(_mapX);
		}

		public function get gridY() : int
		{
			return SCommonUtil.getGridYByPixel(_mapY);
		}

		public function get gridZ() : int
		{
			return SCommonUtil.getGridYByPixel(_mapZ);
		}

		public function set gridX(value : int) : void
		{
			if (gridX == value)
				return;
			mapX = SCommonUtil.getPixelXByGrid(value);
		}

		public function set gridY(value : int) : void
		{
			if (gridY == value)
				return;
			mapY = SCommonUtil.getPixelYByGrid(value);
		}

		public function get mapZ() : Number
		{
			return _mapZ;
		}

		public function set mapZ(value : Number) : void
		{
			_mapZ = value;
		}

		public function get moveSpeed() : Number
		{
			return _moveSpeed;
		}

		public function set moveSpeed(value : Number) : void
		{
			_moveSpeed = value;
		}

		public function get correctDirection() : uint
		{
			return _correctDirection;
		}

		public function get depth() : int
		{
			if (_depth == 0)
				return _mapY;
			return _depth;
		}

		public function set depth(value : int) : void
		{
			_depth = value;
		}

		public function get layer() : int
		{
			if (_layer == 0)
				return -_height;
			return _layer;
		}

		public function set layer(value : int) : void
		{
			_layer = value;
		}

		public function get clearMemory() : Boolean
		{
			return false; //_clearMemory;
		}

		public function set clearMemory(value : Boolean) : void
		{
			_clearMemory = value;
		}
	}
}