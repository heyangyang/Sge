package com.sunny.game.engine.render.base
{
	import com.sunny.game.engine.render.interfaces.SIBitmapData;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	import starling.textures.Texture;

	public class SDirectBitmapData extends Texture implements SIBitmapData
	{
		protected var _rect : Rectangle;

		public static function directEmpty(width : Number, height : Number, premultipliedAlpha : Boolean = true, mipMapping : Boolean = true, optimizeForRenderToTexture : Boolean = false, scale : Number = -1, format : String = "bgra", repeat : Boolean = false) : SDirectBitmapData
		{
			return Texture.empty(width, height, premultipliedAlpha, mipMapping, optimizeForRenderToTexture, scale, format, repeat) as SDirectBitmapData;
		}

		public static function fromDirectBitmapData(data : BitmapData, generateMipMaps : Boolean = true, optimizeForRenderToTexture : Boolean = false, scale : Number = 1, format : String = "bgra", repeat : Boolean = false) : SDirectBitmapData
		{
			return Texture.fromBitmapData(data, false, optimizeForRenderToTexture, scale, format, repeat) as SDirectBitmapData;
		}

		public function SDirectBitmapData()
		{
			super();
		}

		public function get rect() : Rectangle
		{
			if (_rect == null)
			{
				_rect = new Rectangle(0, 0, width, height);
			}
			return _rect;
		}

		public function getPixel(x : int, y : int) : uint
		{
			return 0;
		}
	}
}