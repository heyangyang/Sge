package com.sunny.game.engine.resource
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.lang.SReference;
	import com.sunny.game.engine.loader.SResourceLoader;
	import com.sunny.game.engine.loader.types.ImageItem;
	import com.sunny.game.engine.loader.types.LoadingItem;
	import com.sunny.game.engine.manager.SResourceManager;
	import com.sunny.game.engine.ns.sunny_engine;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	use namespace sunny_engine;
	
	/**
	 *
	 * <p>
	 * SunnyGame的一个资源
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
	public class SResource extends SReference
	{
		public var dir : int;
		/**
		 * 资源路径
		 */
		public var url : String;
		/**
		 * 见BulkLoader
		 */
		internal var loadItem : LoadingItem;
		/**
		 * 下载回调函数，通知下载完成
		 * signature: void complete(res : GameResource) : void
		 */
		private var _notifyCompleteds : Array;
		/**
		 * 下载回调函数，通知下载出现异常
		 * signature: void error(res : GameResource) : void
		 */
		private var _notifyIOErrors : Array;
		/**
		 * 下载回调函数，通知下载进度
		 * signature: void progress(pro : ProgressInfo) : void
		 */
		private var _notifyProgresses : Array;
		protected var _bulkProps : SResourceProps;
		private var _type : String;
		private var _content : *;
		
		/**
		 * 可以 附带一些数据
		 */
		public var attr : Dictionary;
		
		/**
		 * 资源的版本
		 */
		private var _version : String = "0";
		
		private var _saveToLocal : Boolean = false;
		
		public function SResource(id : String)
		{
			super();
			_bulkProps = new SResourceProps();
			attr = new Dictionary(true);
			_bulkProps.id = id;
		}
		
		public function get fileName() : String
		{
			if (_isDisposed)
				return null;
			var strs : Array = decodeURI(url).split("/");
			return strs[strs.length - 1];
		}
		
		public function load() : SResource
		{
			if (_isDisposed)
				return this;
			if (isLoaded)
				onCompleteHandler();
			else if (isIoError)
				onIOErrorHandler();
			else
				addToLoader();
			return this;
		}
		
		public function reload() : SResource
		{
			if (_isDisposed)
				return this;
			if (isIoError)
			{ //如果出现IO错误，从BulkLoader中删除再重试加载,BulkLoader中加载时并不会处理已经发生IOError的文件
				SResourceManager.getInstance().resourceLoader.remove(id, true);
			}
			if (_content && _content is BitmapData)
				(_content as BitmapData).dispose();
			_content = null;
			cleanListener();
			loadItem = null;
			addToLoader();
			return this;
		}
		
		public function pause() : void
		{
			if (_isDisposed)
				return;
			if (loadItem && loadItem.status != LoadingItem.STATUS_FINISHED)
			{
				var resourceLoader : SResourceLoader = SResourceManager.getInstance().resourceLoader;
				resourceLoader.pause(id, true);
			}
		}
		
		private function onNextFrameNotifyCompleted(e : *) : void
		{
			invokeComplete();
		}
		
		protected function addToLoader() : void
		{
			if (_isDisposed)
				return;
			var resourceLoader : SResourceLoader = SResourceManager.getInstance().resourceLoader;
			if (!loadItem)
			{
				if (SShellVariables.localRootPath && SShellVariables.isDesktop())
				{
					if (getDefinitionByName("com.sunny.game.engine.manager.SLocalResourceManager").getInstance().hasData(id, url, _version))
					{
						_bulkProps.type = _type;
						loadItem = LoadingItem(resourceLoader.add(url.replace(SResourceManager.getInstance().rootPath, SShellVariables.localRootPath) + '?v=' + _version, _bulkProps));
					}
					else
					{
						_bulkProps.type = SResourceLoader.TYPE_BINARY;
						_saveToLocal = true;
						loadItem = LoadingItem(resourceLoader.add(url + "?v=" + _version, _bulkProps));
					}
				}
				else
				{
					_bulkProps.type = _type;
					loadItem = LoadingItem(resourceLoader.add(url + "?v=" + _version, _bulkProps));
				}
				loadItem.addEventListener(Event.COMPLETE, onCompleteHandler);
				loadItem.addEventListener(SResourceLoader.ERROR, onIOErrorHandler);
				loadItem.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(this, '开始 加载资源%s', id);
			}
			if (isPaused)
			{
				resourceLoader.resume(id);
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(this, '恢复 加载资源%s', id);
			}
			SResourceManager.getInstance().startLoader();
		}
		
		public function onComplete(notifyCompleted : Function) : SResource
		{
			if (_isDisposed)
				return this;
			if (!_notifyCompleteds)
			{
				_notifyCompleteds = [];
			}
			if (_notifyCompleteds.indexOf(notifyCompleted) == -1)
				_notifyCompleteds.push(notifyCompleted);
			return this;
		}
		
		public function onIOError(notifyIOError : Function) : SResource
		{
			if (_isDisposed)
				return this;
			if (_notifyIOErrors == null)
			{
				_notifyIOErrors = [];
			}
			if (_notifyIOErrors.indexOf(notifyIOError) == -1)
				_notifyIOErrors.push(notifyIOError);
			return this;
		}
		
		public function onProgress(notifyProgress : Function) : SResource
		{
			if (_isDisposed || notifyProgress==null)
				return this;
			if (!_notifyProgresses)
			{
				_notifyProgresses = [];
			}
			if (_notifyProgresses.indexOf(notifyProgress) == -1)
				_notifyProgresses.push(notifyProgress);
			return this;
		}
		
		internal function weight(w : int) : SResource
		{
			if (_isDisposed)
				return this;
			_bulkProps.weight = w;
			if (loadItem && isUnload)
			{
				loadItem.weight = w;
			}
			return this;
		}
		
		/**
		 * 当加载失败时最大尝试加载次数
		 * @param max
		 * @return
		 */
		public function maxTry(max : uint) : SResource
		{
			if (_isDisposed)
				return this;
			_bulkProps.maxTries = max;
			if (loadItem && isUnload)
			{
				loadItem.maxTries = max;
			}
			return this;
		}
		
		public function priority(prior : int) : SResource
		{
			if (_isDisposed)
				return this;
			_bulkProps.priority = prior;
			if (loadItem)
				SResourceManager.getInstance().resourceLoader.changeItemPriority(id, prior);
			return this;
		}
		
		public function context(ctx : *) : SResource
		{
			if (_isDisposed)
				return this;
			_bulkProps.context = ctx;
			if (loadItem && isUnload)
			{
				loadItem._context = ctx;
			}
			return this;
		}
		
		public function type(type : String) : SResource
		{
			if (_isDisposed)
				return this;
			_bulkProps.type = type;
			_type = type;
			return this;
		}
		
		public function setVersion(ver : String) : SResource
		{
			if (_isDisposed)
				return this;
			_version = SShellVariables.isDebug ? ver + Math.random() : ver;
			return this;
		}
		
		private function cleanListener() : void
		{
			if (loadItem)
			{
				loadItem.removeEventListener(Event.COMPLETE, onCompleteHandler);
				loadItem.removeEventListener(SResourceLoader.ERROR, onIOErrorHandler);
				loadItem.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				loadItem.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			}
		}
		
		/**
		 * 将加载的资源保存到本地（air项目）
		 *
		 */
		private function saveLocalData() : void
		{
			if (!SShellVariables.isDesktop() || !SShellVariables.localRootPath)
				return;
			var saveURL : String = url.replace(SResourceManager.getInstance().rootPath, SShellVariables.localRootPath);
			var index : int = saveURL.indexOf("?v");
			if (index >= 0)
			{
				saveURL = saveURL.slice(0, index);
			}
			var bytes : ByteArray = SResourceManager.getInstance().resourceLoader.getBinary(id, true);
			getDefinitionByName("com.sunny.game.engine.utils.SFileUtil").writeToFile(decodeURI(saveURL), bytes, true, false, function() : void
			{
				getDefinitionByName("com.sunny.game.engine.manager.SLocalResourceManager").getInstance().setLocalResourceDescription(id, url, _version);
				_saveToLocal = false;
				reload();
			});
		}
		
		protected function onCompleteHandler(e : Event = null) : void
		{
			if (_saveToLocal && SShellVariables.isDesktop())
			{
				saveLocalData();
				return;
			}
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, '加载完成 加载资源%s 成功', id);
			cleanListener();
			invokeComplete();
		}
		
		protected function onIOErrorHandler(e : * = null) : void
		{
			if (SDebug.OPEN_WARNING_TRACE)
				SDebug.warningPrint(this, 'IO错误 加载资源%s 失败', id);
			cleanListener();
			invokeIOError();
		}
		
		private function onSecurityErrorHandler(e : SecurityErrorEvent) : void
		{
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.warningPrint(this, "安全沙箱错误 加载资源%s 失败", id);
			cleanListener();
			invokeIOError();
		}
		
		protected function onProgressHandler(e : ProgressEvent) : void
		{
			if (_notifyProgresses != null)
			{
				var progress : SProgressInfo = SProgressInfo.PROGRESS;
				progress.bytesTotal = e.bytesTotal;
				progress.bytesLoaded = e.bytesLoaded;
				progress.bytesTotalCurrent = 0;
				progress.itemsLoaded = 0;
				progress.itemsTotal = 1;
				progress.weightPercent = 0;
				progress.url = url;
				progress.name = id;
				invokeProgress(progress);
			}
		}
		
		/**
		 * 返回资源的类型 参考BulkLoader
		 * @return
		 */
		public function getType() : String
		{
			if (_isDisposed)
				return null;
			return !loadItem ? _bulkProps.type : loadItem.type;
		}
		
		public function get id() : String
		{
			if (_isDisposed)
				return null;
			if (_bulkProps)
				return _bulkProps.id;
			return "";
		}
		
		/**
		 * 加载完成
		 * @return
		 *
		 */
		public function get isLoaded() : Boolean
		{
			if (_isDisposed)
				return false;
			return loadItem && loadItem.status == LoadingItem.STATUS_FINISHED;
		}
		
		public function get isUnload() : Boolean
		{
			if (_isDisposed)
				return false;
			return !loadItem || !loadItem.status;
		}
		
		public function get isIoError() : Boolean
		{
			if (_isDisposed)
				return false;
			return loadItem && loadItem.status == LoadingItem.STATUS_ERROR;
		}
		
		public function get isPaused() : Boolean
		{
			if (_isDisposed)
				return false;
			return loadItem && loadItem.status == LoadingItem.STATUS_STOPPED;
		}
		
		public function get isLoading() : Boolean
		{
			if (_isDisposed)
				return false;
			return loadItem && loadItem.status == LoadingItem.STATUS_STARTED;
		}
		
		public function getXML() : XML
		{
			if (_isDisposed)
				return null;
			if (!_content)
			{
				_content = SResourceParser.getXML(this);
			}
			return _content;
		}
		
		public function getText() : String
		{
			if (_isDisposed)
				return null;
			if (!_content)
			{
				_content = SResourceParser.getTxt(this);
			}
			return _content;
		}
		
		public function getClass(name : String) : Class
		{
			if (_isDisposed)
				return null;
			return (loadItem as ImageItem).getDefinitionByName(name) as Class;
		}
		
		public function getBitmapData() : BitmapData
		{
			if (_isDisposed)
				return null;
			if (!_content)
			{
				_content = SResourceManager.getInstance().resourceLoader.getBitmapData(id, true);
			}
			return _content;
		}
		
		public function getContent(clearMemory : Boolean = true) : *
		{
			if (_isDisposed)
				return null;
			if (!_content)
			{
				_content = SResourceManager.getInstance().resourceLoader.getContent(id, clearMemory);
			}
			return _content;
		}
		
		public function getBinary(clearMemory : Boolean = true) : ByteArray
		{
			if (_isDisposed)
				return null;
			if (!_content)
				_content = SResourceParser.getBinary(this, clearMemory);
			return _content;
		}
		
		private function invokeComplete() : void
		{
			if (isUnload)
				return;
			for each (var notify : Function in _notifyCompleteds)
			{
				notify(this);
				if (_isDisposed)
					break;
			}
			cleanNotify();
		}
		
		private function invokeIOError() : void
		{
			if (isUnload)
				return;
			for each (var notify : Function in _notifyIOErrors)
			{
				notify(this);
				if (_isDisposed)
					break;
			}
			cleanNotify();
		}
		
		private function invokeProgress(progress : SProgressInfo) : void
		{
			if (isUnload)
				return;
			for each (var notify : Function in _notifyProgresses)
			{
				notify(progress);
				if (_isDisposed)
					return;
			}
		}
		
		/**
		 * 清除帧听的回调
		 */
		private function cleanNotify() : void
		{
			if (_notifyCompleteds)
			{
				_notifyCompleteds.length = 0;
				_notifyCompleteds = null;
			}
			if (_notifyIOErrors)
			{
				_notifyIOErrors.length = 0;
				_notifyIOErrors = null;
			}
			if (_notifyProgresses)
			{
				_notifyProgresses.length = 0;
				_notifyProgresses = null;
			}
		}
		
		/**
		 * 清除一个完成回调
		 * @param fun
		 */
		public function removeCompleteNotify(fun : Function) : SResource
		{
			if (_isDisposed)
				return this;
			if (_notifyCompleteds)
			{
				var index : int = _notifyCompleteds.indexOf(fun);
				if (index != -1)
				{
					_notifyCompleteds.splice(index, 1);
				}
			}
			return this;
		}
		
		/**
		 * 清除一个IOError回调
		 * @param fun
		 */
		public function removeIOErrorNotify(fun : Function) : SResource
		{
			if (_isDisposed)
				return this;
			if (_notifyIOErrors)
			{
				var index : int = _notifyIOErrors.indexOf(fun);
				if (index != -1)
				{
					_notifyIOErrors.splice(index, 1);
				}
			}
			return this;
		}
		
		/**
		 * 清除一个progress回调
		 * @param fun
		 *
		 */
		public function removeProgressNotify(fun : Function) : SResource
		{
			if (_isDisposed)
				return this;
			if (_notifyProgresses)
			{
				var index : int = _notifyProgresses.indexOf(fun);
				if (index != -1)
				{
					_notifyProgresses.splice(index, 1);
				}
			}
			return this;
		}
		
		public function unload() : void
		{
			if (_isDisposed)
				return;
			pause();
			if (isIoError)
			{ //如果出现IO错误，从BulkLoader中删除再重试加载
				SResourceManager.getInstance().resourceLoader.remove(id, true);
			}
			loadItem = null;
		}
		
		override protected function destroy() : void
		{
			if (_isDisposed)
				return;
			pause();
			cleanListener();
			cleanNotify();
			if (_content && _content is BitmapData)
				(_content as BitmapData).dispose();
			_content = null;
			loadItem = null;
			attr = null;
			_bulkProps = null;
			super.destroy();
		}
		
		
		/**
		 * 没有加载完成的时候，不能清理掉
		 * @return
		 *
		 */
		override public function tryDestroy() : Boolean
		{
			if (!isLoaded)
				return false;
			return super.tryDestroy();
		}
		
	}
}