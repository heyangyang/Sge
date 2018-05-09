package com.sunny.game.engine.component.camera
{
	import com.sunny.game.engine.core.SMapConfig;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.lang.STime;

	/**
	 *
	 * <p>
	 * SunnyGame的边界摄像机组件，在一个边框内移动，到达边框时再触发滚屏
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
	public class SBorderCameraComponent extends SCameraComponent
	{
		private var _hScrollMargin : int = 100;
		private var _vScrollMargin : int = 100;

		private var _currSlowActionRatioX : Number;
		private var _currSlowActionRatioY : Number;
		private var _entityLastMapX : int = 0;
		private var _entityLastMapY : int = 0;

		public static var slowActionRatio : Number = 0.01;

		public function SBorderCameraComponent()
		{
			super();
		}

		override public function resize(w : int, h : int) : void
		{
			_hScrollMargin = SShellVariables.hScrollMargin;
			_vScrollMargin = SShellVariables.vScrollMargin;
			_vScrollMargin = _hScrollMargin = 0;
			_halfViewWidth = w / 2;
			_halfViewHeight = h / 2;

			//摄像机可以到达的边界
			_leftBorder = mapLeftBorder + _halfViewWidth;
			_rightBorder = mapRightBorder - _halfViewWidth;
			_topBorder = mapTopBorder + _halfViewHeight;
			_bottomBorder = mapBottomBorder - _halfViewHeight;

			if (_cameraX < _halfViewWidth)
			{
				_cameraX = _halfViewWidth;
			}
			if (_cameraY < _halfViewHeight)
			{
				_cameraY = _halfViewHeight;
			}

			_cameraX = Math.max(_cameraX, _leftBorder);
			_cameraX = Math.min(_cameraX, _rightBorder);
			_cameraY = Math.max(_cameraY, _topBorder);
			_cameraY = Math.min(_cameraY, _bottomBorder);
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

			//摄像机与role的距离
			var crDistX : int = _entity.mapX - _cameraX;
			var crDistY : int = _entity.mapY - _cameraY;
			var mapDx : int = _entity.mapX - _entityLastMapX;
			if (mapDx < 0)
				mapDx = -mapDx;
			var mapDy : int = _entity.mapY - _entityLastMapY;
			if (mapDy < 0)
				mapDy = -mapDy;

			if (mapDx > _hScrollMargin)
			{
				_currSlowActionRatioX = 1;
			}
			else if (mapDx > 0)
			{
				_currSlowActionRatioX = slowActionRatio * mapDx;
				if (_currSlowActionRatioX > 1)
					_currSlowActionRatioX = 1;
			}

			if (mapDy > _vScrollMargin)
			{
				_currSlowActionRatioY = 1;
			}
			else if (mapDy > 0)
			{
				_currSlowActionRatioY = slowActionRatio * mapDy;
				if (_currSlowActionRatioY > 1)
					_currSlowActionRatioY = 1;
			}

			if (crDistX < 0)
			{
				if (-crDistX > _halfViewWidth)
					_cameraX += (_entity.mapX - _cameraX) * _currSlowActionRatioX;
				else if (-crDistX > _hScrollMargin)
					_cameraX += (_entity.mapX + _hScrollMargin - _cameraX) * _currSlowActionRatioX;
			}
			else
			{
				if (crDistX > _halfViewWidth)
					_cameraX += (_entity.mapX - _cameraX) * _currSlowActionRatioX;
				else if (crDistX > _hScrollMargin)
					_cameraX += (_entity.mapX - _hScrollMargin - _cameraX) * _currSlowActionRatioX;
			}

			if (crDistY < 0)
			{
				if (-crDistY > _halfViewHeight)
					_cameraY += (_entity.mapY - _cameraY) * _currSlowActionRatioY;
				else if (-crDistY > _vScrollMargin)
					_cameraY += (_entity.mapY + _vScrollMargin - _cameraY) * _currSlowActionRatioY;
			}
			else
			{
				if (crDistY > _halfViewHeight)
					_cameraY += (_entity.mapY - _cameraY) * _currSlowActionRatioY;
				else if (crDistY > _vScrollMargin)
					_cameraY += (_entity.mapY - _vScrollMargin - _cameraY) * _currSlowActionRatioY;
			}

			if (_cameraX < _leftBorder)
				_cameraX = _leftBorder;
			if (_cameraX > _rightBorder)
				_cameraX = _rightBorder;
			if (_cameraY < _topBorder)
				_cameraY = _topBorder;
			if (_cameraY > _bottomBorder)
				_cameraY = _bottomBorder;

			_cameraX = Math.max(_cameraX, _halfViewWidth);
			_cameraX = Math.min(_cameraX, SMapConfig.validMapWidth - _halfViewWidth);
			_cameraY = Math.max(_cameraY, _halfViewHeight);
			_cameraY = Math.min(_cameraY, SMapConfig.validMapHeight - _halfViewHeight);

			_sceneRender.updateCamera(_cameraX + _shakeX, _cameraY + _shakeY);
			_entityLastMapX = _entity.mapX;
			_entityLastMapY = _entity.mapY;
		}
	}
}