package com.sunny.game.engine.map
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.events.SThreadEvent;
	import com.sunny.game.engine.loader.SLoadPriorityType;
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.parser.SPakResourceParser;
	import com.sunny.game.engine.render.base.SDirectBitmap;
	import com.sunny.game.engine.render.base.SDirectBitmapData;
	import com.sunny.game.engine.render.base.SNormalBitmap;
	import com.sunny.game.engine.render.interfaces.SIBitmap;
	
	import flash.display.BitmapData;
	
	import starling.textures.TextureSmoothing;

	/**
	 *
	 * <p>
	 * SunnyGame的地图资源解析器
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
	public class SMapResourceParser extends SPakResourceParser
	{
		private var _bitmap : SIBitmap;

		public function SMapResourceParser(id : String, version : String = null, priority : int = SLoadPriorityType.MAP)
		{
			super(id, version, priority);
		}

		override protected function loadThreadResource() : void
		{
			decoder = SReferenceManager.getInstance().createDirectAnimationDeocder(_id, _isDirect);
			if (_decoder.isCompleted)
				parseComplete(_decoder);
			else
				_decoder.addNotify(parseComplete);
			if (!_decoder.isSend)
			{
				_decoder.isSend = true;
				var send_arr : Array = [_id, version, priority];
				SThreadEvent.dispatchEvent(SThreadEvent.LOAD_SEND, send_arr);
			}
		}

		public function get bitmapData() : BitmapData
		{
			if (_isDisposed) //已经被取消了
				return null;
			if (_decoder)
				return _decoder.getResult();
			return null;
		}

		public function get bitmap() : SIBitmap
		{
			if (_bitmap)
				return _bitmap;
			if (SShellVariables.supportDirectX)
			{
				_bitmap = new SDirectBitmap(SDirectBitmapData.fromDirectBitmapData(bitmapData));
				SDirectBitmap(_bitmap).smoothing = TextureSmoothing.NONE;
			}
			else
				_bitmap = new SNormalBitmap(bitmapData);
			return _bitmap;
		}

		public function clearBitmap() : void
		{
			_bitmap && _bitmap.removeChild(true);
		}

		override protected function destroy() : void
		{
			super.destroy();
			clearBitmap();
			_bitmap = null;
		}
	}
}