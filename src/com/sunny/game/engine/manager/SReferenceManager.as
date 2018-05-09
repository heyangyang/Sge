package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.animation.SAnimationDescription;
	import com.sunny.game.engine.avatar.SAvatarAnimationLibrary;
	import com.sunny.game.engine.avatar.SAvatarDescription;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.effect.SEffectAnimationLibrary;
	import com.sunny.game.engine.effect.SEffectDescription;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.events.SEventPool;
	import com.sunny.game.engine.fileformat.pak.SDirectAnimationDecoder;
	import com.sunny.game.engine.lang.SReference;
	import com.sunny.game.engine.loader.SLoadPriorityType;
	import com.sunny.game.engine.loader.SResourceLoader;
	import com.sunny.game.engine.map.SMapResourceParser;
	import com.sunny.game.engine.parser.SAnimationResourceParser;
	import com.sunny.game.engine.parser.SPakResourceParser;
	import com.sunny.game.engine.parser.SSoundResourceParser;
	import com.sunny.game.engine.render.SBitmapDataReference;
	import com.sunny.game.engine.resource.SBasicFileSystem;
	import com.sunny.game.engine.resource.SResource;
	import com.sunny.game.engine.resource.SResourceDescription;
	import com.sunny.game.engine.system.SMemoryChecker;
	import com.sunny.game.engine.ui.image.SImageResourceParser;
	import com.sunny.game.rpg.component.render.SNameParser;

	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.system.System;
	import flash.utils.Dictionary;

	public class SReferenceManager
	{
		private static var instance : SReferenceManager;

		public static function getInstance() : SReferenceManager
		{
			if (instance == null)
				instance = new SReferenceManager();
			return instance;
		}

		public function get status() : String
		{
			var str : String = "";
			if (dic_count[NAME])
				str += "name:" + dic_count[NAME];
			if (dic_count[BITMAPDATA])
				str += "bmd:" + dic_count[BITMAPDATA];
			if (dic_count[PARSER])
				str += "parser:" + dic_count[PARSER];
			return str;
		}

		public static const LOADER : String = "0";
		public static const MAP : String = "1";
		public static const ANIMATION : String = "2";
		public static const ANIMATION_LOAD : String = "3";
		public static const SOUND : String = "4";
		public static const MOVIVE : String = "5";
		public static const ICON : String = "6";
		public static const IMAGE : String = "7";
		public static const FACE : String = "8";
		public static const PARTICLE : String = "9";
		public static const NAME : String = "10";
		public static const PARSER : String = "11";
		public static const BITMAPDATA : String = "12";
		public static const COOL_ANIMATION : String = "13";

		private var check_dic : Dictionary = new Dictionary();
		private var dic : Dictionary = new Dictionary();
		private var dic_count : Dictionary = new Dictionary();
		private var cur_dic : Dictionary;
		private var fileSystemMgr : SFileSystemManager;
		private var resourceMgr : SResourceManager;
		private var _total_reference : int = 0;
		private var memoryMgr : SMemoryChecker;

		public function SReferenceManager()
		{
			check_dic[LOADER] = 30;
			check_dic[MAP] = 50;
			check_dic[ANIMATION] = 50;
			check_dic[ANIMATION_LOAD] = 30;
			check_dic[SOUND] = 30;
			check_dic[MOVIVE] = 30;
			check_dic[ICON] = 30;
			check_dic[IMAGE] = 30;
			check_dic[FACE] = 50;
			check_dic[PARTICLE] = 50;
			check_dic[NAME] = 50;
			check_dic[PARSER] = 50;
			check_dic[BITMAPDATA] = 50;

			resourceMgr = SResourceManager.getInstance();
			memoryMgr = SMemoryChecker.getInstance();
			memoryMgr.setClearMemoryFunction(onSingleClearMemory);
			fileSystemMgr = SFileSystemManager.getInstance();
			SEventPool.addEventListener(SMemoryChecker.CALL_CLEAR_MEMORY, onCheckClearMemoryList);
			SEventPool.addEventListener(SMemoryChecker.CLEAR_MEMORY_BY_TIME, onClearMemoryByTime);
		}

		/**
		 * 根据时间，清理内存
		 * @param e
		 *
		 */
		private function onClearMemoryByTime(e : SEvent) : void
		{
			var id : String;
			var reference : SReference;
			var checkTime : int;
			//700m以后才清理内存，如果不到就不清理，降低cpu消耗
			//700以内只清理时间在60秒以内可以清理的
			var isNormal : Boolean = System.totalMemory < 700000000;
			for (var key : String in check_dic)
			{
				cur_dic = dic[key];
				checkTime = check_dic[key];
				if (isNormal)
					continue;
				for (id in cur_dic)
				{
					reference = cur_dic[id];
					if (reference == null || SShellVariables.getTimer - reference.lastUseTime < checkTime)
						continue;
					if (reference.allowDestroy)
						memoryMgr.addClearFun(key, id);
				}
			}
			SDebug.infoPrint(this, "memory try clear!");
		}

		/**
		 * 检测发现可以清理的添加到内存清除列表
		 * @param e
		 *
		 */
		private function onCheckClearMemoryList(e : SEvent) : void
		{
			var id : String;
			var reference : SReference;

			for (var key : String in dic)
			{
				cur_dic = dic[key];
				for (id in cur_dic)
				{
					reference = cur_dic[id];
					if (reference.allowDestroy)
						memoryMgr.addClearFun(key, id);
				}
			}
		}

		/**
		 * 单个内存清理
		 * @param type
		 * @param id
		 *
		 */
		private function onSingleClearMemory(type : String, id : String) : void
		{
			var clear_dic : Dictionary = dic[type];
			if (clear_dic == null)
				return;
			var reference : SReference = clear_dic[id];
			if (reference)
			{
				reference.tryDestroy();
				if (reference.isDisposed)
				{
					clear_dic[id] = null;
					delete clear_dic[id];
					dic_count[type]--;
					_total_reference--;
					if (SShellVariables.isPrimordial)
						SDebug.infoPrint(reference, "remove:" + id);
				}
			}
		}

		/**
		 * 谨慎使用，一般用于编辑器
		 *
		 */
		public function forceClear(type : String) : void
		{
			var clear_dic : Dictionary = dic[type];
			var reference : SReference;
			for (var id : String in clear_dic)
			{
				reference = clear_dic[id];
				if (reference)
				{
					reference.forceDestroy();
					if (reference.isDisposed)
					{
						clear_dic[id] = null;
						delete clear_dic[id];
						if (SShellVariables.isPrimordial)
							SDebug.infoPrint(reference, "clear：" + id);
					}
				}
			}
		}


		/**
		 * 创建实例
		 * @param type          类型
		 * @param key           id
		 * @param typeClass     类
		 * @param autoDestroy   是否自动销毁
		 * @param args          参数
		 * @return
		 *
		 */
		public function createReference(type : String, key : String, typeClass : Class, ... args) : SReference
		{
			cur_dic = dic[type];
			if (cur_dic == null)
			{
				cur_dic = new Dictionary();
				dic[type] = cur_dic;
				dic_count[type] = 0;
			}
			var reference : SReference = cur_dic[key];
			if (reference && reference.isDisposed)
			{
				SDebug.errorPrint(this, "createReference:" + key);
				return null;
			}

			if (!reference)
			{
				var len : int = args.length;
				switch (len)
				{
					case 0:
						reference = new typeClass();
						break;
					case 1:
						reference = new typeClass(args[0]);
						break;
					case 2:
						reference = new typeClass(args[0], args[1]);
						break;
					case 3:
						reference = new typeClass(args[0], args[1], args[2]);
						break;
					case 4:
						reference = new typeClass(args[0], args[1], args[2], args[3]);
						break;
					case 5:
						reference = new typeClass(args[0], args[1], args[2], args[3], args[4]);
						break;
					case 6:
						reference = new typeClass(args[0], args[1], args[2], args[3], args[4], args[5]);
						break;
					case 7:
						reference = new typeClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
						break;
					case 8:
						reference = new typeClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
						break;
					default:
						throw new Error(this + "类型不足");
						break;
				}
				cur_dic[key] = reference;
				_total_reference++;
				dic_count[type]++;
			}
			else
			{
				reference.retain();
			}
			return reference;
		}

		public function getReference(type : String, key : String) : SReference
		{
			cur_dic = dic[type];
			if (cur_dic == null)
				return null;
			return cur_dic[key];
		}

		//*********************************声音****************************
		public function createSoundReference(id : String) : SSoundResourceParser
		{
			var file : Object = fileSystemMgr.soundFileSystem.getFile(id);
			return createReference(SOUND, id, SSoundResourceParser, file.url, file.version) as SSoundResourceParser;
		}

		public function getSoundReference(id : String) : SSoundResourceParser
		{
			return getReference(SOUND, id) as SSoundResourceParser;
		}

		//*********************************声音****************************


		//*********************************特效帧****************************
		public function createEffectCollection(effectDesc : SEffectDescription, needReversal : Boolean) : SEffectAnimationLibrary
		{
			if (effectDesc == null)
				return null;
			return createReference(ANIMATION, effectDesc.id, SEffectAnimationLibrary, effectDesc, needReversal) as SEffectAnimationLibrary;
		}

		//*********************************特效帧****************************

		//*********************************avatar帧****************************
		public function createAvatarCollection(priority : int, partName : String, avatarDesc : SAvatarDescription, needReversal : Boolean) : SAvatarAnimationLibrary
		{
			if (avatarDesc == null)
				return null;
			return createReference(ANIMATION, partName + "," + avatarDesc.name, SAvatarAnimationLibrary, priority, partName, avatarDesc, needReversal) as SAvatarAnimationLibrary;
		}

		//*********************************avatar帧****************************

		//*********************************懒加载动画****************************
		public function createAnimationResourceParser(desc : SAnimationDescription, prioprty : int, isDirect : Boolean) : SAnimationResourceParser
		{
			return createReference(ANIMATION_LOAD, desc.id, SAnimationResourceParser, desc, prioprty, isDirect) as SAnimationResourceParser;
		}

		//*********************************懒加载动画****************************


		//*********************************动画****************************
		public function createMovieParser(id : String) : SPakResourceParser
		{
			var file : Object = fileSystemMgr.movieFileSystem.getFile(id);
			return createReference(MOVIVE, id, SPakResourceParser, file.url, file.version, SLoadPriorityType.UI_EFFECT) as SPakResourceParser;
		}

		//*********************************动画****************************


		//*********************************粒子****************************
		public function createParticleParser(id : String) : SPakResourceParser
		{
			var file : Object = fileSystemMgr.particleFileSystem.getFile(id);
			return createReference(PARTICLE, id, SPakResourceParser, file.url, file.version, int.MIN_VALUE) as SPakResourceParser;
		}
		//*********************************粒子****************************


		//*********************************icon****************************
		public static const TYPE_IMAGE_ICON : uint = 1;
		public static const TYPE_MOVIE_ICON : uint = 2;

		public function createIconParser(id : String, type : uint = TYPE_IMAGE_ICON) : SPakResourceParser
		{
			var file : Object = fileSystemMgr.iconFileSystem.getFile(id);
			var url : String = file.url;
			if (url == id)
			{
				if (type == TYPE_IMAGE_ICON)
					url = "icon/" + id + ".sim";
				else if (type == TYPE_MOVIE_ICON)
					url = "icon/" + id + ".smv";
			}
			var version : String = file.version;
			if (type == TYPE_IMAGE_ICON)
				return createReference(ICON, id, SImageResourceParser, url, version, SLoadPriorityType.ICON) as SPakResourceParser;
			else if (type == TYPE_MOVIE_ICON)
				return createReference(ICON, id, SPakResourceParser, url, version, SLoadPriorityType.ICON) as SPakResourceParser;
			return null;
		}

		//*********************************icon****************************


		//*********************************image****************************
		public function createImageParser(id : String, priority : int = int.MIN_VALUE, isDirect : Boolean = false) : SImageResourceParser
		{
			var file : Object = fileSystemMgr.imageFileSystem.getFile(id);
			return createReference(IMAGE, id, SImageResourceParser, file.url, file.version, priority, false) as SImageResourceParser;
		}

		//*********************************image****************************


		//*********************************表情****************************
		public function createFaceParser(id : String) : SPakResourceParser
		{
			var file : Object = fileSystemMgr.faceFileSystem.getFile(id);
			return createReference(FACE, id, SPakResourceParser, file.url, file.version, int.MIN_VALUE) as SPakResourceParser;
		}

		//*********************************表情****************************


		//*********************************地图****************************
		public function createMapResourceParser(parserClass : Class, id : String, resId : String, prioprty : int, version : String = null) : SMapResourceParser
		{
			return createReference(MAP, id, parserClass, resId, version, prioprty) as SMapResourceParser;
		}

		//*********************************地图****************************

		//*********************************名字****************************
		public function createRoleName(name : String, headText : String, vipLevel : int, nameTextFontSize : int = 13, nameTextColor : uint = 0xffffff) : SNameParser
		{
			return createReference(NAME, "name." + headText + "_" + nameTextColor + "_" + vipLevel, SNameParser, name, vipLevel, headText, nameTextFontSize, nameTextColor) as SNameParser;
		}

		//*********************************名字****************************


		//*********************************动画解析器****************************
		public function createDirectAnimationDeocder(id : String, isDirect : Boolean) : SDirectAnimationDecoder
		{
			return createReference(PARSER, id, SDirectAnimationDecoder, id, isDirect) as SDirectAnimationDecoder;
		}

		//*********************************动画解析器****************************

		//*********************************加载器****************************
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
			if (!id)
				return null;
			if (fileSystem)
			{
				var file : Object = fileSystem.getFile(id);
				if (file)
				{
					if (String(file.url))
						id = file.url;
					if (String(file.version))
						version = file.version;
				}
			}
			if (!id)
				return null;

			id = id.replace(/\\/g, "/");
			//如果没有则需要初始化
			var isInit : Boolean = getReference(LOADER, id) == null;
			var res : SResource = createReference(LOADER, id, SResource, id) as SResource;
			//自动销毁
			res.release();
			if (isInit)
			{
				var desc : SResourceDescription = resourceMgr.getResourceDescription(id);
				res.setVersion(desc ? desc.version : version);

				var rootUrl : String;
				if (root == null)
					rootUrl = resourceMgr.rootPath + "/";
				else if (root == "")
					rootUrl = root;
				else
					rootUrl = root + "/";
				// filesystem.xml文件中是否有相应的url映射，有的话，才有该映射url，没有的话，则认为该id为资源的路径
				var url : String = desc ? (rootUrl + desc.url) : (rootUrl + id);
				url = url.replace(/\\/g, "/");
				res.url = encodeURI(url);
				//是否需要解密资源
				if (resourceMgr.isSunnyByteCryptType(res.url))
					res.type(SResourceLoader.TYPE_BINARY).attr['sunnyByteCrypt'] = true;

				var loaderContext : LoaderContext = new LoaderContext(true);
				loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
				if (!SShellVariables.isDesktop())
					loaderContext.securityDomain = SecurityDomain.currentDomain;
				else
					loaderContext.checkPolicyFile = false;

				res.context(loaderContext);

				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(this, "create:" + res.id);
			}
			return res;
		}

		public function getResource(id : String, fileSystem : SBasicFileSystem = null) : SResource
		{
			if (!id)
				return null;
			if (fileSystem)
			{
				var file : Object = fileSystem.getFile(id);
				if (file && String(file.url))
					id = file.url;
			}
			id = id.replace(/\\/g, "/");
			return getReference(LOADER, id) as SResource;
		}

		public function clearResource(id : String) : void
		{
			onSingleClearMemory(LOADER, id);
		}

		public function get total_reference() : int
		{
			return _total_reference;
		}

		//*********************************加载器****************************

		//*********************************bitmapData****************************
		public function createBitmapData(id : String, width : int, height : int, transparent : Boolean = true, fillColor : uint = 4.294967295E9, isDirect : Boolean = false) : SBitmapDataReference
		{
			return createReference(BITMAPDATA, id, SBitmapDataReference, width, height, transparent, fillColor, isDirect) as SBitmapDataReference;
		}

		public function getBitmapData(id : String) : SBitmapDataReference
		{
			return getReference(BITMAPDATA, id) as SBitmapDataReference;
		}

		//*********************************bitmapData****************************
		public function createCoolBitmapData(id : String, width : int, height : int, transparent : Boolean = true, fillColor : uint = 4.294967295E9, isDirect : Boolean = false) : SBitmapDataReference
		{
			return createReference(COOL_ANIMATION, id, SBitmapDataReference, width, height, transparent, fillColor, isDirect) as SBitmapDataReference;
		}

		public function getCoolBitmapData(id : String) : SBitmapDataReference
		{
			return getReference(COOL_ANIMATION, id) as SBitmapDataReference;
		}
		//*********************************bitmapData****************************
	}
}