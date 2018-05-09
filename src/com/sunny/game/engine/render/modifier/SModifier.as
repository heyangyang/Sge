package com.sunny.game.engine.render.modifier
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Point;

	/**
	 *
	 * <p>
	 * SunnyGame的一个修改器基类
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
	public class SModifier
	{
		public function SModifier()
		{
			super();
		}

		/**
		 * 这种方法需要重写应用修改一个BitmapData对象
		 * @param data
		 * @param index
		 * @param count
		 * @return
		 *
		 */
		public function modify(data : BitmapData, index : int = 0, count : int = 1) : BitmapData
		{
			return null;
		}

		/**
		 * 绘制一个带滤镜的位图到新位图数据
		 * @param bitmap
		 * @param bitmapData
		 * @return
		 *
		 */
		protected function drawBitmap(bitmap : Bitmap, bitmapData : BitmapData) : BitmapData
		{
			var newBitmap : Bitmap = new Bitmap(new BitmapData(bitmapData.width, bitmapData.height, true, 0));
			newBitmap.bitmapData.draw(bitmap, null, null, BlendMode.NORMAL);
			bitmapData.fillRect(bitmapData.rect, 0);
			bitmapData.copyPixels(newBitmap.bitmapData, newBitmap.bitmapData.rect, new Point(0, 0), null, null, true);
			newBitmap.bitmapData.dispose();
			// return altered bitmapData
			return bitmapData;
		}
	}
}