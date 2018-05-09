package com.sunny.game.engine.weather
{
	import com.sunny.game.engine.cfg.SEngineConfig;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.core.SUpdatable;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.manager.SUpdatableManager;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的天气管理器
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
	public class SWeatherManager extends SUpdatable
	{
		private static var _instance : SWeatherManager;

		private var _weathers : Dictionary = new Dictionary();
		private var _weatherTypes : Array;

		private var _curWeathers : Array = [];

		public var isRuning : Boolean;
		private var _testingTime : int;
		private var fps_times : int;

		public static function getInstance() : SWeatherManager
		{
			if (_instance == null)
				_instance = new SWeatherManager();
			return _instance;
		}

		public function SWeatherManager()
		{
			super();
			if (_instance)
				return;
			isRuning = false;
			_weatherTypes = [];
		}

		private function addWeather(weatherType : int, level : int = 1) : SIWeather
		{
			var weather : SIWeather = _weathers[weatherType];
			if (weather == null)
			{
				switch (weatherType)
				{
					case SWeatherType.RAIN:
						weather = new SWeatherRain(SShellVariables.sceneContainer, new Rectangle(0, 0, SShellVariables.nativeStage.stageWidth, SShellVariables.nativeStage.stageHeight), level, 'left');
						break;
					case SWeatherType.SNOW:
						weather = new SWeatherSnowStorm(SShellVariables.sceneContainer, new Rectangle(0, 0, SShellVariables.nativeStage.stageWidth, SShellVariables.nativeStage.stageHeight), level);
						break;
					case SWeatherType.FOG:
						weather = new SFog(SShellVariables.sceneContainer, new Rectangle(0, 0, SShellVariables.nativeStage.stageWidth, SShellVariables.nativeStage.stageHeight), level, false);
						break;
					case SWeatherType.CLOUD:
						weather = new SWeatherCloud(SShellVariables.sceneContainer, new Rectangle(0, 0, SShellVariables.nativeStage.stageWidth, SShellVariables.nativeStage.stageHeight), level);
						break;
					case SWeatherType.LIGHTING:

						break;
				}
				_weathers[weatherType] = weather;
			}
			if (weather == null)
				return null;

			if (weather.level != level)
			{
				weather.level = level;
			}
			return weather;
		}

		/**
		 * @param weatherDesc 0，1，2，3分别对应天气类型，服务器发送数据只是天气等级
		 */
		public function setWeatherDesc(weatherDesc : String) : void
		{
			if (!isRegistered)
				return;
			var weatherNames : Array = weatherDesc.split(",");
			for each (var name : String in weatherNames)
			{
				switch (name)
				{
					case "rain":
						setWeather(SWeatherType.RAIN, 1);
						break;
					case "snow":
						setWeather(SWeatherType.SNOW, 1);
						break;
					case "fog":
						setWeather(SWeatherType.FOG);
						break;
					case "cloud":
						setWeather(SWeatherType.CLOUD);
						break;
				}
			}
		}

		public function setWeather(weatherType : int, level : int = 1) : void
		{
			if (!isRegistered)
				return;
			var index : int;
			if (level > 0)
			{
				index = _weatherTypes.indexOf(weatherType);
				if (index == -1)
					_weatherTypes.push(weatherType);
				startWeather(weatherType, level);
			}
			else
			{
				index = _weatherTypes.indexOf(weatherType);
				if (index != -1)
					_weatherTypes.splice(index, 1);
				stopWeather(weatherType);
			}
		}

		private function startWeather(weatherType : int, level : int = 1) : SIWeather
		{
			var weather : SIWeather = addWeather(weatherType, level);
			SDebug.infoPrint(this, "开始天气:" + weather.name + ":" + weather.level + "级");
			var index : int = _curWeathers.indexOf(weather);
			if (index == -1)
			{
				_curWeathers.push(weather);
			}
			if (isRuning && !weather.isRunning)
				weather.start();
			return weather;
		}

		private function resumeWeather(weatherType : int, level : int = 1) : void
		{
			var weather : SIWeather = _weathers[weatherType];
			if (weather == null)
				return;
			SDebug.infoPrint(this, "恢复天气:" + weather.name);
			if (!weather.isRunning)
				weather.start();
		}

		private function stopWeather(weatherType : int) : void
		{
			var weather : SIWeather = _weathers[weatherType];
			if (weather == null)
				return;
			SDebug.infoPrint(this, "停止天气:" + weather.name);
			if (weather.isRunning)
				weather.stop();
		}

		private function removeWeather(weatherType : int) : void
		{
			var weather : SIWeather = _weathers[weatherType];
			if (weather)
			{
				SDebug.infoPrint(this, "移除天气:" + weather.name);
				var index : int = _curWeathers.indexOf(weather);
				if (index != -1)
					_curWeathers.splice(index, 1);
				if (weather.isRunning)
					weather.stop();
				weather.destroy();
				_weathers[weatherType] = null;
				delete _weathers[weatherType];
			}
		}

		public function scroll(screenOffsetX : Number, screenOffsetY : Number) : void
		{
			if (!isRuning)
				return;
			for each (var weather : SIWeather in _curWeathers)
			{
				weather.scroll(screenOffsetX, screenOffsetY);
			}
		}

		public function start() : void
		{
			if (!SEngineConfig.showWeather)
				return;
			register(SUpdatableManager.PRIORITY_LAYER_LOW);
			_testingTime = 0;
			startWeathers();
		}

		public function stop() : void
		{
			removeWeathers();
			unregister();
		}

		public function pauseWeathers() : void
		{
			if (!isRuning)
				return;
			isRuning = false;
			for each (var weatherType : int in _weatherTypes)
			{
				stopWeather(weatherType);
			}
		}

		private function removeWeathers() : void
		{
			isRuning = false;
			for each (var weatherType : int in _weatherTypes)
			{
				removeWeather(weatherType);
			}
			_weatherTypes.length = 0;
		}

		private function startWeathers() : void
		{
			if (isRuning)
				return;
			isRuning = true;
			for each (var weatherType : int in _weatherTypes)
			{
				startWeather(weatherType);
			}
		}

		public function resumeWeathers() : void
		{
			if (isRuning)
				return;
			isRuning = true;
			for each (var weatherType : int in _weatherTypes)
			{
				resumeWeather(weatherType);
			}
		}

		public function resize(w : int, h : int) : void
		{
			if (!isRuning)
				return;
			for each (var weather : SWeather in _weathers)
			{
				weather.resize(w, h);
			}
		}

		override public function dispose() : void
		{
			//removeCurrentWeathers();
			super.dispose();
		}

		override public function update() : void
		{
			_testingTime += elapsedTimes;
			fps_times += elapsedTimes;
			fps_times *= .5;
			if (_testingTime > 5000) //稳定5秒开始
			{
				if (1000 / fps_times < 30) //30帧以内暂停 
				{
					if (isRuning)
						pauseWeathers();
				}
				else
				{
					if (!isRuning)
						resumeWeathers();
				}
				fps_times = elapsedTimes;
				_testingTime = 0;
			}
		}
	}
}