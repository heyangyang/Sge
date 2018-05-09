package com.sunny.game.engine.core
{
	import com.sunny.game.engine.basic.SBasicGame;
	import com.sunny.game.engine.basic.SIStartup;
	import com.sunny.game.engine.basic.SStandardStartup;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.utils.SSystemUtil;
	
	import flash.events.Event;

	/**
	 *
	 * <p>
	 * SunnyGame的一个基础引擎
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
	public class SBasicEngine extends SAbstractEngine
	{
		private static var _engineInstance : SBasicEngine;

		public static function get engineInstance() : SBasicEngine
		{
			return _engineInstance;
		}

		protected var _startup : SIStartup;
		private var class_startup : Class;
		private var class_game : Class;

		/**
		 * 是否初始化
		 */
		public var initialized : Boolean = false;

		public function SBasicEngine(startup : Class = null, game : Class = null)
		{
			class_startup = !startup ? SStandardStartup : startup;
			class_game = !game ? SBasicGame : game;
			_engineInstance = this;
			super();
		}

		override protected function addToStage() : void
		{
			initialize();
		}

		private function resizeHandler(event : Event) : void
		{
			if (stage.stageWidth > 0 && stage.stageHeight > 0)
			{
				stage.removeEventListener(Event.RESIZE, resizeHandler);
				initialize();
			}
		}

		protected function initialize() : void
		{
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "游戏引擎初始化...");
			SSystemUtil.initialize();
			this.initialized = true;
			_startup = new class_startup(class_game);
			if (_startup)
				_startup.start();
		}

		public function get startup() : SIStartup
		{
			return _startup;
		}

		override public function destroy() : void
		{
			super.destroy();
			_startup = null;
			class_startup = null;
			class_game = null;
		}

	}
}