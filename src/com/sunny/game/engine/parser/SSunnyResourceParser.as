package com.sunny.game.engine.parser
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.lang.SReference;
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	import com.sunny.game.engine.loader.SLoadPriorityType;
	import com.sunny.game.engine.manager.SResourceManager;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.resource.SResource;
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的Sunny资源解析器
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
	public class SSunnyResourceParser extends SReference
	{
		public var data : *;
		protected var _id : String;
		protected var _version : String;
		protected var _priority : int;
		protected var _resource : SResource;
		protected var _bytes : ByteArray;

		protected var _isLoaded : Boolean;
		private var _isLoading : Boolean;

		private var _IOErrorFuns : Array;
		private var _completeFuns : Array;

		private var _startLoadTime : Number = 0;
		private var _elapsedTimes : Number = 0;

		/**
		 * 创建一个资源解析器
		 * @param id
		 * @param version 版本
		 * @param priority 优先级
		 * @param saveToCookie 是否保存到缓存
		 *
		 */
		public function SSunnyResourceParser(id : String, version : String = null, priority : int = SLoadPriorityType.MAX)
		{
			super();
			_id = id;
			if (!_id)
				throw new SunnyGameEngineError("资源异常，ID为空！");
			_version = version;
			_priority = priority;
			_isLoaded = false;
			_isLoading = false;
		}

		private function invokeComplete() : void
		{
			_elapsedTimes = getTimer() - _startLoadTime;
			if (!_completeFuns)
				return;
			for each (var fun : Function in _completeFuns)
			{
				fun(this);
				if (_isDisposed)
					return;
			}
			cleanNotify();
		}

		private function invokeIOError() : void
		{
			if (!_IOErrorFuns)
				return;
			for each (var fun : Function in _IOErrorFuns)
			{
				fun(this);
				if (_isDisposed)
					return;
			}
			cleanNotify();
		}

		public function load() : void
		{
			if (_isDisposed)
				return;
			if (_isLoading)
				return;
			_elapsedTimes = 0;
			_startLoadTime = getTimer();
			if (_isLoaded)
			{
				invokeComplete();
			}
			else
			{
				_isLoading = true;
				checkResource();
			}

		}

		protected function checkResource() : void
		{
			loadResource();
		}

		public function reload() : void
		{
			if (_isDisposed)
				return;
			_isLoaded = false;
			_isLoading = true;
			checkResource()
		}

		protected function loadResource() : void
		{
			_resource = SResourceManager.getInstance().getResource(_id);
			if (!_resource)
				_resource = SResourceManager.getInstance().createResource(_id);

			if (_resource == null)
			{
				SDebug.errorPrint(this, "资源解析异常，ID为" + _id + "的资源不存在！");
				return;
			}
			if (_resource.isLoaded)
			{
				onResourceLoaded(_resource);
			}
			else
			{
				_resource.setVersion(_version);
				_resource.maxTry(3);
				_resource.onComplete(onResourceLoaded).onIOError(onResourceIOError).priority(_priority).load();
			}
		}

		private function onResourceLoaded(res : SResource) : void
		{
			if (_resource)
			{
				_resource.removeCompleteNotify(onResourceLoaded);
				_resource.removeIOErrorNotify(onResourceIOError);
				_bytes = _resource.getBinary(true);
				parse(_bytes);
			}
		}

		public function onIOError(fun : Function) : SSunnyResourceParser
		{
			if (!_IOErrorFuns)
				_IOErrorFuns = [];
			if (_IOErrorFuns && _IOErrorFuns.indexOf(fun) == -1)
				_IOErrorFuns.push(fun);
			return this;
		}

		public function removeOnIOError(fun : Function) : SSunnyResourceParser
		{
			if (_IOErrorFuns)
				_IOErrorFuns.splice(_IOErrorFuns.indexOf(fun), 1);
			return this;
		}

		private function onResourceIOError(res : SResource) : void
		{
			if (res)
			{
				res.removeCompleteNotify(onResourceLoaded);
				res.removeIOErrorNotify(onResourceIOError);
				_isLoaded = false;
				_isLoading = false;
				invokeIOError();
			}
		}

		sunny_engine function parse(bytes : ByteArray) : void
		{
			if (!bytes)
				return;
		}

		public function onComplete(fun : Function) : SSunnyResourceParser
		{
			if (!_completeFuns)
				_completeFuns = [];
			if (_completeFuns && _completeFuns.indexOf(fun) == -1)
				_completeFuns.push(fun);
			return this;
		}

		public function removeOnComplete(fun : Function) : SSunnyResourceParser
		{
			if (_completeFuns)
				_completeFuns.splice(_completeFuns.indexOf(fun), 1);
			return this;
		}

		protected function parseCompleted() : void
		{
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "动画解析完成！" + _id);
			_isLoaded = true;
			_isLoading = false;
			invokeComplete();
		}

		override protected function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_resource)
			{
				_resource.removeCompleteNotify(onResourceLoaded);
				_resource.removeIOErrorNotify(onResourceIOError);
				_resource = null;
			}
			_isLoaded = false;
			_isLoading = false;
			_id = null;
			cleanNotify();
			data = null;
			_bytes = null;
			super.destroy();
		}

		private function cleanNotify() : void
		{
			if (_IOErrorFuns)
			{
				_IOErrorFuns.length = 0;
				_IOErrorFuns = null;
			}
			if (_completeFuns)
			{
				_completeFuns.length = 0;
				_completeFuns = null;
			}
		}

		public function pause() : void
		{
			if (_isDisposed)
				return;
			_isLoading = false;
			if (_resource)
			{
				_resource.removeCompleteNotify(onResourceLoaded);
				_resource.removeIOErrorNotify(onResourceIOError);
				_resource.pause();
			}
		}

		override public function release() : void
		{
			super.release();
			if (allowDestroy)
			{
				pause();
			}
		}

		public function get id() : String
		{
			return _id;
		}

		public function get isLoaded() : Boolean
		{
			return _isLoaded;
		}

		public function get version() : String
		{
			return _version;
		}

		public function get priority() : int
		{
			return _priority;
		}

		public function get isLoading() : Boolean
		{
			return _isLoading;
		}

		public function get isPaused() : Boolean
		{
			if (_resource)
				return _resource.isPaused;
			return false;
		}

		public function get elapsedTimes() : Number
		{
			return _elapsedTimes;
		}

	}
}