package com.sunny.game.engine.render.modifier
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	/**
	 *
	 * <p>
	 * SunnyGame的一个反射修改器
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
	public class SReflectionModifier extends SModifier
	{
		public var heightPercentage : int = 60;

		public function SReflectionModifier(heightPercentage : int = 60)
		{
			this.heightPercentage = heightPercentage;
			super();
		}

		override public function modify(data : BitmapData, index : int = 0, count : int = 1) : BitmapData
		{
			var frameBitmap : Bitmap = new Bitmap(data);

			//垂直翻转 flip vertically
			var matrix : Matrix = new Matrix;
			matrix.scale(1, -1);
			matrix.translate(0, data.height);

			// draw onto new canvas
			var bitmapData : BitmapData = new BitmapData(data.width, (data.height / 100) * heightPercentage);
			bitmapData.fillRect(bitmapData.rect, 0);
			bitmapData.draw(frameBitmap, matrix);

			//实现透明 implement transparency
			for (var r : int = 0; r < bitmapData.height; r++)
			{
				var rowFactor : Number = 1 - (r / bitmapData.height);
				for (var j : int = 0; j < bitmapData.width; j++)
				{
					var pixelColor : uint = bitmapData.getPixel32(j, r);
					var pixelAlpha : uint = pixelColor >>> 24;
					var pixelRGB : uint = pixelColor & 0xffffff;
					var resultAlpha : uint = pixelAlpha * rowFactor;
					bitmapData.setPixel32(j, r, resultAlpha << 24 | pixelRGB);
				}
			}
			return bitmapData;
		}
	}
}