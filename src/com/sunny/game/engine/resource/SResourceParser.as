package com.sunny.game.engine.resource
{
	import com.sunny.game.engine.loader.SResourceLoader;
	import com.sunny.game.engine.manager.SResourceManager;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.utils.SByteArrayUtil;
	
	import flash.utils.ByteArray;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个根据资源类型资源解析器
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
	public class SResourceParser
	{
		public static function getXML(res : SResource) : XML
		{
			var content : *;
			if (res.getType() == SResourceLoader.TYPE_BINARY)
			{
				var bytes : ByteArray = res.getBinary(true);
				content = XML(bytes.readUTFBytes(bytes.bytesAvailable));
			}
			else
				content = SResourceManager.getInstance().resourceLoader.getXML(res.id, true);

			return content;
		}

		public static function getTxt(res : SResource) : String
		{
			var content : *;
			if (res.getType() == SResourceLoader.TYPE_BINARY)
			{
				var bytes : ByteArray = res.getBinary(true);
				content = bytes.readUTFBytes(bytes.bytesAvailable);
			}
			else
				content = SResourceManager.getInstance().resourceLoader.getText(res.id, true);

			return content;
		}

		public static function getBinary(res : SResource, clearMomery : Boolean = false) : ByteArray
		{
			if (res.isLoaded)
			{
				var bytes : ByteArray = SResourceManager.getInstance().resourceLoader.getBinary(res.id, clearMomery);
				if (bytes)
				{
					if (res.attr['sunnyByteCrypt'])
					{
						bytes = SByteArrayUtil.decryptByteArray(bytes);
					}
				}
				return bytes;
			}
			return null;
		}
	}
}