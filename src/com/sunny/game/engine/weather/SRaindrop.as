package com.sunny.game.engine.weather
{
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.parser.SPakResourceParser;
	import com.sunny.game.engine.particle.SParticle;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 *
	 * <p>
	 * SunnyGame的雨滴
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
	public class SRaindrop extends SParticle
	{
		private var _offset : int = 50;
		private var _fallSpeed : Number;
		private var _windSpeed : Number;
		private var _dir : String = 'left';

		private var _screenOffsetX : int;
		private var _screenOffsetY : int;

		private var _viewRect : Rectangle;

		private var _bottom : int;
		private var _zoomRate : Number = 1;

		protected var _resourceParser : SPakResourceParser;

		public function SRaindrop(parent : Sprite, fallSpeed : int, windSpeed : int, dir : String, viewRect : Rectangle)
		{
			super(parent);
			resetProperties(fallSpeed, windSpeed, dir, viewRect);
			_resourceParser = SReferenceManager.getInstance().createParticleParser("rain");
			if (_resourceParser.isLoaded)
			{
				notifyComplelted(_resourceParser);
			}
			else
			{
				_resourceParser.onComplete(notifyComplelted).load();
			}
		}

		private function notifyComplelted(res : SPakResourceParser) : void
		{
			this.bitmapData = res.getBitmapDataByFrame(1);
		}

		public function resetProperties(fallSpeed : Number, windSpeed : Number, dir : String, viewRect : Rectangle) : void
		{
			_fallSpeed = fallSpeed / 30;
			_windSpeed = windSpeed / 30;

			_dir = dir;

			setViewRect(viewRect);

			if (_dir == 'right')
			{
				this.rotation = -45;
				_offset *= -1;
			}

			var z : Number = (Math.random() * 600) - 250;
			_zoomRate = calculatePerspectiveSize(z);
			_zoomRate = _zoomRate > 1 ? 1 : _zoomRate;
			_zoomRate = _zoomRate < 0.6 ? 0.6 : _zoomRate;
			this.scaleX = this.scaleY = _zoomRate;

			_bottom = _zoomRate * _viewRect.bottom;
//			if(z < -150)
//			{
//				var bluramount : Number = z + 150;
//				bluramount /= -100;
//				bluramount = (bluramount * 20) + 2;
//				_drop.filters = [new BlurFilter(bluramount ,bluramount ,2)];
//			}
//			else
//			{
//				_drop.filters = [new BlurFilter(2 ,2 ,2)];
//			}
		}

		public function setViewRect(viewRect : Rectangle) : void
		{
			_viewRect = viewRect;
			this.x = _viewRect.x + Math.random() * (_viewRect.width + _offset);
			this.y = _viewRect.y + Math.random() * _viewRect.height;
		}

		public function update(offsetX : Number, offsetY : Number, deltaTime : int) : void
		{
			if (_dir == 'left')
			{
				moveLeft(offsetX, offsetY, deltaTime);
			}
			else if (_dir == 'right')
			{
				moveRight(offsetX, offsetY, deltaTime);
			}
		}

		public function moveLeft(offsetX : Number, offsetY : Number, deltaTime : int) : void
		{
			this.x += _windSpeed * deltaTime;
			this.y += Math.random() * (_fallSpeed * deltaTime) - offsetY;

			this.x -= offsetX;

			if (this.y > _bottom)
			{
				this.x = _viewRect.x + Math.random() * (_viewRect.width + (_offset * 2));
				this.y = _viewRect.y + this.y % _bottom;
			}
			if (this.x < _viewRect.left)
				this.x = _viewRect.right;
		}

		public function moveRight(offsetX : Number, offsetY : Number, deltaTime : int) : void
		{
			this.x -= _windSpeed * deltaTime;
			this.y += Math.random() * (_fallSpeed * deltaTime) - offsetY;

			this.x -= offsetX;

			if (this.y > _bottom)
			{
				this.x = _viewRect.left + Math.random() * (_viewRect.width - _offset * 2) + _offset * 2; //Check
				this.y = _viewRect.top + this.y % _bottom;
			}
			if (this.x > _viewRect.right)
				this.x = _viewRect.left;
		}

		override public function free() : void
		{
			super.free();
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_resourceParser)
			{
				_resourceParser.removeOnComplete(notifyComplelted);
				_resourceParser.release();
				_resourceParser = null;
			}
			super.destroy();
		}

		public function calculatePerspectiveSize(z : Number) : Number
		{
			var fov : Number = 300;
			return fov / (z + fov);
		}
	}
}