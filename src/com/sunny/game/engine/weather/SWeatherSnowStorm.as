package com.sunny.game.engine.weather
{
	import com.sunny.game.engine.lang.memory.SObjectPool;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 *
	 * <p>
	 * SunnyGame的天气-暴风雪
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
	public class SWeatherSnowStorm extends SWeather
	{
		private var snowFlakes : Vector.<SSnowflake> = new Vector.<SSnowflake>();
		private var numFlakes : uint = 100;

		public var wind : Number = 1;

		private var count : int;

		public function SWeatherSnowStorm(parent : Sprite, viewRect : Rectangle, level : int)
		{
			super(parent, viewRect, level);
			// first make an array to put all our snowflakes in
			name = "下雪";
		}

		override public function set level(value : int) : void
		{
			super.level = value;
			switch (level)
			{
				case 1:
					numFlakes = 100;
					wind = -1;
					break;
				case 2:
					numFlakes = 150;
					wind = -1;
					break;
				case 3:
					numFlakes = 300;
					wind = -3;
					break;
			}

			resetProperties(numFlakes, wind);
		}

		public function resetProperties(maxNum : int, wind : Number) : void
		{
			// and decide the maxium number of flakes we want
			numFlakes = maxNum;

			// now calculate the wind factor by looking at the x position 
			// of the mouse relative to the centre of the screen
			//转换为每毫秒移动的速度 ,以下大致转换为在30帧频的情况下测试的速度
			this.wind = wind / 30;

			var len : int = snowFlakes.length;
			if (len > 0)
			{
				var snowFlake : SSnowflake;
				if (len > numFlakes)
				{
					for (var i : int = len - 1; i >= numFlakes; i--)
					{
						snowFlake = snowFlakes[i];
						SObjectPool.recycle(snowFlake, SSnowflake);
						snowFlakes.splice(i, 1);
					}
					count = numFlakes;
				}
				for each (var snowflake : SSnowflake in snowFlakes)
				{
					snowflake.resetProperties();
				}
			}
		}

		override protected function validuateChange() : void
		{
			super.validuateChange();
			for each (var snowflake : SSnowflake in snowFlakes)
			{
				snowflake.setViewRect(_viewRect);
			}
		}

		override public function update() : void
		{
			super.update();
			var snowflake : SSnowflake;

			// if we don't have the maximum number of flakes... 
			if (count < numFlakes)
			{
				snowflake = SObjectPool.getObject(SSnowflake);
				if (snowflake)
				{
					snowflake.resetProperties();
				}
				else
				{
					// then make a new one!
					snowflake = new SSnowflake(this, _viewRect);
				}
				// add it to the array of snowflakes
				snowFlakes.push(snowflake);
				snowflake.show();

				count++;
			}

			var windFactor : Number = wind * elapsedTimes;
			// now loop through every snowflake
			for each (snowflake in snowFlakes)
			{
				snowflake.update(windFactor, _deltaOffsetX, _deltaOffsetY, elapsedTimes);
			}

			_deltaOffsetX = 0;
			_deltaOffsetY = 0;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (snowFlakes)
			{
				for each (var snowflake : SSnowflake in snowFlakes)
				{
					snowflake.hide();
				}
				snowFlakes.length = 0;
				snowFlakes = null;
			}
			SObjectPool.dispose(SSnowflake);
			super.destroy();
		}
	}
}