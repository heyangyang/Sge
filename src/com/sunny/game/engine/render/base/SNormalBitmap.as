package com.sunny.game.engine.render.base
{
	import com.sunny.game.engine.render.interfaces.SIBitmap;
	import com.sunny.game.engine.render.interfaces.SIBitmapData;
	import com.sunny.game.engine.render.interfaces.SIContainer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;

	/**
	 * 用于普通渲染
	 * @author wait
	 *
	 */
	public class SNormalBitmap extends Bitmap implements SIBitmap
	{
		public function SNormalBitmap(bitmapData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}

		public function set normal_bitmapData(value : BitmapData) : void
		{
			this.bitmapData = value;
		}

		public function get normal_bitmapData() : BitmapData
		{
			return this.bitmapData;
		}

		public function set data(value : SIBitmapData) : void
		{
			this.bitmapData = value as BitmapData;
		}

		public function get data() : SIBitmapData
		{
			return bitmapData as SIBitmapData;
		}

		public function removeChild(clearMemory : Boolean = false) : void
		{
			parent && parent.removeChild(this);
		}

		public function set colorTransform(value : ColorTransform) : void
		{
			transform.colorTransform = value;
		}

		public function get colorTransform() : ColorTransform
		{
			return this.transform.colorTransform;
		}

		public function get sparent() : SIContainer
		{
			return parent as SIContainer;
		}

		public function destroy() : void
		{
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
		}
	}
}