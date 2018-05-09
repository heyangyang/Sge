package com.sunny.game.engine.render.base
{
	

	public class SDirectRenderData extends SBaseRenderData
	{
		public function SDirectRenderData()
		{
			super();
		}

		override protected function init() : void
		{
			super.init();
			_bitmap = new SDirectBitmap(null);
			_bitmap.name = "render" + (renderInstance++);
		}
	}
}