package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.core.SIUpdatable;
	import com.sunny.game.engine.core.SUpdatable;
	import com.sunny.game.engine.manager.SUpdatableManager;

	/**
	 * 每秒刷新一次
	 * @author Administrator
	 *
	 */
	public class SSecondTicker extends SUpdatable
	{
		private static var _instance : SSecondTicker;

		public static function getInstance() : SSecondTicker
		{
			if (_instance == null)
				_instance = new SSecondTicker();
			return _instance;
		}

		private var delay : int;
		private var list : Vector.<SIUpdatable> = new Vector.<SIUpdatable>();

		public function SSecondTicker()
		{
			super();
		}

		public function addTick(updatable : SIUpdatable) : void
		{
			if (list.indexOf(updatable) == -1)
			{
				list.push(updatable);
			}

			if (list.length > 0)
			{
				delay = 0;
				register(SUpdatableManager.PRIORITY_LAYER_LOW);
			}
		}

		public function removeTick(updatable : SIUpdatable) : void
		{
			var index : int = list.indexOf(updatable);
			if (index != -1)
			{
				list.splice(index, 1);
			}
			if (list.length == 0)
			{
				unregister();
			}
		}

		override public function update() : void
		{
			delay += elapsedTimes;
			if (delay >= 1000)
			{
				delay -= 1000;
				var updatable : SIUpdatable;
				for each (updatable in list)
				{
					updatable && updatable.update();
				}
			}
		}
	}
}