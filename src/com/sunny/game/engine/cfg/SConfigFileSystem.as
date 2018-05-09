package com.sunny.game.engine.cfg
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.resource.SResource;
	import com.sunny.game.engine.utils.SPrintf;

	/**
	 *
	 * <p>
	 * SunnyGame的配置文件系统
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
	public class SConfigFileSystem extends SObject
	{
		private var _config : XML;

		public function SConfigFileSystem()
		{
			super();
		}

		public function init(res : SResource) : void
		{
			_config = res.getXML();
		}

		public function getUrl(id : String) : String
		{
			if (_config)
			{
				var url : String = _config.file.(@id == "config").@url;
				if (url)
				{
					url = SPrintf.printf(url, id);
					return url;
				}
				else
				{
					if (SDebug.OPEN_ERROR_TRACE)
						SDebug.errorPrint(this, "配置文件系统中的url不存在！");
				}
			}
			return null;
		}

		public function getVersion() : String
		{
			if (_config)
			{
				var version : String = String(_config.file.(@id == "config").@version);
				if (version)
					return version;
				else
				{
					if (SDebug.OPEN_ERROR_TRACE)
						SDebug.errorPrint(this, "配置文件系统中的version不存在！");
				}
			}
			return null;
		}

		public function getConfig() : XML
		{
			return _config;
		}
	}
}