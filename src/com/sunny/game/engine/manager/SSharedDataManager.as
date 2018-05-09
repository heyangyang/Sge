package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.core.SCookie;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.utils.SCommonUtil;

	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	/**
	 *
	 * <p>
	 * SunnyGame的共享数据管理器
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
	public class SSharedDataManager
	{
		private static var _instance : SSharedDataManager;

		public static function getInstance() : SSharedDataManager
		{
			if (!_instance)
				_instance = new SSharedDataManager();
			return _instance;
		}

		private var _cookie : SCookie;
		private var _initFlushed : Boolean;

		public function SSharedDataManager()
		{
			_initFlushed = false;
			super();
		}

		public function initialize(name : String) : void
		{
			if (!_cookie)
			{
				_cookie = new SCookie("hxkj_" + name, null, SCookie.MIN_DISK_SPACE_100M);
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(this, "初始化本地数据：" + name);
			}
		}

		public function get size() : String
		{
			return SCommonUtil.bytesToString(_cookie.getSize());
		}

		public function getData(property : String, version : String = null) : *
		{
			if (_cookie)
			{
				if (!version)
					version = "0";
				var versionData : * = _cookie.getData(property + "_version");
				if (versionData && versionData != undefined)
				{
					if (String(versionData) == version)
					{
						var propertyData : * = _cookie.getData(property + "_data");
						if (propertyData && propertyData != undefined)
						{
							return propertyData;
						}
					}
				}
			}
			return null;
		}

		public function saveData(property : String, version : String = null, data : * = null) : void
		{
			if (_cookie)
			{
				if (data)
				{
					if (!version)
						version = "0";
					_cookie.setData(property + "_data", data);
					_cookie.setData(property + "_version", version);
				}
				else
				{
					_cookie.remove(property + "_data");
					_cookie.remove(property + "_version");
				}
			}
		}

		public function setProperty(propertyName : String, value : Object = null) : void
		{
			if (_cookie)
				_cookie.setProperty(propertyName, value);
		}

		public function clear() : void
		{
			if (_cookie)
				_cookie.clear();
		}

		public function flush() : void
		{
			if (_cookie)
				_cookie.flush();
		}

		public function initFlush() : void
		{
			if (!_initFlushed)
			{
				_initFlushed = true;
				if (Capabilities.os.indexOf("Linux") != -1)
					return;
				flush();
			}
		}

		public function writeBytes(property : String, version : String, bytes : ByteArray) : void
		{
			if (!bytes)
				return;
			var saveBytes : ByteArray = new ByteArray();
			saveBytes.writeBytes(bytes);
			saveBytes.position = 0;
			saveData(property, version, saveBytes);
		}

		public function readBytes(property : String, version : String) : ByteArray
		{
			var bytes : ByteArray = getData(property, version) as ByteArray;
			if (bytes)
			{
				var readBytes : ByteArray = new ByteArray();
				readBytes.writeBytes(bytes);
				readBytes.position = 0;
				return readBytes;
			}
			return null;
		}

		public function hasData(property : String, version : String) : Boolean
		{
			var data : * = getData(property, version);
			return (data != null);
		}
	}
}