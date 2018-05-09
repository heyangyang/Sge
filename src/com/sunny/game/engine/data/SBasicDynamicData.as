package com.sunny.game.engine.data
{
	import com.sunny.game.engine.cfg.SConfigFileSystem;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.loader.SLoadPriorityType;
	import com.sunny.game.engine.manager.SResourceManager;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.resource.SResource;

	/**
	 *
	 * <p>
	 * SunnyGame的一个基础动态数据
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
	public class SBasicDynamicData extends SBasicData
	{
		private var _fileSystem : SConfigFileSystem;
		/**
		 * 已经回调
		 */
		private var _callBacked : Boolean;
		private var _callBacks : Array;
		private var _dataType : Class;
		/**
		 * 优先使用静态数据
		 */
		public var priorityData : Boolean;

		public function SBasicDynamicData(fileSystem : SConfigFileSystem)
		{
			_fileSystem = fileSystem;
			_callBacked = false;
			_callBacks = [];
			priorityData = false;
		}

		/**
		 * 请求数据
		 * @param id
		 * @param callBack function(data:SBasicData)
		 *
		 */
		sunny_engine function requestData(dataType : Class, id : int, callBack : Function, parameters : Array) : void
		{
			if (callBack == null)
				return;
			_dataType = dataType;
			_id = id;
			var callBackData : CallBackData = new CallBackData(callBack, parameters);
			_callBacks.push(callBackData);
			if (SDebug.OPEN_DEBUG_TRACE)
				SDebug.debugPrint(this, "添加动态数据请求-" + _dataType + ":" + _id);
			request();
		}

		/**
		 * 移除请求
		 * @param callBack
		 *
		 */
		public function removeRequest(callBack : Function) : void
		{
			var len : int = _callBacks.length;
			for (var i : int = 0; i < len; i++)
			{
				var callBackData : CallBackData = _callBacks[i];
				if (callBackData && callBackData.func == callBack)
				{
					_callBacks.splice(i, 1);
					if (SDebug.OPEN_DEBUG_TRACE)
						SDebug.debugPrint(this, "移除动态数据请求-" + _dataType + ":" + _id);
					return;
				}
			}
		}

		/**
		 * 请求
		 *
		 */
		protected function request() : void
		{
			var fileUrl : String = _fileSystem.getUrl(id + "");
			var fileVersion : String = _fileSystem.getVersion();
			if (fileUrl && fileVersion)
				SResourceManager.getInstance().createResource(fileUrl).priority(SLoadPriorityType.UI).setVersion(fileVersion).onComplete(onComplete).onIOError(onIOError).load();
			else
				onIOError(null);
		}

		/**
		 * 通知
		 *
		 */
		protected function notify() : void
		{
			_callBacked = true;
			var callBacks : Array = _callBacks.slice();
			_callBacks.length = 0;
			for each (var callBackData : CallBackData in callBacks)
			{
				callBackData.func(this, callBackData.parameters);
				callBackData.destroy();
			}
		}

		public function get callBacked() : Boolean
		{
			return _callBacked;
		}

		private function onComplete(e : SResource) : void
		{
			var descriptions : Array = e.getText().split("\r\n");
			//字段数组
			var tempFields : Array = descriptions.shift().split("\t");
			var rows : int = descriptions.length;
			for (var i : int = 0; i < rows; i++)
			{
				var description : Array = String(descriptions[i]).split("\t");
				for (var j : int = 0; j < tempFields.length; j++)
				{
					var value : String = description[j];
					if (!value || value == "undefined")
						value = "";
					this.readProperty(tempFields[j], value);
				}

				if (this.id == 0 || this.name == "undefined" || this.name == "")
				{
					if (SDebug.OPEN_ERROR_TRACE)
					{
						SDebug.errorPrint(this, "解析数据时第" + int(i + 1) + "行id或name为空值！");
					}
					continue;
				}
			}
			notify();
		}

		private function onIOError(e : SResource) : void
		{
			notify();
		}

		public function get dataType() : Class
		{
			return _dataType;
		}

		public function set dataType(value : Class) : void
		{
			_dataType = value;
		}
	}
}
import com.sunny.game.engine.lang.destroy.SIDestroy;

class CallBackData implements SIDestroy
{
	private var _func : Function;
	protected var _isDisposed : Boolean;

	public function get func() : Function
	{
		return _func;
	}

	public function get parameters() : Array
	{
		return _parameters;
	}

	private var _parameters : Array;

	public function CallBackData(func : Function, parameters : Array)
	{
		_func = func;
		_parameters = parameters;
		_isDisposed = false;
	}

	public function get isDisposed() : Boolean
	{
		return _isDisposed;
	}

	public function destroy() : void
	{
		_isDisposed = true;
		_func = null;
		_parameters = null;
	}
}