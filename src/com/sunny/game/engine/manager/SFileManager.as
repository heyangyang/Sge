package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.debug.SDebug;
	
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	public class SFileManager
	{
		public static var File : Class;
		public static var FileMode : Class;
		public static var FileStream : Class;
		private static var _instance : SFileManager;

		public static function getInstance() : SFileManager
		{
			if (!_instance)
				_instance = new SFileManager();

			return _instance;
		}

		public function SFileManager()
		{
			try
			{
				File = getDefinitionByName("flash.filesystem.File") as Class;
				FileMode = getDefinitionByName("flash.filesystem.FileMode") as Class;
				FileStream = getDefinitionByName("flash.filesystem.FileStream") as Class;
			}
			catch (e : ReferenceError)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint("SFileManager", "当前运行环境不支持File！" + "\r\n" + e.message);
			}
		}

		/**
		 * 保存数据
		 * @param bytes	数据源
		 * @param path 文件路径
		 * @param over 是否覆盖原有同名文件
		 * @param compress 是否压缩
		 * @return
		 *
		 */
		public function saveBytesFile(bytes : ByteArray, path : String, over : Boolean = true, compress : Boolean = false) : Boolean
		{
			var file : Object = new File(path);
			if (file.isDirectory)
			{
				return false;
			}

			if (file.exists)
			{
				if (over)
				{
					file.deleteFile();
				}
				else
				{
					//Alert.show("是否覆盖已有文件？","警告",{cmd:"saveBytesFile",bytesData:bytes,filePath:path},Alert.YES|Alert.NO,null,alertCloseHandler);
					return false;
				}
			}
			var fileStream : Object = new FileStream();
			var tmpByte : ByteArray = new ByteArray();
			bytes.position = 0;
			tmpByte.writeBytes(bytes);
			if (compress)
				tmpByte.compress();
			tmpByte.position = 0;
			try
			{
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeBytes(tmpByte);
				fileStream.close();
			}
			catch (e : Error)
			{
				fileStream = null;
				file = null;
				return false;
			}

			fileStream = null;
			file = null;
			return true;
		}

		/**
		 * 获取指定文件的二进制数据
		 * @param path 文件路径
		 * @parma uncompress 是否解压
		 * @return
		 *
		 */
		public function getFileBytesData(path : String, uncompress : Boolean = false) : ByteArray
		{
			var file : Object = new File(path);
			if (file.isDirectory || !file.exists)
			{
				return null;
			}

			var fileStream : Object = new FileStream();
			var bytes : ByteArray = new ByteArray();
			fileStream.open(file, FileMode.READ);
			fileStream.readBytes(bytes);
			fileStream.close();
			if (uncompress)
				bytes.uncompress();
			bytes.position = 0;
			return bytes;
		}

		/**
		 * 文件、目录是否存在
		 * @param path 文件路径
		 * @return
		 *
		 */
		public function isFileExists(path : String) : Boolean
		{
			var file : Object = new File(path);
			return file.exists;
		}
	}
}