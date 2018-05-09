package com.sunny.game.engine.core
{
	import com.sunny.game.engine.display.SSprite;
	import com.sunny.game.engine.manager.SPopUpManager;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.render.base.SNormalContainer;

	import flash.display.InteractiveObject;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个核心变量类
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
	public class SShellVariables
	{
		public static var getTimer : int;

		public static var applicationID : String = "ShanHaiFuMoLu";
		public static var applicationName : String = "ShanHaiFuMoLu";
		/**
		 * 是否主线程
		 */
		public static var isPrimordial : Boolean = false;
		public static var applicationVersion : String = "4.6.0";

		/**
		 * 自动完成任务等待时间
		 */
		public static var autoFinishTaskTime : int = 10000;
		/**
		 * 是否调试
		 */
		public static var isDebug : Boolean = false;
		/**
		 * 图标地址 
		 */
		public static var favicon : String;
		/**
		 * 收藏地址 
		 */
		public static var saveUrl : String;
		/**
		 * 使用缓存
		 */
		public static var useCache : Boolean = true;
		public static var indexTemplateVersion : String = "";
		/**
		 * 是否多线程
		 */
		public static var isMultiThread : Boolean = false;
		/**
		 * 多线程加载
		 */
		public static var isMultiThreadLoad : Boolean = true;
		/**
		 * 是否支持Gpu加速
		 */
		public static var supportDirectX : Boolean = false;
		public static var auth : String;
		public static var sign : String;

		public static var serverUrl : String = "127.0.0.1";
		public static var serverPort : int = 8091;

		public static var policyFileUrl : String = null;
		public static var policyFilePort : int = 843;

		/**
		 * 从加载器启动
		 */
		public static var startupFromLoader : Boolean = false;
		/**
		 * 是否单机游戏
		 */
		public static var isSingleGame : Boolean = false;

		public static var resourceURL : String = './res';
		public static var localRootPath : String = "";

		private static var _stage : Stage;
		private static var _parameters : Object;
		private static var _loaderURL : String;
		public static var nativeWindow : Object;
		public static var stageQuality : String = StageQuality.HIGH;
		public static var stageColor : uint = 0x000000;

		private static var _isFirstEnterSecene : Boolean = true;

		/**
		 * 是否第一次进入场景
		 */
		public static function get isFirstEnterSecene() : Boolean
		{
			return _isFirstEnterSecene;
		}

		public static function set isFirstEnterSecene(value : Boolean) : void
		{
			_isFirstEnterSecene = value;
		}

		public static function get nativeStage() : Stage
		{
			return _stage;
		}

		public static function set nativeStage(value : Stage) : void
		{
			if (value == null)
				throw new ArgumentError("Stage不能为空！");
			_stage = value;
			//限制 flash 的尺寸不进行拉伸, 否则不会触发 resize 事件，其他模式会造成问题！
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.quality = SShellVariables.stageQuality;
			_stage.frameRate = SShellVariables.HIGH_FRESH_RATE;
			_stage.color = SShellVariables.stageColor;

			var loaderInfo : LoaderInfo = _stage.loaderInfo;
			if (loaderInfo)
			{
				_loaderURL = loaderInfo.loaderURL;
				_parameters = loaderInfo.parameters;
			}
			else
			{
				_loaderURL = null;
				_parameters = null;
			}
			init();
		}

		public static function set focus(newFocus : InteractiveObject) : void
		{
			_stage.focus = newFocus;
		}

		public static function get focus() : InteractiveObject
		{
			return _stage.focus;
		}

		sunny_engine static var nativeOverlay : SSprite;
		/**
		 * 场景容器
		 */
		public static var sceneContainer : SNormalContainer = new SNormalContainer();
		/**
		 * 地图容器
		 */
		public static var mapContainer : SNormalContainer = new SNormalContainer();
		/**
		 * 实体容器
		 */
		public static var entityContainer : SNormalContainer = new SNormalContainer();
		/**
		 * 天气容器
		 */
		public static var weatherContainer : SNormalContainer = new SNormalContainer();
		/**
		 * UI容器
		 */
		public static var uiContainer : SSprite = new SSprite();
		/**
		 * 指引容器
		 */
		public static var guideContainer : SSprite = new SSprite();
		/**
		 * 消息容器
		 */
		public static var msgContainer : SSprite = new SSprite();
		/**
		 * 剧情容器
		 */
		public static var plotContainer : SSprite = new SSprite();
		/**
		 * 弹出容器
		 */
		public static var popUpContainer : SSprite = new SSprite();

		// 游戏屏幕宽度
		public static var gameWidth : uint = 0;
		// 游戏屏幕长度
		public static var gameHeight : uint = 0;

		public static var gameMinWidth : uint = 1000;
		public static var gameMinHeight : uint = 600;

		public static var gameMaxWidth : uint = 1920; //1600;
		public static var gameMaxHeight : uint = 1080; //900;

		// 游戏场景宽度
		public static var sceneWidth : uint = 0;
		// 游戏场景长度
		public static var sceneHeight : uint = 0;

		public static var enviroment : String;


		public static var stageIsActive : Boolean;

		/**
		 * 使用服务器配置
		 */
		public static var useServerConfig : Boolean = false;
		private static var isFullScreen : Boolean;

		public static var SUPER_HIGH_FRESH_RATE : int = 120;
		public static var HIGH_FRESH_RATE : int = 60;
		public static var MEDIUM_FRESH_RATE : int = 30;
		public static var LOW_FRESH_RATE : int = 15;

		public static var args : Array;
		private static var _installed : Boolean = false;

		private static const TYPE_DESKTOP : String = "Desktop";
		private static const TYPE_ACTIVE_X : String = "ActiveX";
		private static const TYPE_PLUG_IN : String = "PlugIn";

		/**
		 * 桌面版
		 */
		public static function isDesktop() : Boolean
		{
			return Capabilities.playerType == TYPE_DESKTOP;
		}

		/**
		 * 网页版
		 */
		public static function isWeb() : Boolean
		{
			return Capabilities.playerType == TYPE_ACTIVE_X || Capabilities.playerType == TYPE_PLUG_IN;
		}

		private static function init(fullScreen : Boolean = false) : void
		{
			if (_installed)
				return;

			nativeOverlay = new SSprite();
			nativeOverlay.mouseChildren = true;
			nativeStage.addChild(nativeOverlay);
			nativeStage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			nativeStage.addEventListener(MouseEvent.CONTEXT_MENU, contentMenuHandler);

			sceneContainer.mouseChildren = true;
			nativeOverlay.addChild(sceneContainer);
			sceneContainer.addChild(mapContainer);
			sceneContainer.addChild(entityContainer);
			sceneContainer.addChild(weatherContainer);
			mapContainer.buttonMode = false;
			mapContainer.tabEnabled = true;
			mapContainer.useHandCursor = false;
			sceneContainer.mouseEnabled = false;
			entityContainer.mouseChildren = entityContainer.mouseEnabled = false;
			weatherContainer.mouseChildren = weatherContainer.mouseEnabled = false;

			uiContainer.mouseChildren = true;
			nativeOverlay.addChild(uiContainer);

			msgContainer.mouseChildren = true;
			nativeOverlay.addChild(msgContainer);

			guideContainer.mouseChildren = true;
			nativeOverlay.addChild(guideContainer);

			plotContainer.mouseChildren = true;
			nativeOverlay.addChild(plotContainer);

			popUpContainer.mouseChildren = true;
			nativeOverlay.addChild(popUpContainer);

			nativeStage.focus = sceneContainer;
			nativeStage.stageFocusRect = false;
			nativeStage.tabChildren = false;

			stageIsActive = true;

			if (nativeStage.hasOwnProperty("nativeWindow"))
			{
				nativeWindow = nativeStage["nativeWindow"];
				if (nativeWindow)
				{
					if (fullScreen)
					{
						isFullScreen = true;
					}
					else
					{
						nativeWindow.x = (nativeStage.fullScreenWidth - nativeWindow.width) * 0.5;
						nativeWindow.y = (nativeStage.fullScreenHeight - nativeWindow.height) * 0.5;
					}
					nativeWindow.activate();
				}
			}

			SPopUpManager.init(SShellVariables.popUpContainer);
			resize(nativeStage.stageWidth, nativeStage.stageHeight);
			_installed = true;
		}

		private static function onRightClick(evt : MouseEvent) : void
		{

		}

		private static function contentMenuHandler(evt : Event) : void
		{
		}

		public static function get frameRate() : int
		{
			if (_stage)
				return _stage.frameRate;
			return 60;
		}

		public static function set frameRate(value : int) : void
		{
			if (_stage)
				_stage.frameRate = value;
		}

		public static function get frameTimes() : int
		{
			return 1000 / frameRate;
		}

		public static function resize(stageWidth : int, stageHeight : int) : void
		{
			gameWidth = stageWidth;
			gameHeight = stageHeight;

			sceneWidth = stageWidth + hScrollMargin;
			sceneHeight = stageHeight + vScrollMargin;

			SShellVariables.nativeStage.stageWidth = stageWidth;
			SShellVariables.nativeStage.stageHeight = stageHeight;
		}

		public static function get hScrollMargin() : int
		{
			var value : int = 50; //nativeStage.stageWidth / 9;
			//value = Math.min(value, 500);
			return value;
		}

		public static function get vScrollMargin() : int
		{
			var value : int = 50; //nativeStage.stageHeight / 9;
			//value = Math.min(value, 500);
			return value;
		}

		public static function get rightMargin() : int
		{
			var value : int = 50; //nativeStage.stageWidth / 9;
			//value = Math.min(value, 500);
			return value;
		}

		public static function get bottomMargin() : int
		{
			var value : int = 50; //nativeStage.stageHeight / 9;
			//value = Math.min(value, 500);
			return value;
		}

		private static var filesystemUrl : String = 'base/filesystem.sfs';

		/**
		 * 获取文件配置表
		 * @return
		 */
		public static function getFileSystemUrl() : String
		{
			return filesystemUrl;
		}

		public static function setFileSystemUrl(url : String) : void
		{
			filesystemUrl = url;
		}

		/**窗口标题*/
		public static function get title() : String
		{
			if (nativeWindow)
				return nativeWindow.title;
			return null;
		}

		public static function set title(value : String) : void
		{
			args = value.split("|");
			value = args.shift();
			if (nativeWindow)
				nativeWindow.title = value;
		}

		/**窗口宽*/
		public static function get windowWidth() : int
		{
			if (nativeWindow)
				return nativeWindow.width;
			return 0;
		}

		/**窗口高*/
		public static function get windowHeight() : int
		{
			if (nativeWindow)
				return nativeWindow.height;
			return 0;
		}

		/**窗口获得焦点*/
		public static function focusStage() : void
		{
			focus = nativeStage;
			if (nativeWindow)
			{
				nativeWindow.alwaysInFront = true;
				nativeWindow.alwaysInFront = false;
			}
		}

		/**窗口最小化*/
		public static function minimize() : void
		{
			if (nativeWindow)
				nativeWindow.minimize();
		}

		/**关闭窗口*/
		public static function close() : void
		{
			if (nativeWindow)
				nativeWindow.close();
		}

		public static function get parameters() : Object
		{
			return _parameters;
		}

		public static function get loaderURL() : String
		{
			return _loaderURL;
		}

		public function dispose() : void
		{
			if (nativeOverlay)
			{
				nativeOverlay.destroy();
				nativeOverlay = null;
			}
		}
	}
}
