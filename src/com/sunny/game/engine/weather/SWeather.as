package com.sunny.game.engine.weather
{
	import com.sunny.game.engine.particle.SBasicParticleGenerator;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 *
	 * <p>
	 * SunnyGame的天气
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
	public class SWeather extends SBasicParticleGenerator implements SIWeather
	{
		protected var _deltaOffsetX : Number = 0;
		protected var _deltaOffsetY : Number = 0;
		protected var _screenOffsetX : Number = 0;
		protected var _screenOffsetY : Number = 0;
		protected var _lastScreenOffsetX : Number = 0;
		protected var _lastScreenOffsetY : Number = 0;

		protected var _level : int = 0;

		protected var _maxDelta : int = 50;

//		private var curFrameUpdatable : Boolean;

		public function SWeather(parent : Sprite, viewRect : Rectangle, level : int)
		{
			this.level = level;
			super(parent, viewRect);
			_batchEnable = false;
		}

//		
//		override public function checkUpdatable(elapsedTime:int):Boolean
//		{
//			curFrameUpdatable = super.checkUpdatable(elapsedTime);
//			return curFrameUpdatable;
//		}

		public function scroll(screenOffsetX : Number, screenOffsetY : Number) : void
		{
//			if(!curFrameUpdatable)return;
			if (!isRunning)
				return;
			_screenOffsetX = screenOffsetX;
			_screenOffsetY = screenOffsetY;
			_deltaOffsetX = screenOffsetX - _lastScreenOffsetX;
			_deltaOffsetY = screenOffsetY - _lastScreenOffsetY;
			_deltaOffsetX = Math.abs(_deltaOffsetX) >= _maxDelta ? 0 : _deltaOffsetX;
			_deltaOffsetY = Math.abs(_deltaOffsetY) >= _maxDelta ? 0 : _deltaOffsetY;

			_lastScreenOffsetX = screenOffsetX;
			_lastScreenOffsetY = screenOffsetY;
		}

		override public function stop() : void
		{
			if (_isDisposed)
				return;
			if (!isRunning)
				return;
			super.stop();

			_deltaOffsetX = 0;
			_deltaOffsetY = 0;
			_lastScreenOffsetX = 0;
			_lastScreenOffsetY = 0;
		}

		public function get level() : int
		{
			return _level;
		}

		public function set level(value : int) : void
		{
			_level = value;
		}
	}
}