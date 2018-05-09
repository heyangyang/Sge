package com.sunny.game.engine.resource
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.loader.SLoadPriorityType;
	import com.sunny.game.engine.loader.SResourceLoader;
	import com.sunny.game.engine.loader.types.LoadingItem;
	import com.sunny.game.engine.manager.SResourceManager;
	import com.sunny.game.engine.ns.sunny_engine;
	
	import flash.events.ErrorEvent;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的多个资源
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
	public class SMutiResources extends SObject implements SIDestroy
	{
		protected var _ids : Array = [];
		protected var _resources : Array = [];

		/**
		 * 下载回调函数，通知下载完成
		 * signature: void complete(res : GameResources) : void
		 */
		protected var _notifyCompleteds : Array;

		/**
		 * 下载回调函数，通知下载出现异常
		 * signature: void error(res : GameResource) : void
		 */
		protected var _notifyIOErrors : Array;

		/**
		 * 下载回调函数，通知下载进度
		 * signature: void progress(pro : ProgressInfo) : void
		 */
		protected var _notifyProgresses : Array;

		protected var _notifyItemComplete : Array;

		/**
		 * 下载进度数据
		 */
		protected var _progress : SProgressInfo = new SProgressInfo();

		protected var _loadedCount : int;

		protected var _loadIndex : int;

		protected var _paused : Boolean = false;

		protected var _hasStarted : Boolean = false;

		protected var _isDisposed : Boolean;

		public function SMutiResources(ids : Array)
		{
			super();
			_isDisposed = false;
			_loadIndex = 0;
			addIds(ids);
		}

		/**
		 * 添加一个要加载的ID
		 * @param id 资源ID，filesystem.xml中的ID 或 URL
		 * @param type 资源类型
		 * @param version 版本号
		 * @param priority 优先级
		 * @param maxTry 当加载失败时最大尝试次数
		 * @return
		 */
		public function addId(id : String, type : String = null, version : String = null, priority : int = SLoadPriorityType.MIN, maxTry : int = 3) : SMutiResources
		{
			if (id)
			{
				var index : int = _ids.indexOf(id);
				if (index == -1)
				{
					var res : SResource = SResourceManager.getInstance().createResource(id);
					if (type)
						res.type(type);
					if (version)
						res.setVersion(version);
					res.maxTry(maxTry);
					res.priority(priority);
					addRes(res);
				}
			}
			return this;
		}

		/**
		 * 添加一个正在加载的资源
		 * @param res
		 * @return
		 */
		public function addRes(res : SResource) : SMutiResources
		{
			_ids.push(res.id);
			_resources.push(res);
			_progress.itemsTotal = _resources.length;
			return this;
		}

		/**
		 * 添加一系列要加载的ID
		 * @param ids
		 * @return
		 */
		public function addIds(ids : Array, types : Array = null) : SMutiResources
		{
			var i : int = 0;
			for each (var id : String in ids)
			{
				var index : int = _ids.indexOf(id);
				if (index == -1) //过滤掉已经存在的
				{
					var res : SResource = SResourceManager.getInstance().createResource(id);
					if (types && types.length > i)
						res.type(types[i]);
					addRes(res);
				}
				i++;
			}
			return this;
		}

		/**
		 * 根据批处理名添加批处理文件
		 * @param batchName 批处理名
		 * @return this
		 *
		 */
		public function batch(batchName : String) : SMutiResources
		{
			var batchIds : Array = SResourceManager.getInstance().getBatchIds(batchName);
			return addIds(batchIds);
		}

		/**
		 * 设置优先等级
		 *
		 * @param ws
		 * @return
		 *
		 */
		public function weights(... ws) : SMutiResources
		{
			var len : int = ws.length;
			for (var i : int = 0; i < len; ++i)
			{
				(_resources[i] as SResource).weight(ws[i]);
			}
			return this;
		}

		public function maxTries(... ms) : SMutiResources
		{
			var len : int = ms.length;
			for (var i : int = 0; i < len; ++i)
			{
				(_resources[i] as SResource).maxTry(ms[i]);
			}
			return this;
		}

		public function priorities(... ps) : SMutiResources
		{
			var len : int = ps.length;
			for (var i : int = 0; i < len; ++i)
			{
				(_resources[i] as SResource).priority(ps[i]);
			}
			return this;
		}

		public function prioritiesAll(priority : int) : SMutiResources
		{
			for each (var res : SResource in _resources)
			{
				res.priority(priority);
			}
			return this;
		}

		public function contexts(... cs) : SMutiResources
		{
			var len : int = cs.length;
			for (var i : int = 0; i < len; ++i)
			{
				(_resources[i] as SResource).priority(cs[i]);
			}
			return this;
		}

		public function onComplete(notifyCompleted : Function) : SMutiResources
		{
			if (!_notifyCompleteds)
			{
				_notifyCompleteds = [];
			}
			if (_notifyCompleteds.indexOf(notifyCompleted) == -1)
				_notifyCompleteds.push(notifyCompleted);
			return this;
		}

		public function onItemComplete(notifyItemCompleted : Function) : SMutiResources
		{
			if (!_notifyItemComplete)
			{
				_notifyItemComplete = [];
			}
			if (_notifyItemComplete.indexOf(notifyItemCompleted) == -1)
				_notifyItemComplete.push(notifyItemCompleted);
			return this;
		}

		public function onIOError(notifyIOError : Function) : SMutiResources
		{
			if (!_notifyIOErrors)
			{
				_notifyIOErrors = [];
			}
			if (_notifyIOErrors.indexOf(notifyIOError) == -1)
				_notifyIOErrors.push(notifyIOError);
			return this;
		}

		public function onProgress(notifyProgress : Function) : SMutiResources
		{
			if (!_notifyProgresses)
			{
				_notifyProgresses = [];
			}
			if (_notifyProgresses.indexOf(notifyProgress) == -1)
				_notifyProgresses.push(notifyProgress);
			return this;
		}

		protected function onItemCompleteHandler(res : SResource) : void
		{
			load();
			invokeItemComplete(res);
		}

		protected function onIOErrorHandler(e : ErrorEvent) : void
		{
			for each (var res : SResource in _resources)
			{
				if (res.loadItem == e.target)
				{
					cleanListener();
					invokeIOError(res);
				}
			}
		}

		protected function onItemIOErrorHandler(res : SResource) : void
		{
			invokeIOError(res);
		}

		protected function onProgressHandler(pro : *) : void
		{
			updateProgress(pro);
			invokeProgress();
		}

		protected function cleanListener() : void
		{
			var bulkLoader : SResourceLoader = SResourceManager.getInstance().resourceLoader;
			bulkLoader.removeEventListener(SResourceLoader.ERROR, onIOErrorHandler);
		}

		/**
		 * 以下实现来自BulkLoader
		 */
		protected function updateProgress(pro : SProgressInfo) : void
		{
			var localWeightPercent : Number = 0;
			var localWeightTotal : int = 0;
			var itemsStarted : int = 0;
			var localWeightLoaded : Number = 0;
			var localItemsTotal : int = _progress.itemsTotal;
			var localItemsLoaded : int = 0;
			var localBytesLoaded : int = 0;
			var localBytesTotal : int = 0;
			var localBytesTotalCurrent : int = 0;

			for each (var res : SResource in _resources)
			{
				var item : LoadingItem = res.loadItem;
				if (!item)
				{
					continue;
				}

				localWeightTotal += item.weight;

				if (item.status == LoadingItem.STATUS_STARTED || item.status == LoadingItem.STATUS_FINISHED || item.status == LoadingItem.STATUS_STOPPED)
				{
					localBytesLoaded += item._bytesLoaded;
					localBytesTotalCurrent += item._bytesTotal;
					localWeightLoaded += (item._bytesLoaded / item._bytesTotal) * item.weight;
					if (item.status == LoadingItem.STATUS_FINISHED)
					{
						++localItemsLoaded;
					}
					++itemsStarted;
				}
			}

			_progress.name = pro.name;
			_progress.url = pro.url;

			localBytesTotal = itemsStarted != localItemsTotal ? Number.POSITIVE_INFINITY : localBytesTotalCurrent;
			localWeightPercent = localWeightTotal == 0 ? 0 : localWeightLoaded / localWeightTotal;

			_progress.bytesTotal = pro.bytesTotal;
			_progress.bytesLoaded = pro.bytesLoaded;
			_progress.bytesTotalLoaded = localBytesLoaded;
			_progress.bytesTotalCurrent = localBytesTotalCurrent;
			_progress.itemsLoaded = _loadIndex;
			_progress.itemsTotal = _resources.length;
			_progress.weightPercent = localWeightPercent;
		}

		public function load() : void
		{
			if (_paused)
				return;

			_hasStarted = true;
			if (_loadIndex < _resources.length)
			{
				var res : SResource = _resources[_loadIndex];
				_loadIndex += 1;
				if (_notifyProgresses)
				{
					res.onComplete(onItemCompleteHandler).onProgress(onProgressHandler).onIOError(onItemIOErrorHandler).load();
				}
				else
				{
					res.onComplete(onItemCompleteHandler).onIOError(onItemIOErrorHandler).load();
				}
			}
			else
			{
				cleanListener();
				invokeComplete();
			}
			SResourceManager.getInstance().resourceLoader.addEventListener(SResourceLoader.ERROR, onIOErrorHandler);
		}

		public function reset() : SMutiResources
		{
			_resources.length = 0;
			_ids.length = 0;
			_loadIndex = 0;
			_paused = false;
			_hasStarted = false;
			cleanNotify();
			cleanListener();
			return this;
		}

		public function unload() : SMutiResources
		{
			for each (var res : SResource in _resources)
			{
				res.unload();
			}
			reset();
			return this;
		}

		public function pause() : void
		{
			_paused = true;
			_hasStarted = false;
		}

		public function resume() : void
		{
			_paused = false;
			if (_hasStarted) //如果已经开始加载过，则恢复加载
				load();
		}

		public function get isLoaded() : Boolean
		{
			for each (var res : SResource in _resources)
			{
				if (!res.isLoaded)
				{
					return false;
				}
			}
			return true;
		}

		protected function invokeComplete() : void
		{
			var notifyCompleteds : Array = null;
			if (_notifyCompleteds)
				notifyCompleteds = _notifyCompleteds.concat();
			cleanNotify();
			for each (var notify : Function in notifyCompleteds)
			{
				notify(this);
			}
		}

		protected function invokeItemComplete(res : SResource) : void
		{
			for each (var notify : Function in _notifyItemComplete)
			{
				notify(res);
			}
		}

		protected function invokeIOError(res : SResource) : void
		{
			for each (var notify : Function in _notifyIOErrors)
			{
				notify(res);
			}
		}

		protected function invokeProgress() : void
		{
			for each (var notify : Function in _notifyProgresses)
			{
				notify(_progress);
			}
		}

		protected function cleanNotify() : void
		{
			_notifyCompleteds = null;
			_notifyIOErrors = null;
			_notifyProgresses = null;
			_notifyItemComplete = null;
		}

		public function get total() : int
		{
			return _ids ? _ids.length : 0;
		}

		public function get ids() : Array
		{
			return _ids;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			_loadIndex = 0;
			_paused = false;
			_hasStarted = false;
			cleanNotify();
			cleanListener();
			if (_ids)
			{
				_ids.length = 0;
				_ids = null;
			}
			if (_resources)
			{
				_resources.length = 0;
				_resources = null;
			}
			_progress = null;
			_isDisposed = true;
		}

		public function get progress() : SProgressInfo
		{
			return _progress;
		}
	}
}