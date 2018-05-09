package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.loader.SResourceLoader;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.resource.SBasicFileSystem;
	import com.sunny.game.engine.resource.SMutiResources;
	import com.sunny.game.engine.resource.SResource;
	import com.sunny.game.engine.resource.SResourceDescription;
	
	import flash.events.ErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的一个资源管理器
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
	public class SResourceManager
	{
		/**
		 * batch值映射到资源id
		 */
		public var _idsByBatch : Dictionary = new Dictionary();
		/**
		 * id映射到相应的资源描述符
		 */
		private var _resourceDescriptionByID : Dictionary = new Dictionary();

		private var _resourceLoader : SResourceLoader = new SResourceLoader("SResourceManager", 2);

		private var _rootPath : String = "";

		private var _fileSystemURL : String;
		public var fileSystemXML : XML;
		/**
		 * 是否脱机状态
		 */
		public var isOffline : Boolean;

		/**
		 * 要加载的后缀文件名，加强SResourceLoader对后缀的Binary 和加密的文件 处理
		 */
		private var _sunnyByteCryptExtensions : Array = [];

		private static var _singleton : Boolean = true;
		private static var _instance : SResourceManager;

		public var fileSystemInited : Boolean;

		/**
		 * 初始化完成回调函数
		 * signature: void initCompleted(success : Bollean) : void
		 */
		private var _notifyInitCompleted : Function;

		//public var loaderContext : LoaderContext;

		public function SResourceManager()
		{
			super();
			if (_singleton)
				throw new Error("只能通过getInstance()来获取SResourceManager实例！");

			var customTypesExtensions : Object = {};
			customTypesExtensions[SResourceLoader.TYPE_BINARY] = ['url', 'smp', 'smt', "smc", "smg", "src", "sra", "sec", "sea", "scf", "sms", "sim", "smv", "scu", "sap", "sfs", "spt", "sbc", "smcr", "sfc", "xtf"];
			SResourceLoader._customTypesExtensions = customTypesExtensions;

			addSunnyByteCryptExtensions("smp"); //地图预览
			addSunnyByteCryptExtensions("smt"); //地图块
			addSunnyByteCryptExtensions("smc"); //地图配置
			addSunnyByteCryptExtensions("smg"); //地图格子
			addSunnyByteCryptExtensions("src"); //角色配置
			addSunnyByteCryptExtensions("sra"); //角色动画
			addSunnyByteCryptExtensions("sec"); //特效配置
			addSunnyByteCryptExtensions("sea"); //特效动画
//			addSunnyByteCryptExtensions("scf"); //数据配置
			addSunnyByteCryptExtensions("sms"); //媒体音效
			addSunnyByteCryptExtensions("sim"); //图片
			addSunnyByteCryptExtensions("smv"); //影片
			addSunnyByteCryptExtensions("scu"); //光标
			addSunnyByteCryptExtensions("sap"); //应用程序
			addSunnyByteCryptExtensions("sfs"); //文件系统
			addSunnyByteCryptExtensions("spt"); //剧情
			addSunnyByteCryptExtensions("sbc"); //abc字节码
			addSunnyByteCryptExtensions("smcr"); //宏
			addSunnyByteCryptExtensions("sfc"); //表情
			addSunnyByteCryptExtensions("xtf"); //xtf
			_resourceLoader.addEventListener(SResourceLoader.ERROR, _onIoError);
		}

		public static function getInstance() : SResourceManager
		{
			if (!_instance)
			{
				_singleton = false;
				_instance = new SResourceManager();
				_singleton = true;
			}
			return _instance;
		}

		public function init(fileSystemURL : String, notifyCompleted : Function) : void
		{
			_fileSystemURL = fileSystemURL;
			_notifyInitCompleted = notifyCompleted;
			createResource(_fileSystemURL).setVersion(SShellVariables.applicationVersion).onComplete(loadFileSystemSuccess).onIOError(loadFileSystemFailed).load();
			startLoader();
		}

		private function loadFileSystemFailed(res : SResource) : void
		{
			isOffline = true;
			if (SShellVariables.localRootPath && SShellVariables.isDesktop())
				offlineInit();
			else
				invokeInitCompleted(false);
		}

		private function offlineInit() : void
		{
			var res : SResource = getResource(_fileSystemURL);
			if (res)
				res.onComplete(loadFileSystemSuccess).onIOError(offlineLoadFileSystemFailed).reload();
			startLoader();
		}

		private function offlineLoadFileSystemFailed(res : SResource) : void
		{
			invokeInitCompleted(false);
		}

		private function loadFileSystemSuccess(res : SResource) : void
		{
			var bytes : ByteArray = res.getBinary(true);
			var str : String = bytes.readUTFBytes(bytes.bytesAvailable);
			fileSystemXML = XML(str);
			parseFileXml(fileSystemXML);
			invokeInitCompleted(true);
			fileSystemInited = true;
		}

		private function invokeInitCompleted(success : Boolean) : void
		{
			if (_notifyInitCompleted != null)
			{
				_notifyInitCompleted(success);
				_notifyInitCompleted = null;
			}
		}

		/**
		 * 解析一段文件
		 * @param xml
		 */
		public function parseFileXml(xml : XML) : void
		{
			for each (var file : XML in xml.file)
			{
				var desc : SResourceDescription = new SResourceDescription();
				desc.id = String(file.@id);
				desc.url = String(file.@url);
				desc.version = String(file.@version);
				_resourceDescriptionByID[desc.id] = desc;
			}

			if (!_idsByBatch)
				return;

			for each (var batch : XML in xml.batch)
			{
				var ids : Array = [];
				for each (file in batch.file)
				{
					ids.push(String(file.@id));
				}

				_idsByBatch[String(batch.@id)] = ids;
			}
		}

		public function getBatchIds(batch : String) : Array
		{
			var ids : Array = _idsByBatch[batch];
			if (!ids)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "不存在批量预加载" + batch + "的资源");
			}
			return ids;
		}

		public function getResourceDescription(id : String) : SResourceDescription
		{
			return _resourceDescriptionByID[id];
		}

		/**
		 * 创建资源
		 * @param id
		 * @param root
		 * @param context
		 * @param isLocalFile
		 * @return
		 *
		 */
		public function createResource(id : String, fileSystem : SBasicFileSystem = null, version : String = null, root : String = null) : SResource
		{
			return SReferenceManager.getInstance().createResource(id, fileSystem, version, root);
		}

		public function getResource(id : String, fileSystem : SBasicFileSystem = null) : SResource
		{
			return SReferenceManager.getInstance().getResource(id, fileSystem);
		}

		public function clearResource(id : String) : void
		{
			SReferenceManager.getInstance().clearResource(id);
		}

		public function startLoader() : void
		{
			if (!_resourceLoader.isRunning && _resourceLoader._items.length > 0)
			{
				if (SShellVariables.isDesktop())
					_resourceLoader.start(15);
				else
					_resourceLoader.start(SShellVariables.isPrimordial ? 2 : 2);
			}
		}

		/**
		 * 下载filesystem 所有节点属性batch == batchName的资源
		 */
		public function batch(batchName : String) : SMutiResources
		{
			var batchIds : Array = getBatchIds(batchName);
			var res : SMutiResources = new SMutiResources(batchIds);
			return res;
		}

		/**
		 * 添加一个要使用SResourceLoader.TYPE_BINARY来加载 并使用了混淆 的文件后缀名 类型
		 * @param extension
		 * @return
		 */
		public function addSunnyByteCryptExtensions(extension : String) : SResourceManager
		{
			var index : int = _sunnyByteCryptExtensions.indexOf(extension);
			if (index == -1)
				_sunnyByteCryptExtensions.push(extension);
			return this;
		}

		/**
		 * 是否是加密的类型
		 * @param urlAsString
		 * @return
		 */
		public function isSunnyByteCryptType(urlAsString : String) : Boolean
		{
			var searchString : String = urlAsString.indexOf("?") > -1 ? urlAsString.substring(0, urlAsString.indexOf("?")) : urlAsString;
			// split on "/" as an url can have a dot as part of a directory name
			var finalPart : String = searchString.substring(searchString.lastIndexOf("/"));
			var extension : String = finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
			for each (var checkExt : String in _sunnyByteCryptExtensions)
			{
				if (checkExt == extension)
					return true;
			}
			return false;
		}

		private function _onIoError(e : ErrorEvent) : void
		{
			SDebug.warningPrint(this, e.toString());
		}

		public function get rootPath() : String
		{
			return _rootPath;
		}

		public function set rootPath(value : String) : void
		{
			_rootPath = value;
			_rootPath = _rootPath.replace(/\\/g, "/");
		}

		public function get load_num() : int
		{
			return _resourceLoader._connections.length;
		}

		sunny_engine function get resourceLoader() : SResourceLoader
		{
			return _resourceLoader;
		}
	}
}