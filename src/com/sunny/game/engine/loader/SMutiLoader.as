package com.sunny.game.engine.loader
{
	import com.sunny.game.engine.display.SSprite;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	/**
	 *
	 * <p>
	 * SunnyGame的一个多文件加载器，用于资源加载
	 * 以数组的形式传入加载队列，加载完成后将以数组内容为下标获取applicationDomain
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
	public class SMutiLoader extends SSprite
	{
		public var styleConfig : Object = {bg: true, w: 140, h: 10, bgcolor: 0x111111, showcolor: 0x666666, border: 0, xpos: 0, ypos: 0};

		/**
		 * 携带的数据
		 */
		public var takeData : *;

		/**
		 *	加载器
		 */
		private var loader : Loader;
		/**
		 * 进度条
		 */
		//private var loadingbar : Loading;
		/**
		 * 加载队列
		 */
		private var loadList : Array;
		/**
		 * 加载完成后对应的类库处理队列
		 */
		private var _libList : Array;
		/**
		 * 加载步数
		 */
		private var loaderStep : uint = 0;
		/**
		 * 加载结果
		 */
		private var loadedData : Array;

		private var loadMode : uint;

		private static const APPDOMAIN : uint = 0;
		private static const DOCUMENT : uint = 1;

		/**
		 * 构造函数
		 */
		public function SMutiLoader(container : Array)
		{
			loadedData = container;
		}

		/**
		 * 加载完成后对应的入库关键字
		 */
		public function get libList() : Array
		{
			return _libList;
		}

		/**
		 * 读取指定的资源列表（swf文件）
		 * @list	需要读取的资源列表，扩展名无需填写
		 * @lib		加载完成后对应的类库处理队列
		 */
		public function load(list : Array = null, lib : Array = null) : void
		{
			if (list != null)
			{
				if (loaderStep != 0)
					return;
				loadList = list;
				initLoader();
				loadMode = APPDOMAIN;
			}

			_libList = lib;
			//loader.load(new URLRequest(Global.localServer + loadList[loaderStep] + '.swf'));
		}


		/**
		 * 读取指定的文档列表
		 * @param	list	要读取的资源列表，完整路径
		 */
		public function loadDoc(list : Array = null) : void
		{

			if (list != null)
			{
				if (loaderStep != 0)
					return;
				loadList = list;
				initLoader(false);
				loadMode = DOCUMENT;
			}

			if (loadList[loaderStep] == '' || loadList[loaderStep] == null)
				return;
			loader.load(new URLRequest(loadList[loaderStep]));
		}

		/**
		 * 初始化
		 * @param	displayStep	是否显示加载进度
		 */
		private function initLoader(displayStep : Boolean = true) : void
		{
			if (styleConfig.bg)
			{
				graphics.beginFill(0x000000);
				//graphics.drawRect(0, 0, Global.W, Global.H);
				graphics.endFill();
			}

			loader = new Loader();
			if (displayStep)
			{
//				loadingbar = new Loading(styleConfig.w, styleConfig.h);
//				loadingbar.showerColor = styleConfig.showcolor;
//				loadingbar.bgColor = styleConfig.bgcolor;
//				loadingbar.borderColor = styleConfig.border;
//				loadingbar.start();
//
//				loadingbar.x = styleConfig.xpos == 0 ? int((Global.W - loadingbar.width) / 2) : styleConfig.xpos;
//				loadingbar.y = styleConfig.ypos == 0 ? int((Global.H - loadingbar.height) / 2) : styleConfig.ypos;
//
//				addChild(loadingbar);

				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			}
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadStep);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);

		}

		/**
		 * 响应单文件加载完成
		 */
		private function loadStep(e : Event) : void
		{

			if (loadMode == APPDOMAIN)
			{
				loadedData.push(loader.contentLoaderInfo.applicationDomain);
			}
			else
			{
				loadedData.push(loader.content);
			}
			loaderStep++;
			loader.unload();
			if (loaderStep >= loadList.length)
			{
				// 加载完成
				dispatchEvent(new Event(Event.COMPLETE));
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadStep);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				if (loader.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS))
					loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			}
			else
			{
				// 加载未完成，继续加载
				loadMode == APPDOMAIN ? load() : loadDoc();
			}
		}

		/**
		 * 响应加载过程。进度的显示
		 */
		private function onProgress(e : ProgressEvent) : void
		{
			var per : uint = Math.floor(e.bytesLoaded / e.bytesTotal * 100);
			var totalPerMax : uint = loadList.length * 100;
			per = Math.floor((loaderStep * 100 + per) / totalPerMax * 100);
			if (per > 100)
				per = 100;

			//loadingbar.Per = per;
		}

		private function onError(e : IOErrorEvent) : void
		{
			var target : LoaderInfo = e.target as LoaderInfo;
			trace("Load error!type " + e.type + ',url is ' + target.url);
		}

		/**
		 * 加载完成的数据
		 */
		public function get Data() : Array
		{
			return loadedData;
		}

		override public function clear() : void
		{
//			if (loadingbar != null)
//				loadingbar.clear();

			super.clear();
		}
	}
}