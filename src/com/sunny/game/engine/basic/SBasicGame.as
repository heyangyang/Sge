package com.sunny.game.engine.basic
{
	import com.sunny.game.engine.core.SInjector;
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.operation.SSoundOper;
	import com.sunny.game.engine.transition.tween.STween;
	import com.sunny.game.engine.transition.tween.plugins.SSoundTransformPlugin;
	import com.sunny.game.engine.transition.tween.plugins.STweenPlugin;
	import com.sunny.game.engine.ui.manager.STipsManager;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个2D基础游戏基类
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
	public class SBasicGame extends SObject implements SIGame
	{
		public function SBasicGame()
		{
			super();
			SInjector.mapObject("STween", STween);
			SInjector.mapObject("STipsManager", STipsManager);
			SInjector.mapObject("SSoundOper", SSoundOper);

			STweenPlugin.activate([SSoundTransformPlugin]);
		}

		public function initial() : void
		{
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "游戏初始化...");
		}

		public function ready() : void
		{
		}

		public function start() : void
		{
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "游戏开始...");
		}

		public function pause() : void
		{
			// TODO Auto Generated method stub

		}

		public function stop() : void
		{
			// TODO Auto Generated method stub

		}

		public function update() : void
		{
			// TODO Auto Generated method stub

		}
	}
}