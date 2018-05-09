package com.sunny.game.engine.basic
{
	import com.sunny.game.engine.core.SGlobalConstants;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.core.SUpdatable;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.events.SMouseEvent;
	import com.sunny.game.engine.manager.SKeyboardManager;
	import com.sunny.game.engine.manager.SSharedDataManager;
	import com.sunny.game.engine.manager.SUpdatableManager;
	import com.sunny.game.engine.net.SNetManager;
	import com.sunny.game.engine.utils.SWebUtil;
	import com.sunny.game.engine.utils.core.STimeControl;
	import com.sunny.game.engine.utils.swffit.SSwfFit;
	import com.sunny.game.engine.utils.swffit.SSwfFitEvent;

	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 *
	 * <p>
	 * SunnyGame的一个2D标准启动类
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
	public class SStandardStartup extends SUpdatable implements SIStartup
	{
		protected var _game : SIGame;
		private var _menu : ContextMenu;
		private var _isResizing : Boolean = false;

		public function SStandardStartup(gameClass : Class)
		{
			super();
			_game = new(gameClass)();
			if (_game == null)
				throw new Error("Invalid game class: " + gameClass);

			STimeControl.setTimeOut(onStageResizeTimerComplete, 200);

			_game.initial();
			initialize();
		}

		protected function initialize() : void
		{
			ready();
		}

		protected function ready() : void
		{
			initContextMenu();

			if (Capabilities.hasIME)
				IME.enabled = false;
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "标准启动初始化...");

			if (SShellVariables.isWeb())
			{
				if (SShellVariables.indexTemplateVersion != SGlobalConstants.VERSION)
				{
					SDebug.showFatalError("当前程序与页面模板版本不兼容(" + SGlobalConstants.VERSION + "&" + SShellVariables.indexTemplateVersion + ")，请尝试：1、构建项目；2、清空缓存；3、咨询程序猿哥哥。");
					return;
				}
			}	

			SShellVariables.sceneContainer.contextMenu = SShellVariables.uiContainer.contextMenu = SShellVariables.msgContainer.contextMenu = SShellVariables.popUpContainer.contextMenu = _menu;

			SSharedDataManager.getInstance().initialize(SShellVariables.applicationID);
			if (!SShellVariables.isDesktop()&& !SShellVariables.isDebug)
			{
				SWebUtil.addOnBeforeUnloadListener(onApplicationClose);
				SWebUtil.addOnUnloadListener(forceDisconnectSocket);
				SWebUtil.browserPreventDefault();
				SWebUtil.addCallback("logCallback", logCallback);
			}
			_game.ready();
			_game.start();

			onStageResize(new Event(Event.INIT));
		}

		private function onStageResizeTimerComplete() : void
		{
			_isResizing = false;
			SEvent.dispatchEvent(SEvent.RESIZE);
		}

		private function initContextMenu() : void
		{
			_menu = new ContextMenu();
			_menu.builtInItems.forwardAndBack = false;
			_menu.builtInItems.loop = false;
			_menu.builtInItems.play = false;
			_menu.builtInItems.print = false;
			_menu.builtInItems.quality = false;
			_menu.builtInItems.rewind = false;
			_menu.builtInItems.save = false;
			_menu.builtInItems.zoom = false;
			_menu.hideBuiltInItems();

			if (_menu.customItems)
			{
				var item : ContextMenuItem = new ContextMenuItem(SShellVariables.applicationName + " " + SShellVariables.applicationVersion);
				_menu.customItems.push(item);
			}

			_menu.addEventListener(ContextMenuEvent.MENU_SELECT, onMenuSelect);
		}

		private static function addEvent(item : EventDispatcher, type : String, listener : Function) : void
		{
			item.addEventListener(type, listener, false, 0, true);
		}

		private static function removeEvent(item : EventDispatcher, type : String, listener : Function) : void
		{
			item.removeEventListener(type, listener);
		}

		private function onMenuSelect(e : ContextMenuEvent) : void
		{
			SMouseEvent.dispatchEvent(SMouseEvent.RIGHT_CLICK);
		}

		public function start() : void
		{
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "标准启动开始...");

			SUpdatableManager.getInstance().start();
			SUpdatableManager.getInstance().register(this, SUpdatableManager.PRIORITY_LAYER_HIGH);
			SUpdatableManager.getInstance().register(SKeyboardManager.getInstance(), SUpdatableManager.PRIORITY_LAYER_HIGH);
			startStageListen();
		}

		/**
		 * 页面关闭时弹出提醒
		 * @param allow
		 * @return
		 */
		protected function onApplicationClose() : String
		{
			return "确定退出游戏？";
		}

		/**
		 * 页面刷新或关闭时强制断开连接
		 */
		private function forceDisconnectSocket() : void
		{
			SNetManager.getInstance().disconnect(SNetManager.DIS_CONNECT_TYPE_WEB);
		}

		private function logCallback(content : String) : void
		{
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "记录日志:" + content);
		}

		private function startStageListen() : void
		{
			SShellVariables.nativeStage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			SShellVariables.nativeStage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave, false, 0, true);

			if (!SShellVariables.isDesktop())
			{
				//add the custom swffit event "change" to the swffit object
				SSwfFit.addEventListener(SSwfFitEvent.CHANGE, updateText);
				//add the custom swffit event "startFit" to the swffit object
				SSwfFit.addEventListener(SSwfFitEvent.START_FIT, traceEvent);
				//add the custom swffit event "stopFit" to the swffit object
				SSwfFit.addEventListener(SSwfFitEvent.STOP_FIT, traceEvent);

				//Initial swffit configuration
				SSwfFit.fit(SSwfFit.target, SShellVariables.gameMinWidth, SShellVariables.gameMinHeight, SShellVariables.gameMaxWidth, SShellVariables.gameMaxHeight, false, false);
			}
		}

		/**
		 * Trace the SWFFitEvent type
		 */
		private function traceEvent(e : SSwfFitEvent) : void
		{
			trace(e.type);
		}

		/**
		 * Update the textField values (only works on browser)
		 */
		private function updateText(e : SSwfFitEvent) : void
		{
			traceEvent(e);
			// get the swffit properties values (those values are returned from the javascript and only work inside the html file)
			var t : String = SSwfFit.target;
			var mw : int = SSwfFit.minWid;
			var mh : int = SSwfFit.minHei;
			var xw : int = SSwfFit.maxWid;
			var xh : int = SSwfFit.maxHei;
			var hc : Boolean = SSwfFit.hCenter;
			var vc : Boolean = SSwfFit.vCenter;
			//change the properties textfield text
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "SWFFit.target = " + t + "; SWFFit.minWid = " + mw + "; SWFFit.minHei = " + mh + "; SWFFit.maxWid = " + xw + "; SWFFit.maxHei = " + xh + "; SWFFit.hCenter = " + hc + "; SWFFit.vCenter = " + vc + ";");
		}

		protected function onStageResize(event : Event) : void
		{
			STimeControl.setTimeOut(onStageResizeTimerComplete, 200);
			_isResizing = true;
			event.stopImmediatePropagation();
			if (SShellVariables.nativeStage.stageWidth <= 0 || SShellVariables.nativeStage.stageHeight <= 0)
				return;
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, '监听到屏幕变化:', SShellVariables.nativeStage.stageWidth, SShellVariables.nativeStage.stageHeight, 'ui层大小 :', SShellVariables.uiContainer.width, SShellVariables.uiContainer.height);

			var stageWidth : int = Math.max(SShellVariables.nativeStage.stageWidth, SShellVariables.gameMinWidth);
			stageWidth = Math.min(stageWidth, SShellVariables.gameMaxWidth);
			var stageHeight : int = Math.max(SShellVariables.nativeStage.stageHeight, SShellVariables.gameMinHeight);
			stageHeight = Math.min(stageHeight, SShellVariables.gameMaxHeight);

			if (SShellVariables.gameWidth == stageWidth && SShellVariables.gameHeight == stageHeight)
				return;

			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "屏幕大小变化：", stageWidth, stageHeight);

			SShellVariables.resize(stageWidth, stageHeight);
		}

		private function onMouseLeave(event : Event) : void
		{
			event.stopImmediatePropagation();
			SEvent.dispatchEvent(SEvent.MOUSE_LEAVE);
		}

		public function pause() : void
		{
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "暂停2D游戏...");
			_game.pause();
		}

		public function stop() : void
		{
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "停止2D游戏...");
			_game.stop();
		}

		public function present() : void
		{
		}

		override public function update() : void
		{
			_game.update();
			if (!_isResizing)
				present();
			super.update();
		}

		public function stageCenter() : void
		{
			if (SShellVariables.nativeStage.hasOwnProperty("nativeWindow"))
			{
				var screenWidth : Number = Capabilities.screenResolutionX;
				var screenHeight : Number = Capabilities.screenResolutionY;
				SShellVariables.nativeStage["nativeWindow"].x = screenWidth / 2 - SShellVariables.nativeStage.stageWidth / 2;
				SShellVariables.nativeStage["nativeWindow"].y = screenHeight / 2 - SShellVariables.nativeStage.stageHeight / 2;
			}
		}

		public function stageSize(width : int, height : int) : void
		{
			if (SShellVariables.nativeStage.hasOwnProperty("nativeWindow"))
			{
				SShellVariables.nativeStage["nativeWindow"].width = width;
				SShellVariables.nativeStage["nativeWindow"].height = height;
			}
		}

		public function stageMaximize() : void
		{
			if (SShellVariables.nativeStage.hasOwnProperty("nativeWindow"))
			{
				SShellVariables.nativeStage["nativeWindow"].maximize();
			}
		}

		public function get game() : SIGame
		{
			return _game;
		}

		override public function dispose() : void
		{
			SShellVariables.nativeStage.removeEventListener(Event.RESIZE, onStageResize, false);
			SShellVariables.nativeStage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave, false);
			super.dispose();
		}
	}
}