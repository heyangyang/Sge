package com.sunny.game.engine.fileformat.pak
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.manager.SResourceManager;
	import com.sunny.game.engine.render.interfaces.SIBitmapData;
	import com.sunny.game.engine.resource.SResource;
	
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import starling.base.STextureAtlas;
	import starling.textures.Texture;

	/**
	 * 用于3d动画解析
	 * @author Administrator
	 *
	 */
	public class SDirectAnimationDecoder extends SAnimationDecoder
	{
		private var textureAtlas : STextureAtlas

		public function SDirectAnimationDecoder(id : String, isDirect : Boolean)
		{
			super(id, isDirect);
		}

		/**
		 * 加载atf和xml结合
		 *
		 */
		public function startXtfLoad(ver : String, priority : int) : void
		{
			var resource : SResource = SResourceManager.getInstance().createResource(id);
			if (resource == null)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "资源解析异常，ID为" + id + "的资源不存在！");
				return;
			}
			if (resource.isLoaded)
			{
				SDebug.warningPrint(this, "已经加载了:" + id);
				onXtfLoaded(resource);
				return;
			}

			if (ver)
				resource.setVersion(ver);
			resource.maxTry(3);
			resource.onComplete(onXtfLoaded).onIOError(onResourceIOError).priority(priority).load();
		}

		protected function onXtfLoaded(resource : SResource) : void
		{
			resource.removeCompleteNotify(onXtfLoaded);
			resource.removeIOErrorNotify(onResourceIOError);
			var bytes : ByteArray = resource.getBinary();
			var name : String = bytes.readUTF();
			var len : int = bytes.readUnsignedInt();
			var atf_bytes : ByteArray = new ByteArray();
			bytes.readBytes(atf_bytes, 0, len);
			name = bytes.readUTF();
			len = bytes.readUnsignedInt();
			var xml_bytes : ByteArray = new ByteArray();
			bytes.readBytes(xml_bytes, 0, len);
			var xml : XML = new XML(xml_bytes);
			var texture : Texture = Texture.fromData(atf_bytes);
			textureAtlas = new STextureAtlas(texture, xml);
			atf_bytes.clear();
			xml_bytes.clear();
			bytes.clear();
			System.disposeXML(xml);
			SResourceManager.getInstance().clearResource(resource.id);
			notifyAll();
		}

		public function getDirResult(action : String, index : uint = 0, dir : String = DEFAULT) : SIBitmapData
		{
			if (_isDisposed)
				return null;
			if (textureAtlas)
				return textureAtlas.getAnimationFrame(action, dir, index);
			else
				return getResult(index, dir);
		}

		public function getDirOffest(action : String, index : uint = 0, dir : String = DEFAULT) : Point
		{
			if (_isDisposed)
				return null;
			if (textureAtlas)
				return textureAtlas.getPoint(action, dir, index);
			else
				return getOffest(index, dir);
		}

		override protected function destroy() : void
		{
			super.destroy();
			if (textureAtlas)
			{
				textureAtlas.dispose();
				textureAtlas = null;
			}
		}
	}
}