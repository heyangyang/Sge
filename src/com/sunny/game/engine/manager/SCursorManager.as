package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.ui.SNativeCursor;
	import com.sunny.game.rpg.resource.SCursorResourceParser;

	/**
	 *
	 * <p>
	 * SunnyGame的光标处理器
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
	public class SCursorManager extends SNativeCursor
	{
		protected var _resourceParser : SCursorResourceParser;

		public function SCursorManager()
		{
			super(SShellVariables.nativeStage);
		}

		public function init() : void
		{
			_resourceParser = new SCursorResourceParser("cursor");
			_resourceParser.onComplete(onComplete).load();
		}

		private function onComplete(res : SCursorResourceParser) : void
		{
			registerCursors();
			_resourceParser.release();
			_resourceParser = null;
		}

		protected function registerCursors() : void
		{
		}
	}
}