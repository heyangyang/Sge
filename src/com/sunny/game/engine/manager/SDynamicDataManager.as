package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.data.SBasicDynamicData;
	import com.sunny.game.engine.data.SDynamicRequest;
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	import com.sunny.game.engine.ns.sunny_engine;

	import flash.utils.Dictionary;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个动态数据管理器
	 * Linux 中的 IO - 同步,异步,阻塞,非阻塞 http://www.jsembed.com 同步(synchronous) IO 和异步(asynchronous) IO,阻塞(blocking) IO 和非阻塞(non-blocking)...
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
	public class SDynamicDataManager
	{
		private static var globalDynamicDatas : Dictionary = new Dictionary();

		private static var _instance : SDynamicDataManager;

		public static function getInstance() : SDynamicDataManager
		{
			if (_instance == null)
				_instance = new SDynamicDataManager();
			return _instance;
		}

		private var _isBlocking : Boolean;
		private var _initQueue : Array;
		private var _batchRequestQueue : Dictionary;

		public function SDynamicDataManager()
		{
			_isBlocking = true;
			_initQueue = [];
			_batchRequestQueue = new Dictionary();
		}

		public function nonBlocking() : void
		{
			_isBlocking = false;
			for each (var obj : Object in _initQueue)
				doRequestData(obj.dataType, obj.id, obj.callBack, obj.parameters);
			_initQueue.length = 0;
		}

		public function blocking() : void
		{
			_isBlocking = true;
		}

		public function registerDataType(dataType : Class) : void
		{
			if (!globalDynamicDatas[dataType])
			{
				globalDynamicDatas[dataType] = new Dictionary();
				return;
			}
			throw new SunnyGameEngineError("已存在的动态数据类型：" + dataType);
		}

		/**
		 *
		 * @param requests
		 * @param callBack function(datas:Array,parameters:Array) datas元素为SBasicDynamicData
		 * @param parameters
		 * @param force
		 *
		 */
		public function batchRequestData(requests : Vector.<SDynamicRequest>, callBack : Function, parameters : Array = null, force : Boolean = false) : void
		{
			var datas : Array = [];
			_batchRequestQueue[callBack] = {requests: datas, datas: [], parameters: parameters};
			var len : int = requests.length;
			var i : int = 0;
			for (i = 0; i < len; i++)
				datas.push(requests[i]);
			var cloneDatas : Array = datas.slice();
			len = cloneDatas.length;
			for (i = 0; i < len; i++)
				requestData(cloneDatas[i] as SDynamicRequest, batchRequestCallBack);
		}

		public function removeBatchRequest(callBack : Function) : void
		{
			_batchRequestQueue[callBack] = null;
			delete _batchRequestQueue[callBack];
		}

		/**
		 * 批量请求检测
		 * @param data
		 * @param parameters
		 *
		 */
		private function batchRequestCallBack(data : SBasicDynamicData, parameters : Array) : void
		{
			for (var func : * in _batchRequestQueue)
			{
				var obj : Object = _batchRequestQueue[func];
				var requests : Array = obj.requests;
				var len : int = requests.length;
				for (var i : int = len - 1; i >= 0; i--)
				{
					var request : SDynamicRequest = requests[i];
					if (request.dataType == data.dataType && request.id == data.id)
					{
						requests.splice(i, 1);
						(obj.datas as Array).push(data);
					}
				}
				len = requests.length;
				if (len == 0)
				{
					func(obj.datas, obj.parameters);
					_batchRequestQueue[func] = null;
					delete _batchRequestQueue[func];
				}
			}
		}

		/**
		 *
		 * @param request
		 * @param callBack function(data:SBasicDynamicData,parameters:Array)
		 * @param parameters
		 * @param force
		 *
		 */
		public function requestData(request : SDynamicRequest, callBack : Function, parameters : Array = null, force : Boolean = false) : void
		{
			if (_isBlocking)
			{
				if (force)
				{
					for (var i : int = _initQueue.length - 1; i >= 0; i--)
					{
						var obj : Object = _initQueue[i];
						if (obj.dataType == request.dataType && obj.id == request.id)
						{
							doRequestData(obj.dataType, obj.id, obj.callBack, obj.parameters);
							_initQueue.splice(i, 1);
						}
					}
				}
				else
				{
					_initQueue.push({dataType: request.dataType, id: request.id, callBack: callBack, parameters: parameters});
					return;
				}
			}
			doRequestData(request.dataType, request.id, callBack, parameters);
		}

		/**
		 *
		 * @param dataType
		 * @param id
		 * @param callBack
		 *
		 */
		public function removeRequest(request : SDynamicRequest, callBack : Function) : void
		{
			for (var i : int = _initQueue.length - 1; i >= 0; i--)
			{
				var obj : Object = _initQueue[i];
				if (obj.dataType == request.dataType && obj.id == request.id && obj.callBack == callBack)
					_initQueue.splice(i, 1);
			}
			var data : SBasicDynamicData = null;
			var globalDatas : Dictionary = globalDynamicDatas[request.dataType];
			if (globalDatas)
			{
				data = globalDatas[request.id];
				if (data && !data.priorityData && !data.callBacked)
					data.removeRequest(callBack);
			}
			else
				throw new SunnyGameEngineError("试图获取不存在的动态数据类型：" + request.dataType);
		}

		private function doRequestData(dataType : Class, id : int, callBack : Function, parameters : Array = null) : void
		{
			var data : SBasicDynamicData = null;
			var globalDatas : Dictionary = globalDynamicDatas[dataType];
			if (globalDatas)
			{
				data = globalDatas[id];
			}
			else
			{
				throw new SunnyGameEngineError("试图请求未定义的动态数据类型：" + dataType);
			}
			if (!data)
			{
				data = new dataType();
				if (!globalDynamicDatas[dataType])
					globalDynamicDatas[dataType] = new Dictionary();
				globalDynamicDatas[dataType][id] = data;
			}
			if (data.priorityData || data.callBacked)
			{
				callBack(data, parameters);
			}
			else
			{
				data.requestData(dataType, id, callBack, parameters);
			}
		}

		public function setData(dataType : Class, data : SBasicDynamicData) : void
		{
			if (!dataType)
			{
				throw new SunnyGameEngineError("动态数据类型空异常！");
				return;
			}
			if (!data)
			{
				throw new SunnyGameEngineError("动态数据空异常！");
				return;
			}
			data.priorityData = true;
			data.dataType = dataType;
			var globalDatas : Dictionary = globalDynamicDatas[dataType];
			if (globalDatas)
				globalDatas[data.id] = data;
			else
				throw new SunnyGameEngineError("试图获取不存在的动态数据类型：" + dataType);
		}

		/**
		 *
		 * @param dataType
		 * @param id
		 * @return
		 *
		 */
		public function getDataIsCallBacked(dataType : Class, id : int) : Boolean
		{
			var data : SBasicDynamicData = null;
			var globalDatas : Dictionary = globalDynamicDatas[dataType];
			if (globalDatas)
				data = globalDatas[id];
			else
				throw new SunnyGameEngineError("试图获取不存在的动态数据类型：" + dataType);
			return (data && (data.priorityData || data.callBacked));
		}

		/**
		 *
		 * @param dataType
		 * @param id
		 * @return
		 *
		 */
		public function getData(dataType : Class, id : int) : SBasicDynamicData
		{
			var data : SBasicDynamicData = null;
			var globalDatas : Dictionary = globalDynamicDatas[dataType];
			if (globalDatas)
			{
				data = globalDatas[id];
				if (data && (data.priorityData || data.callBacked))
					data = data as SBasicDynamicData;
				else
					data = null;
			}
			else
				throw new SunnyGameEngineError("试图获取不存在的动态数据类型：" + dataType);
			return data;
		}
	}
}