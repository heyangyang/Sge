package com.sunny.game.engine.render
{
	import com.sunny.game.engine.lang.SReference;
	import com.sunny.game.engine.render.base.SDirectBitmapData;
	import com.sunny.game.engine.render.base.SNormalBitmapData;
	import com.sunny.game.engine.render.interfaces.SIBitmapData;
	
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class SBitmapDataReference extends SReference
	{
		private var data : SIBitmapData;
		private var isDirect : Boolean;

		public function SBitmapDataReference(width : int, height : int, transparent : Boolean = true, fillColor : uint = 4.294967295E9, isDirect : Boolean = false)
		{
			super();
			this.isDirect = isDirect;
			data = new SNormalBitmapData(width, height, transparent, fillColor);
		}


		public function draw(source : IBitmapDrawable, matrix : Matrix = null, colorTransform : ColorTransform = null, blendMode : String = null, clipRect : Rectangle = null, smoothing : Boolean = false) : void
		{
			SNormalBitmapData(data).draw(source, matrix, colorTransform, blendMode, clipRect, smoothing);
		}

		public function get bitmapData() : SIBitmapData
		{
			if (isDirect && data is SNormalBitmapData)
			{
				var tmp : SIBitmapData = data;
				data = SDirectBitmapData.fromDirectBitmapData(data as SNormalBitmapData);
				tmp.dispose();
			}
			return data;
		}

		override protected function destroy() : void
		{
			super.destroy();
			if (data)
				data.dispose();
			data = null;
		}

	}
}