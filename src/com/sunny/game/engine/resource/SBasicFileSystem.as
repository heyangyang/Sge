package com.sunny.game.engine.resource
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.ns.sunny_engine;
	
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的一个基础文件系统
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
	public class SBasicFileSystem implements SIDestroy
	{
		protected var _errorInfo : String = "";
		private var _initialized : Boolean = false;
		protected var _isDisposed : Boolean;
		public var avaliableUrl : String = "";

		public function SBasicFileSystem()
		{
			_initialized = false;
			_isDisposed = false;
		}

		private var _config : XML;
		private var _fileVersions : Dictionary;

		public function init(res : SResource) : void
		{
			_config = res.getXML();
			_fileVersions = new Dictionary();
			for each (var fileXML : XML in _config.file)
			{
				var version : String = String(fileXML.@version);
				_fileVersions[String(fileXML.@id)] = {url: String(fileXML.@url), version: version};
			}
			_initialized = true;
		}

		public function getFile(id : String) : Object
		{
			var url : String;
			var version : String;
			if (_config)
			{
				var data : Object = _fileVersions[id];
				if (data)
				{
					url = data.url;
					if (!url)
					{
						url = getAvaliableUrl(id);
						if (SDebug.OPEN_WARNING_TRACE)
							SDebug.warningPrint(this, "文件系统中ID为%s的url不存在！", id);
					}
					version = data.version;
					if (!version)
					{
						version = SShellVariables.applicationVersion;
						if (SDebug.OPEN_WARNING_TRACE)
							SDebug.warningPrint(this, "文件系统中ID为%s的version不存在！", id);
					}
				}
				else
				{
					url = getAvaliableUrl(id);
					version = SShellVariables.applicationVersion;
					if (SDebug.OPEN_WARNING_TRACE)
						SDebug.warningPrint(this, "文件系统中ID为%s的文件不存在！", id);
				}
			}
			else
			{
				if (SDebug.OPEN_WARNING_TRACE)
					SDebug.warningPrint(this, "ID为%s的文件系统未初始化！", id);
				url = getAvaliableUrl(id);
				version = SShellVariables.applicationVersion;
			}
			return {url: url, version: version};
		}

		protected function getAvaliableUrl(id : String) : String
		{
			if (avaliableUrl.indexOf("*") >= 0 && id.indexOf("/") == -1)
				return avaliableUrl.replace(/\*/g, id);
			return id;
		}

		public function getConfig() : XML
		{
			return _config;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			_isDisposed = true;
		}

		public function getErrorTrace() : String
		{
			return _errorInfo;
		}

		public function get initialized() : Boolean
		{
			return _initialized;
		}

		sunny_engine function get fileVersions() : Dictionary
		{
			return _fileVersions;
		}
	}
}