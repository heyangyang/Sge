package com.sunny.game.engine.render.base
{
	import com.sunny.game.engine.render.interfaces.SIBitmap;
	import com.sunny.game.engine.render.interfaces.SIBitmapData;
	import com.sunny.game.engine.render.interfaces.SIContainer;

	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.textures.Texture;

	public class SDirectBitmap extends Image implements SIBitmap
	{
		private static var nullTexture : SDirectBitmapData

		public function SDirectBitmap(texture : SDirectBitmapData = null)
		{
			if (nullTexture == null)
				nullTexture = SDirectBitmapData.directEmpty(2, 2);
			if (texture == null)
				texture = nullTexture;
			super(texture);
		}

		public function set data(value : SIBitmapData) : void
		{
			if (value == null)
				value = nullTexture;
			if (value is SDirectBitmapData && texture != value)
			{
				this.texture = value as Texture;
				this.readjustSize();
			}
		}

		public function get data() : SIBitmapData
		{
			return texture as SIBitmapData;
		}

		public function set normal_bitmapData(value : BitmapData) : void
		{

		}

		public function get normal_bitmapData() : BitmapData
		{
			return null;
		}


		public function set filters(value : Array) : void
		{

		}

		public function get filters() : Array
		{
			return null;
		}

		public function removeChild(clearMemory : Boolean = false) : void
		{
			parent && parent.removeChild(this);
		}

		public function set colorTransform(value : ColorTransform) : void
		{

		}

		public function get colorTransform() : ColorTransform
		{
			return null;
		}

		public function set scrollRect(rect : Rectangle) : void
		{
			this.x = rect.x;
			this.y = rect.y;
		}

		public function get sparent() : SIContainer
		{
			return parent as SIContainer;
		}

		public function destroy() : void
		{
			removeChild(true);
			if (texture)
				texture.dispose();
		}

	}
}