package com.sunny.game.engine.core
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.events.SEvent;
	
	import flash.events.NetStatusEvent;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * <p>
	 * SunnyGame的Cookie数据
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
	public class SCookie
	{
		public static const MIN_DISK_SPACE_1M : int = 1000000;
		public static const MIN_DISK_SPACE_10M : int = 10000000;
		public static const MIN_DISK_SPACE_100M : int = 100000000;

		public static const COOKIE_FLUSH_STATUS_PENDING : String = "COOKIE_FLUSH_STATUS_PENDING";
		public static const COOKIE_FLUSH_STATUS_RESULT : String = "COOKIE_FLUSH_STATUS_RESULT";

		private var _name : String = null;
		private var _path : String = null;
		private var _sharedObject : SharedObject;
		private var flushStatus : String = null;
		/**
		 *	minDiskSpace 字节(B)空间的存储量 小于 minDiskSpace的数量将不会有提示框弹出
		 */
		private var _minDiskSpace : int = 0;

		public function SCookie(name : String, path : String = "/", minDiskSpace : int = 0)
		{
			_name = name;
			_path = path;
			_minDiskSpace = minDiskSpace;
			_sharedObject = SharedObject.getLocal(name, _path);
			_sharedObject.objectEncoding = ObjectEncoding.AMF3;
		}

		private function onFlushStatus(event : NetStatusEvent) : void
		{
			switch (event.info.code)
			{
				case "SharedObject.Flush.Failed":
					if (SDebug.OPEN_WARNING_TRACE)
						SDebug.warningPrint(this, getQualifiedClassName(this) + ".onFlushStatus() Error: Failed write SharedObject to disk.");
					break;
			}
			_sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
			SEvent.dispatchEvent(COOKIE_FLUSH_STATUS_RESULT, this);
		}

		public function flush() : void
		{
			flushStatus = null;
			try
			{
				flushStatus = _sharedObject.flush(_minDiskSpace);
			}
			catch (error : Error)
			{
				if (SDebug.OPEN_WARNING_TRACE)
					SDebug.warningPrint(this, getQualifiedClassName(this) + ".setCookie() Error: Could not write SharedObject to disk.");
			}
			if (flushStatus != null)
			{
				switch (flushStatus)
				{
					case SharedObjectFlushStatus.PENDING:
						if (SDebug.OPEN_WARNING_TRACE)
							SDebug.warningPrint(this, getQualifiedClassName(this) + ".setCookie() Requesting permission to save value.");
						_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						SEvent.dispatchEvent(COOKIE_FLUSH_STATUS_PENDING, this);
						break;
				}
			}
		}

		public function getName() : String
		{
			return _name;
		}

		public function getPath() : String
		{
			return _path;
		}

		/**
		 *	如果value==null 意味着删除此key
		 * 	如果此Key已经有值了，则原来的值被替换，并返回原来的值
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public function setData(key : String, value : *) : *
		{
			if (key == null)
			{
				throw new ArgumentError("cannot put a value with undefined or null key!");
				return undefined;
			}
			else if (value == null)
			{
				return remove(key);
			}
			else
			{
				var oldValue : * = getData(key);
				_sharedObject.data[key] = value;
				return oldValue;
			}
		}

		public function getData(key : String) : *
		{
			if (!hasKey(key))
			{
				return undefined;
			}
			else
			{
				return _sharedObject.data[key];
			}
		}

		public function remove(key : *) : *
		{
			if (!hasKey(key))
			{
				return null;
			}
			var temp : * = _sharedObject.data[key];
			delete _sharedObject.data[key];
			return temp;
		}

		public function hasData(key : String) : Boolean
		{
			if (!hasKey(key))
			{
				return false;
			}
			else
			{
				return _sharedObject.data[key] != null;
			}
		}

		public function hasKey(key : *) : Boolean
		{
			return _sharedObject.data.hasOwnProperty(key);
		}

		/**
		 * 清除所有数据并从磁盘删除共享对象
		 *
		 */
		public function clear() : void
		{
			_sharedObject.clear();
		}

		public function getSize() : uint
		{
			return _sharedObject.size;
		}

		public function setProperty(propertyName : String, value : Object = null) : void
		{
			_sharedObject.setProperty(propertyName, value);
		}
	}
}