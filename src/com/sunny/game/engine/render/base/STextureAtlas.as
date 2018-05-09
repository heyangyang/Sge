package com.sunny.game.engine.render.base
{
	import com.sunny.game.engine.render.interfaces.SIBitmapData;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class STextureAtlas extends TextureAtlas
	{
		private var name : String;

		public function STextureAtlas(texture : Texture, atlasXml : XML = null, name : String = null)
		{
			this.name = name;
			super(texture, atlasXml);
		}

		public function getAnimationFrame(dir : String, frame : int) : SIBitmapData
		{
			return getTexture(name + "," + dir + "," + frame) as SIBitmapData;
		}
	}
}