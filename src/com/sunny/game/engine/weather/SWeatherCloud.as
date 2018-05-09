package com.sunny.game.engine.weather
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 *
	 * <p>
	 * SunnyGame的天气-云
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
	public class SWeatherCloud extends SWeather
	{
		private var _xMoveSpeed : Number;
		private var _yMoveSpeed : Number;

		private var _clound : SCloud;

		private var _isOutScreen : Boolean;

		public function SWeatherCloud(parent : Sprite, viewRect : Rectangle, level : int)
		{
			super(parent, viewRect, level);
			scrollRect = _viewRect;

			_isOutScreen = true;
			randomFrame();
		}

		private function notifyComplelted() : void
		{
			_clound.show();
			if (_xMoveSpeed > 0)
			{
				x = _viewRect.left - _clound.width;
			}
			else if (_xMoveSpeed < 0)
			{
				x = _viewRect.right + Math.random();
			}

			if (_yMoveSpeed > 0)
			{
				y = _viewRect.top - _clound.height;
			}
			else if (_yMoveSpeed < 0)
			{
				y = _viewRect.bottom;
			}
		}

		override public function update() : void
		{
			super.update();
			if (_clound == null || !_clound.isLoaded)
				return;
			x += _xMoveSpeed - _deltaOffsetX;
			y += _yMoveSpeed - _deltaOffsetY;

			if (_xMoveSpeed > 0)
			{
				if (x > _viewRect.right)
				{
					x = _viewRect.left - Math.random() * 50 - _clound.width;
				}
			}
			else if (_xMoveSpeed < 0)
			{
				if (x + _clound.width < _viewRect.left)
				{
					x = _viewRect.right + Math.random() * 50;
				}
			}

			if (_yMoveSpeed > 0)
			{
				if (y > _viewRect.bottom)
				{
					y = _viewRect.top - Math.random() * 50 - _clound.height;
				}
			}
			else if (_yMoveSpeed < 0)
			{
				if (y + _clound.height < _viewRect.top)
				{
					y = _viewRect.bottom + Math.random() * 50;
				}
			}

			if (x > _viewRect.right || x < _viewRect.left - _viewRect.width || y < _viewRect.top - _viewRect.height || y > _viewRect.bottom)
			{
				_isOutScreen = true;
			}
			else
			{
				if (_isOutScreen)
				{
					randomFrame();
					_isOutScreen = false;
				}
			}

			_deltaOffsetX = 0;
			_deltaOffsetY = 0;
		}

		private function randomFrame() : void
		{
			if (!_clound)
				_clound = new SCloud(this, notifyComplelted);
			_xMoveSpeed = -0.5 - Math.random();
			_yMoveSpeed = -0.3 - Math.random();
			_clound.frame = int(Math.random() * 3) + 1;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_clound)
			{
				_clound.destroy();
				_clound = null;
			}
			super.destroy();
		}
	}
}