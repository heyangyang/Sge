package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.crypto.STeaEncrypt;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.lang.utils.SAssert;
	import com.sunny.game.engine.ns.sunny_engine;

	import flash.utils.ByteArray;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个字节数组工具
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
	public class SByteArrayUtil
	{
		private static const header : String = "";
		private static var stamp : Number;
		private static const validity : Number = (new Date(2016, 3, 1, 0, 0, 0, 0)).getTime();

		public function SByteArrayUtil()
		{
		}

		/**
		 * 加密字节
		 * @param bytes
		 * @return
		 *
		 */
		public static function encryptByteArray(bytes : ByteArray, isEncrypt : Boolean = false, isCompressed : Boolean = true) : ByteArray
		{
			var orgBytes : ByteArray = new ByteArray();
			stamp = (new Date()).getTime();
			orgBytes.writeByte(header.length);
			orgBytes.writeMultiByte(header, "UTF-8");
			orgBytes.writeByte(stamp.toString(16).length);
			orgBytes.writeMultiByte(stamp.toString(16), "UTF-8");
			orgBytes.writeByte(validity.toString(16).length);
			orgBytes.writeMultiByte(validity.toString(16), "UTF-8");
			orgBytes.writeBytes(bytes, 0, bytes.length);
			orgBytes.position = 0;
			if (isCompressed)
				orgBytes.compress();
			if (isEncrypt)
			{
				var tempBytes : ByteArray = orgBytes;
				orgBytes = STeaEncrypt.teaEncrypt(orgBytes);
				tempBytes.clear();
			}
			orgBytes.position = 0;
			var newBytes : ByteArray = new ByteArray();
			newBytes.writeBoolean(isCompressed);
			newBytes.writeBoolean(isEncrypt);
			newBytes.writeBytes(orgBytes);
			orgBytes.clear();
			newBytes.position = 0;
			if (stamp > validity)
			{
				newBytes = null;
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(bytes, "试图写入的文件已过期！");
			}
			SAssert.checkNull(newBytes);
			return newBytes;
		}

		/**
		 * 解密字节
		 * @param bytes
		 * @return
		 *
		 */
		public static function decryptByteArray(bytes : ByteArray) : ByteArray
		{
			var newBytes : ByteArray = new ByteArray();
			newBytes.writeBytes(bytes, 0, bytes.length);
			newBytes.position = 0;
			var isCompressed : Boolean = newBytes.readBoolean();
			var isEncrypt : Boolean = newBytes.readBoolean();
			var orgBytes : ByteArray = new ByteArray();
			newBytes.readBytes(orgBytes);
			newBytes.clear();
			if (isEncrypt)
				orgBytes = STeaEncrypt.teaDecrypt(orgBytes);
			if (isCompressed)
				orgBytes.uncompress();
			orgBytes.position = 0;
			var headerL : uint = orgBytes.readByte();
			var headerV : String = orgBytes.readMultiByte(headerL, "UTF-8");
			var stampL : uint = orgBytes.readByte();
			var stampV : Number = parseInt(orgBytes.readMultiByte(stampL, "UTF-8"), 16);
			var validityL : uint = orgBytes.readByte();
			var validityV : Number = parseInt(orgBytes.readMultiByte(validityL, "UTF-8"), 16);
			var tempBytes : ByteArray = orgBytes;
			orgBytes = new ByteArray();
			orgBytes.writeBytes(tempBytes, tempBytes.position, tempBytes.bytesAvailable);
			tempBytes.clear();
			orgBytes.position = 0;
			if (stampV > validityV)
			{
				orgBytes = null;
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(bytes, "试图读取的文件已过期！");
			}
			SAssert.checkNull(orgBytes);
			return orgBytes;
		}

		sunny_engine static function get isValidity() : Boolean
		{
			stamp = (new Date()).getTime();
			var validityTime : Date = new Date();
			validityTime.setTime(validity);
			//SDebug.infoPrint(validityTime, "有效期", validityTime.toString());
			return (stamp < validity);
		}

		/**
		 * 写字符串到字节
		 * @param value
		 * @param charSet
		 * @return
		 *
		 */
		public static function writeStringToBytes(value : String, charSet : String = "UTF-8") : ByteArray
		{
			var bytes : ByteArray = new ByteArray();
			bytes.writeMultiByte(value, charSet);
			return bytes;
		}

		/**
		 * 读字符串
		 * @param value
		 * @param charSet
		 * @return
		 *
		 */
		public static function readStringFromBytes(value : ByteArray, charSet : String = "UTF-8") : String
		{
			var contentStr : String = value.readMultiByte(value.bytesAvailable, charSet);
			return contentStr;
		}
	}
}