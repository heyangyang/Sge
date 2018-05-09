package com.sunny.game.engine.display
{
	import com.sunny.game.engine.core.SITextureElement;
	import com.sunny.game.engine.ns.sunny_ui;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	use namespace sunny_ui;

	/**
	 *
	 * <p>
	 * SunnyGame的一个位图精灵
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
	public class SBitmapSprite extends SSprite
	{
		private var _bitmap : SBitmap;

		public function SBitmapSprite(bmpData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = false)
		{
			super();
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_bitmap = new SBitmap(bmpData, pixelSnapping, smoothing);
			addChild(_bitmap);
		}

		override public function set scale9Grid(rect : Rectangle) : void
		{
			_bitmap.scale9Grid = rect;
		}

		public function set bitmapWidth(value : Number) : void
		{
			_bitmap.width = value;
		}

		public function get bitmapWidth() : Number
		{
			return _bitmap.width;
		}

		public function set bitmapHeight(value : Number) : void
		{
			_bitmap.height = value;
		}

		public function get bitmapHeight() : Number
		{
			return _bitmap.height;
		}

		public function set bitmapData(value : BitmapData) : void
		{
			_bitmap.bitmapData = value;
		}

		public function get bitmapData() : BitmapData
		{
			return _bitmap.bitmapData;
		}

		public function set smoothing(value : Boolean) : void
		{
			_bitmap.smoothing = value;
		}

		public function setTexture(element : SITextureElement) : void
		{
			bitmapData = element.texture as BitmapData;
			scale9Grid = element.scale9Grid;
			smoothing = element.smoothing;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_bitmap)
			{
				_bitmap.destroy();
				_bitmap = null;
			}
			super.destroy();
		}
	}
}