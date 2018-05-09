package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.fileformat.png.SPngEncoder;
	import com.sunny.game.engine.manager.SFileManager;
	import com.sunny.game.engine.manager.SResourceManager;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.OutputProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	/**
	 *
	 * <p>
	 * SunnyGame的一个文件工具
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
	public class SFileUtil
	{
		public static const PNG : String = "png";
		public static const JPG : String = "jpg";

		/**
		 * 利用递归来查找在某个文件夹下是否存在fileName为名的文件
		 * @param nativePath:String 要查找 的文件夹路径
		 * @param fileName:String 要查找的文件名称
		 * @return 查找成功则返回true
		 *
		 */
		public static function checkFileIsExit(nativePath : String, fileName : String = null) : Boolean
		{
			SFileManager.getInstance();
			var file : Object = new (SFileManager.File)(nativePath);

			if (fileName == null)
			{
				return file.exists;
			}

			//查找文件夹下的文件
			var list : Array = file.getDirectoryListing();
			var len : int = list.length;
			for (var i : int = 0; i < len; i++)
			{
				var cfile : Object = list[i];
				if (cfile.isDirectory)
				{
					if (checkFileIsExit(cfile.nativePath, fileName))
						return true;
						//checkFileIsExit(cfile.nativePath,fileName);
				}
				else
				{
					if (cfile.name == fileName)
					{
						trace("找到了", cfile.nativePath);
						return true;
					}
				}
			}
			trace("没找到", nativePath);
			return false;
		}

		/**
		 * 获得最终子文件夹下的内容
		 * @param nativePath:String
		 * @return
		 *
		 */
		public static function getDirectoryFiles(nativePath : String, extension : String = null) : Array
		{
			SFileManager.getInstance();
			var files : Array = new Array();
			var fileDire : Object = new (SFileManager.File)(nativePath);

			//查找文件夹下的文件
			var list : Array = fileDire.getDirectoryListing();
			var len : int = list.length;
			for (var i : int = 0; i < len; i++)
			{
				var file : Object = list[i];
				if (file.isDirectory)
				{
					files = files.concat(getDirectoryFiles(file.nativePath, extension));
				}
				else
				{
					if (extension)
					{
						var exts : Array = extension.split(";");
						for each (var ext : String in exts)
						{
							if (ext && file.extension && file.extension.toLowerCase() == ext)
							{
								files.push(file);
							}
						}
					}
					else
					{
						files.push(file);
					}
				}
			}
			return files;
		}

		/**
		 * 文件除去扩展名的文件名字
		 * @param nativePath
		 * @return
		 *
		 */
		static public function getFileFlexion(filename : String) : String
		{
			var name : String = filename.substring(0, filename.lastIndexOf("."));
			return name;
		}

		/**
		 * 保存切割的位图 为PNG
		 * @param bmd 要保存的BitmapData数据
		 * @param nativePath 要保存的文件完整路径
		 * @param type 要保存的文件类型 Files.PNG || Files.JPG
		 * @param overwrite 是否覆盖已有的文件
		 * @param clear 是否自动清除内存
		 */
		public static function writeBitmapDataToFile(bmd : BitmapData, nativePath : String, type : String = SFileUtil.PNG, overwrite : Boolean = true, clear : Boolean = true) : void
		{
			SFileManager.getInstance();
			try
			{
				var file : Object = new (SFileManager.File)(nativePath);
				if (file.exists && !overwrite)
				{
//					trace("已经存在了,不覆盖返回")
					file = null;
					return;
				}

				var bytes : ByteArray;

				switch (type)
				{
					case SFileUtil.PNG:
						bytes = new SPngEncoder().encode(bmd);
						break;
					case SFileUtil.JPG:
						break;
					default:
						break;
				}


				//var pngEncoder:AsPngEncoder = new AsPngEncoder();
				//var bytes:ByteArray = pngEncoder.encode(bmd, new Strategy8BitMedianCutAlpha());

				var stream : Object = new (SFileManager.FileStream)();
				stream.open(file, SFileManager.FileMode.WRITE);
				stream.writeBytes(bytes, 0, bytes.length);
				stream.close();

				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(file, "保存文件", nativePath, "成功");

				if (clear)
					bmd.dispose();
				bmd = null;

				bytes.clear();
				bytes = null;
				file = null;
			}
			catch (e : Error)
			{
				if (SDebug.OPEN_DEBUG_TRACE)
					SDebug.debugPrint(file, "保存文件%s失败", nativePath);
			}
		}

		/**
		 * 通用存储函数
		 * @param nativePath
		 * @param value 可以为Array，Object,String,ByteArray
		 * @param overwrite
		 * @param compress
		 *
		 */
		public static function writeToFile(nativePath : String, value : Object, overwrite : Boolean = true, compress : Boolean = false, asyncFunc : Function = null) : void
		{
			SFileManager.getInstance();
			try
			{
				if (value == "" || value == null || nativePath == "")
				{
					if (SDebug.OPEN_ERROR_TRACE)
						SDebug.errorPrint(null, "写入文件的路径或数据为空！");
					return;
				}

				var file : Object = new (SFileManager.File)(nativePath);
				if (file.exists && !overwrite)
				{
					//					trace("已经存在了,不覆盖,返回");
					file = null;
					return;
				}

				var bytes : ByteArray = new ByteArray();
				if (value is Array)
				{
					bytes.writeObject(value);
				}
				else if (value is String)
				{
					bytes.writeUTFBytes(value as String);
				}
				else if (value is XML)
				{
					bytes.writeUTFBytes((value as XML).toXMLString());
				}
				else if (value is ByteArray)
				{
					(value as ByteArray).position = 0;
					bytes.writeBytes((value as ByteArray), 0, (value as ByteArray).length);
				}
				else if (value is int)
				{
					bytes.writeInt(value as int);
				}
				else if (value is Number)
				{
					bytes.writeFloat(value as Number);
				}
				else if (value is uint)
				{
					bytes.writeUnsignedInt(value as uint);
				}
				else
				{
					bytes.writeObject(value);
				}

				//				
				if (compress)
				{
					trace("压缩前长度", bytes.length);
					bytes.compress();
					trace("压缩后长度", bytes.length);
				}

				var stream : Object = new (SFileManager.FileStream)();
				if (asyncFunc == null)
				{
					stream.open(file, SFileManager.FileMode.WRITE);
					stream.writeBytes(bytes, 0, bytes.length); //使包括汉字时不会有错 gb2123 为汉字编码
				}
				else
				{
					stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, function(e : OutputProgressEvent) : void
					{
						if (e.bytesPending == 0)
							asyncFunc();
					});
					stream.openAsync(file, SFileManager.FileMode.WRITE);
					stream.writeBytes(bytes, 0, bytes.length); //使包括汉字时不会有错 gb2123 为汉字编码
				}
				stream.close();
				bytes.clear();
				bytes = null;

				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(file, "保存文件", nativePath, "成功");
			}
			catch (e : Error)
			{
				if (SDebug.OPEN_DEBUG_TRACE)
					SDebug.debugPrint(file, "保存文件%s失败", nativePath);
			}
		}


		/**
		 * 保存一份字符串到硬盘
		 * @param nativePath 包括文件后缀名的完整路径
		 * @param value 要保存的字符串
		 * @param type  表示输出UTF-8 或 gb2123
		 * @param overwrite 是否覆盖已有的文件
		 */
		public static function writeStringToFile(nativePath : String, value : String, charSet : String = "UTF-8", overwrite : Boolean = true) : Boolean
		{
			SFileManager.getInstance();
			try
			{
				if (value == "" || nativePath == "")
				{
					trace("非法传值");
					return false;
				}

				var file : Object = new (SFileManager.File)(nativePath);
				if (file.exists && !overwrite)
				{
					trace("已经存在了,不覆盖,返回");
					file = null;
					return false;
				}

				var stream : Object = new (SFileManager.FileStream)();
				stream.open(file, SFileManager.FileMode.WRITE);
				stream.writeMultiByte(value, charSet); //使包括汉字时不会有错 gb2123 为汉字编码
				stream.close();

				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(file, "保存文件", nativePath, "成功");
			}
			catch (e : Error)
			{
				if (SDebug.OPEN_DEBUG_TRACE)
					SDebug.debugPrint(file, "保存文件%s失败", nativePath);
				return false;
			}

			return true;
		}


		/**
		 * 保存一份被压缩的字符串到硬盘
		 * @param nativePath 包括文件后缀名的完整路径
		 * @param str 要保存的字符串
		 * @param overwrite 是否覆盖已有的文件
		 * @param type  表示输出UTF-8 或 gb2123
		 *
		 */
		public static function writeCompressUTFBytesToFile(nativePath : String, value : String, type : String = "UTF-8", overwrite : Boolean = true, async : Boolean = false) : Boolean
		{
			SFileManager.getInstance();
			try
			{
				if (value == "" || nativePath == "")
				{
					trace("非法传值");
					return false;
				}

				var file : Object = new (SFileManager.File)(nativePath);
				if (file.exists && !overwrite)
				{
					trace("已经存在了,不覆盖,返回");
					file = null;
					return false;
				}

				var bytes : ByteArray = new ByteArray();
				bytes.writeMultiByte(value, type);

				trace("压缩前长度", bytes.length);
				bytes.compress();
				trace("压缩后长度", bytes.length);

				var stream : Object = new (SFileManager.FileStream)();
				if (async)
				{
					stream.openAsync(file, SFileManager.FileMode.WRITE);
					stream.writeBytes(bytes, 0, bytes.length); //使包括汉字时不会有错 gb2123 为汉字编码
				}
				else
				{
					stream.open(file, SFileManager.FileMode.WRITE);
					stream.writeBytes(bytes, 0, bytes.length); //使包括汉字时不会有错 gb2123 为汉字编码
				}
				stream.close();
				bytes.clear();
				bytes = null;

				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(file, "保存文件", nativePath, "成功");
			}
			catch (e : Error)
			{
				if (SDebug.OPEN_DEBUG_TRACE)
					SDebug.debugPrint(file, "保存文件%s失败", nativePath);
				return false;
			}

			return true;
		}


		/**
		 * 读取硬盘某个文件的字符串数据
		 * @param nativePath 文件路径
		 * @param 是否是要解压缩文件
		 * @return 返回字符串
		 *
		 */
		public static function readUTFBytesFromFile(nativePath : String, unCompress : Boolean = false) : String
		{
			SFileManager.getInstance();
			// Read string
//			var fileStream : FileStream = new FileStream();
//			fileStream.open(file, FileMode.READ);
//			var fileString : String = fileStream.readMultiByte(file.size, File.systemCharset);
//			fileStream.close();

			var value : String;
			try
			{
				var bytes : ByteArray = new ByteArray();

				var file : Object = new (SFileManager.File)(nativePath);
				var stream : Object = new (SFileManager.FileStream)();
				stream.open(file, SFileManager.FileMode.READ);
				//data = stream.readUTFBytes(stream.bytesAvailable);
				stream.readBytes(bytes, 0, stream.bytesAvailable);
				stream.close();

				if (unCompress)
					bytes.uncompress();

				value = bytes.readUTFBytes(bytes.length);

				bytes = null;
			}
			catch (e : Error)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(e, "读取文件%s出错，%s", nativePath, e.message);
			}
			return value;
		}


		/**
		 * 从某个文件中读取二制流
		 * @param nativePath
		 * @param unCompress 是否是要解压缩文件
		 * @return 返回二进制流
		 *
		 */
		public static function readBytesFromeFile(nativePath : String, unCompress : Boolean = false, asyncFunc : Function = null) : ByteArray
		{
			SFileManager.getInstance();
			var bytes : ByteArray = new ByteArray();
			try
			{
				var file : Object = new (SFileManager.File)(nativePath);
				var stream : Object = new (SFileManager.FileStream)();
				if (asyncFunc == null)
				{
					stream.open(file, SFileManager.FileMode.READ);
					stream.readBytes(bytes, 0, stream.bytesAvailable);
					stream.close();
					if (unCompress)
						bytes.uncompress();
				}
				else
				{
					stream.addEventListener(Event.COMPLETE, function(e : Event) : void
					{
						stream.readBytes(bytes, 0, stream.bytesAvailable);
						stream.close();
						if (unCompress)
							bytes.uncompress();
						asyncFunc(bytes);
					});
					stream.openAsync(file, SFileManager.FileMode.READ);

//					_stream.addEventListener(IOErrorEvent.IO_ERROR, ioError);
//					private function ioError(e : Event) : void
//					{
//						log.fatal("ioError " + e);
//						this.dispatchEvent(e);
//					}
				}
			}
			catch (e : Error)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(e, "读取文件%s出错，%s", nativePath, e.message);
			}
			return bytes;
		}

		/**路径是否存在*/
		public static function pathExists(path : String) : Boolean
		{
			SFileManager.getInstance();
			var file : Object = new SFileManager.File(formatPath(path));
			return file.exists;
		}

		/**拷贝文件*/
		public static function copyPath(from : String, to : String) : void
		{
			var fromFile : Object = new SFileManager.File(formatPath(from));
			var toFile : Object = new SFileManager.File(formatPath(to));
			fromFile.copyTo(toFile, true);
		}

		/**重命名文件*/
		public static function renamePath(from : String, to : String) : void
		{
			var fromFile : Object = new SFileManager.File(formatPath(from));
			to = from.replace(/[^\/]+$/g, "") + to;
			var toFile : Object = new SFileManager.File(formatPath(to));
			fromFile.moveTo(toFile, true);
		}

		/**创建文件夹*/
		public static function createFolder(path : String) : void
		{
			var file : Object = new SFileManager.File(formatPath(path));
			file.createDirectory();
		}

		/**删除路径*/
		public static function deletePath(path : String) : void
		{
			var file : Object = new SFileManager.File(formatPath(path));
			if (!file.exists)
				return;
			if (file.isDirectory)
			{
				file.deleteDirectory(true);
			}
			else
			{
				file.deleteFile();
			}
		}

		/**获得子文件夹*/
		public static function getSubFolders(path : String) : Array
		{
			var file : Object = new SFileManager.File(formatPath(path));
			var folders : Array = [];
			var arr : Array = file.getDirectoryListing();
			for (var i : int = 0; i < arr.length; i++)
			{
				var f : Object = arr[i];
				if (f.isDirectory)
					folders.push(f.name);
			}
			return folders;
		}

		/**获得子文件*/
		public static function getSubFiles(path : String) : Array
		{
			var file : Object = new SFileManager.File(formatPath(path));
			var files : Array = [];
			var arr : Array = file.getDirectoryListing();
			for (var i : int = 0; i < arr.length; i++)
			{
				var f : Object = arr[i];
				if (!f.isDirectory)
					files.push(f.name);
			}
			return files;
		}

		/**获得文件大小*/
		public static function getFileSize(path : String) : int
		{
			var file : Object = new SFileManager.File(formatPath(path));
			return file.size;
		}

		/**获得文件修改时间*/
		public static function getModifyDate(path : String) : Date
		{
			var file : Object = new SFileManager.File(formatPath(path));
			if (!file.exists)
				return null;
			return file.modificationDate;
		}

		//格式化路径
		private static function formatPath(path : String) : String
		{
			if (!RegExp(/^\w\:/).test(path) && path.indexOf("\"") != 0)
			{
				path = SResourceManager.getInstance().rootPath + "/" + path;
			}
			return path;
		}

		/**读取文本文件*/
		public static function readFile(path : String, charSet : String = "utf-8") : String
		{
			SFileManager.getInstance();
			var stream : Object = new SFileManager.FileStream();
			var file : Object = new SFileManager.File(formatPath(path));
			if (!file.exists)
				return null;
			stream.open(file, SFileManager.FileMode.READ);
			var bytes : ByteArray = new ByteArray();
			stream.readBytes(bytes);
			if (bytes[0] == 239 && bytes[1] == 187 && bytes[2] == 191)
			{
				stream.position = 3;
			}
			else
			{
				stream.position = 0;
			}
			var str : String = stream.readMultiByte(stream.bytesAvailable, charSet);
			stream.close();
			return str;
		}

		/**保存文本文件*/
		public static function writeFile(path : String, content : String, charSet : String = "utf-8") : void
		{
			SFileManager.getInstance();
			var stream : Object = new SFileManager.FileStream();
			var file : Object = new SFileManager.File(formatPath(path));
			stream.open(file, SFileManager.FileMode.WRITE);
			stream.writeMultiByte(content, charSet);
			stream.close();
		}

		/**读取二进制文件*/
		public static function readByteFile(path : String) : ByteArray
		{
			SFileManager.getInstance();
			var stream : Object = new SFileManager.FileStream();
			var file : Object = new SFileManager.File(formatPath(path));
			stream.open(file, SFileManager.FileMode.READ);
			var bytes : ByteArray = new ByteArray();
			stream.readBytes(bytes);
			stream.close();
			return bytes;
		}

		/**保存二进制文件*/
		public static function writeByteFile(path : String, bytes : ByteArray) : void
		{
			SFileManager.getInstance();
			var stream : Object = new SFileManager.FileStream();
			var file : Object = new SFileManager.File(formatPath(path));
			stream.open(file, SFileManager.FileMode.WRITE);
			stream.writeBytes(bytes);
			stream.close();
		}

		/**文件未尾写入int字节*/
		public static function writeLastBytes(path : String, a : Array) : void
		{
			var bytes : ByteArray = readByteFile(path);
			bytes.position = bytes.length;
			for (var i : int = 0; i < a.length; i++)
			{
				bytes.writeInt(a[i]);
			}
			writeByteFile(path, bytes);
		}

		/**读取文件未尾int字节*/
		public static function readLastBytes(path : String, length : int = 1) : Array
		{
			var bytes : ByteArray = readByteFile(path);
			var a : Array = [];
			for (var i : int = 0; i < length; i++)
			{
				var n : int = length - i - 1;
				var v : int = bytes[bytes.length - 1 - n * 4];
				v = (bytes[bytes.length - 2 - n * 4] << 8) | v;
				v = (bytes[bytes.length - 3 - n * 4] << 16) | v;
				v = (bytes[bytes.length - 4 - n * 4] << 24) | v;
				a.push(v);
			}
			return a;
		}

		/**运行文件*/
		public static function runFile(path : String) : void
		{
			SFileManager.getInstance();
			var file : Object = new SFileManager.File(formatPath(path));
			file.openWithDefaultApplication();
		}

		/**运行dos命令*/
		public static function runDos(cmd : String, funcEcho : Function = null) : void
		{
			var code : String = "set ws=WScript.createObject(\"WScript.Shell\")\n";
			var a : Array = cmd.split("\n");
			for (var i : int = 0; i < a.length; i++)
			{
				var s : String = a[i];
				if (!s)
					continue;
				code += "ws.run unescape(\"" + escape(s) + "\"),0,true\n";
			}
			runVbs(code, funcEcho);
		}

		//执行vbs
		public static function runVbs(code : String, funcEcho : Function) : void
		{
			code += "set fso=createobject(\"Scripting.FileSystemObject\")\n" + "set f=fso.getfile(\"" + SResourceManager.getInstance().rootPath + "/" + "run.vbs" + "\")\n" + "f.attributes=0\n" + "f.delete()";
			writeFile(SResourceManager.getInstance().rootPath + "/" + "run.vbs", code);
			runFile(SResourceManager.getInstance().rootPath + "/" + "run.vbs");
			waitRunDos(funcEcho);
		}

		//等待vbs执行成功
		private static function waitRunDos(funcEcho : Function) : void
		{
			if (pathExists(SResourceManager.getInstance().rootPath + "/" + "run.vbs"))
			{
				setTimeout(waitRunDos, 30, funcEcho);
				return;
			}
			if (funcEcho != null)
				funcEcho();
		}
	}
}