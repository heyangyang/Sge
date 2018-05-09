package com.sunny.game.engine.component.camera
{
	import com.sunny.game.engine.cfg.SEngineConfig;
	import com.sunny.game.engine.component.SUpdatableComponent;
	import com.sunny.game.engine.core.SMapConfig;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.entity.SRenderableEntity;
	import com.sunny.game.engine.enum.SDirection;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.events.SEventPool;
	import com.sunny.game.engine.map.SEarthSurface;
	import com.sunny.game.engine.render.SSceneRenderManagaer;

	/**
	 *
	 * <p>
	 * SunnyGame的摄像机组件，始终保持居中，跟随一个角色
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
	public class SCameraComponent extends SUpdatableComponent
	{
		protected var _entity : SRenderableEntity;
		protected var _halfViewWidth : int;
		protected var _halfViewHeight : int;

		protected var _cameraX : Number;
		protected var _cameraY : Number;

		protected var mapRightBorder : int = 0;
		protected var mapBottomBorder : int = 0;
		protected var mapLeftBorder : int = 0;
		protected var mapTopBorder : int = 0;

		protected var _leftBorder : int;
		protected var _rightBorder : int;
		protected var _topBorder : int;
		protected var _bottomBorder : int;

		protected var _shakeX : Number = 0;
		protected var _shakeY : Number = 0;

		protected var _sceneRender : SSceneRenderManagaer;
		protected var _focusEnabled : Boolean;
		protected var _updateCameraEnabled : Boolean;

		public function SCameraComponent(id : * = null)
		{
			super(id || SCameraComponent);
			_focusEnabled = true;
			_updateCameraEnabled = true;
			_sceneRender = SSceneRenderManagaer.getInstance();
		}

		public function get shakeY() : Number
		{
			return _shakeY;
		}

		public function get shakeX() : Number
		{
			return _shakeX;
		}

		override public function notifyAdded() : void
		{
			super.notifyAdded();
			_entity = owner as SRenderableEntity;

			_cameraX = _entity.mapX;
			_cameraY = _entity.mapY;
			_shakeX = 0;
			_shakeY = 0;

			mapLeftBorder = SMapConfig.leftBorder;
			mapTopBorder = SMapConfig.topBorder;
			mapRightBorder = SMapConfig.rightBorder;
			mapBottomBorder = SMapConfig.bottomBorder;

			resize(SShellVariables.gameWidth, SShellVariables.gameHeight);
			SEventPool.addEventListener(SEvent.RESIZE, onResize);
			SEventPool.addEventListener(SEarthSurface.EVENT_MAX_MULTI_DISTANCE_CHANGE, onMaxMultiDistanceChange);
		}

		override public function notifyRemoved() : void
		{
			super.notifyRemoved();
			SEventPool.removeEventListener(SEvent.RESIZE, onResize);
		}

		private function onResize(e : SEvent) : void
		{
			resize(SShellVariables.gameWidth, SShellVariables.gameHeight);
		}

		private function onMaxMultiDistanceChange(e : SEvent) : void
		{
			mapRightBorder = SMapConfig.rightBorder;
			resize(SShellVariables.gameWidth, SShellVariables.gameHeight);
		}

		public function resize(w : int, h : int) : void
		{
			_halfViewWidth = w / 2;
			_halfViewHeight = h / 2;

			//摄像机可以到达的边界
			_leftBorder = mapLeftBorder + _halfViewWidth;
			_rightBorder = mapRightBorder - _halfViewWidth;
			_topBorder = mapTopBorder + _halfViewHeight;
			_bottomBorder = mapBottomBorder - _halfViewHeight;
		}

		public function setCameraPosition(x : Number, y : Number) : void
		{
			_cameraX = x;
			_cameraY = y;
			if (_sceneRender)
				_sceneRender.updateCamera(_cameraX + _shakeX, _cameraY + _shakeY);
		}

		override public function update() : void
		{
			if (_needShake)
				updateShake();
			if (!_updateCameraEnabled)
				return;
			if (!_focusEnabled)
			{
				_sceneRender.updateCamera(_cameraX + _shakeX, _cameraY + _shakeY);
				return;
			}
			//防止摄相头超出地图限定的范围
			if (_entity.mapX > mapRightBorder)
				_entity.mapX = mapRightBorder;
			if (_entity.mapX < mapLeftBorder)
				_entity.mapX = mapLeftBorder;
			if (_entity.mapY < mapTopBorder)
				_entity.mapY = mapTopBorder;
			if (_entity.mapY > mapBottomBorder)
				_entity.mapY = mapBottomBorder;

			_cameraX = _entity.mapX;
			_cameraY = _entity.mapY;

			_cameraX = _cameraX > _leftBorder ? _cameraX : _leftBorder;
			_cameraX = _cameraX < _rightBorder ? _cameraX : _rightBorder;
			_cameraY = _cameraY > _topBorder ? _cameraY : _topBorder;
			_cameraY = _cameraY < _bottomBorder ? _cameraY : _bottomBorder;

			_sceneRender.updateCamera(_cameraX + _shakeX, _cameraY + _shakeY);
		}

		protected var _shakeCouter : int;
		protected var _shakeAmount : int;
		protected var _shakeDecay : Boolean;
		protected var _shakeTotalAmount : int;
		protected var _radius : int;
		protected var _needShake : Boolean;
		protected var _shakeElapsedtime : int;
		/**
		 * 是否需要翻转
		 */
		protected var _shakeFlip : Boolean;
		private var _shakeDirection : uint;

		public function shakeCamera(amount : int, radius : int, decay : Boolean = true) : void
		{
			if (!SEngineConfig.canShake)
				return;
			_needShake = true;
			_shakeCouter = 0;
			_shakeTotalAmount = _shakeAmount = amount;
			_shakeDecay = decay;
			_shakeFlip = false;
			_radius = radius;

			_shakeDirection = SDirection.NONE;
		}

		/**
		 * 震屏
		 * @param elapsedTime
		 *
		 */
		public function updateShake() : void
		{
			_shakeElapsedtime += elapsedTimes;
			if (_shakeElapsedtime >= 32)
			{
				_shakeElapsedtime = 0;

				var direction : uint = getFlipDirection();
				var radius : Number = (_shakeAmount == _shakeTotalAmount || _shakeAmount == 1) ? _radius * 0.5 : _radius;

				switch (_shakeDirection)
				{
					case SDirection.NORTH:
						_shakeX = 0;
						_shakeY = -radius;
						break;
					case SDirection.SOUTH:
						_shakeX = 0;
						_shakeY = radius;
						break;
					case SDirection.WEST:
						_shakeX = -radius;
						_shakeY = 0;
						break;
					case SDirection.EAST:
						_shakeX = radius;
						_shakeY = 0;
						break;
					case SDirection.WEST_NORTH:
						_shakeX = -radius;
						_shakeY = -radius;
						break;
					case SDirection.EAST_SOUTH:
						_shakeX = radius;
						_shakeY = radius;
						break;
					case SDirection.EAST_NORTH:
						_shakeX = radius;
						_shakeY = -radius;
						break;
					case SDirection.WEST_SOUTH:
						_shakeX = -radius;
						_shakeY = radius;
						break;
				}
				if (_shakeDecay && _shakeAmount < _shakeTotalAmount - 2)
					_radius = _radius * 0.8;
				_shakeAmount -= 1;
				if (_shakeAmount <= 0)
				{
					_shakeFlip = false;
					_shakeX = 0;
					_shakeY = 0;
					_needShake = false;
				}
			}
		}

		private function getFlipDirection() : uint
		{
			if (!_shakeFlip)
			{
				var dirValue : int = int(Math.random() * 8);

				switch (dirValue)
				{
					case 0:
						_shakeDirection = SDirection.SOUTH;
						if (_sceneRender.viewY >= SMapConfig.bottomBorder - SMapConfig.viewHeight)
							_shakeDirection = SDirection.NORTH;
						break;
					case 1:
						_shakeDirection = SDirection.EAST;
						if (_sceneRender.viewX >= SMapConfig.rightBorder - SMapConfig.viewWidth)
							_shakeDirection = SDirection.EAST;
						break;
					case 2:
						_shakeDirection = SDirection.EAST_NORTH;
						if (_sceneRender.viewX >= SMapConfig.rightBorder - SMapConfig.viewWidth && _sceneRender.viewY <= SMapConfig.topBorder)
							_shakeDirection = SDirection.WEST_SOUTH;
						else if (_sceneRender.viewX >= SMapConfig.rightBorder - SMapConfig.viewWidth)
							_shakeDirection = SDirection.WEST_NORTH;
						else if (_sceneRender.viewY <= SMapConfig.topBorder)
							_shakeDirection = SDirection.EAST_SOUTH;
						break;
					case 3:
						_shakeDirection = SDirection.EAST_SOUTH;
						if (_sceneRender.viewX >= SMapConfig.rightBorder - SMapConfig.viewWidth && _sceneRender.viewY >= SMapConfig.bottomBorder - SMapConfig.viewHeight)
							_shakeDirection = SDirection.WEST_NORTH;
						else if (_sceneRender.viewX >= SMapConfig.rightBorder - SMapConfig.viewWidth)
							_shakeDirection = SDirection.WEST_SOUTH;
						else if (_sceneRender.viewY >= SMapConfig.bottomBorder - SMapConfig.viewHeight)
							_shakeDirection = SDirection.EAST_NORTH;
						break;
					case 4:
						_shakeDirection = SDirection.NORTH;
						if (_sceneRender.viewY <= SMapConfig.topBorder)
							_shakeDirection = SDirection.SOUTH;
						break;
					case 5:
						_shakeDirection = SDirection.WEST;
						if (_sceneRender.viewX <= SMapConfig.leftBorder)
							_shakeDirection = SDirection.EAST;
						break;
					case 6:
						_shakeDirection = SDirection.WEST_SOUTH;
						if (_sceneRender.viewX <= SMapConfig.leftBorder && _sceneRender.viewY >= SMapConfig.bottomBorder - SMapConfig.viewHeight)
							_shakeDirection = SDirection.EAST_NORTH;
						else if (_sceneRender.viewX <= SMapConfig.leftBorder)
							_shakeDirection = SDirection.EAST_SOUTH;
						else if (_sceneRender.viewY >= SMapConfig.bottomBorder - SMapConfig.viewHeight)
							_shakeDirection = SDirection.WEST_NORTH;
						break;
					case 7:
						_shakeDirection = SDirection.WEST_NORTH;
						if (_sceneRender.viewX <= SMapConfig.leftBorder && _sceneRender.viewY <= SMapConfig.topBorder)
							_shakeDirection = SDirection.EAST_SOUTH;
						else if (_sceneRender.viewX <= SMapConfig.leftBorder)
							_shakeDirection = SDirection.EAST_NORTH;
						else if (_sceneRender.viewY <= SMapConfig.topBorder)
							_shakeDirection = SDirection.WEST_SOUTH;
						break;
				}
				_shakeFlip = true;
			}
			else
			{
				switch (_shakeDirection)
				{
					case SDirection.SOUTH:
						_shakeDirection = SDirection.NORTH;
						break;
					case SDirection.EAST:
						_shakeDirection = SDirection.WEST;
						break;
					case SDirection.EAST_NORTH:
						_shakeDirection = SDirection.WEST_SOUTH;
						break;
					case SDirection.EAST_SOUTH:
						_shakeDirection = SDirection.WEST_NORTH;
						break;
					case SDirection.NORTH:
						_shakeDirection = SDirection.SOUTH;
						break;
					case SDirection.WEST:
						_shakeDirection = SDirection.EAST;
						break;
					case SDirection.WEST_SOUTH:
						_shakeDirection = SDirection.EAST_NORTH;
						break;
					case SDirection.WEST_NORTH:
						_shakeDirection = SDirection.EAST_SOUTH;
						break;
				}
				_shakeFlip = false;
			}
			return _shakeDirection;
		}

		override public function destroy() : void
		{
			_entity = null;
			_sceneRender = null;
			super.destroy();
		}

		public function get halfViewWidth() : int
		{
			return _halfViewWidth;
		}

		public function get halfViewHeight() : int
		{
			return _halfViewHeight;
		}

		public function set focusEnabled(value : Boolean) : void
		{
			_focusEnabled = value;
		}

		public function set updateCameraEnabled(value : Boolean) : void
		{
			_updateCameraEnabled = value;
		}
	}
}