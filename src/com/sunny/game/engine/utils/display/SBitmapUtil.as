package com.sunny.game.engine.utils.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * <p>
	 * SunnyGame的位图工具
	 * 位图处理相关方法
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
	public final class SBitmapUtil
	{
		public function SBitmapUtil()
		{
		}

		/**
		 *	把 ByteArray装换成DisplayObject
		 * @param byteArray
		 * @param callBack
		 *
		 */
		public static function toDisplayObject(byteArray : ByteArray, callBack : Function) : void
		{
			if (byteArray == null)
			{
				if (callBack != null)
				{
					callBack.call(null, null);
				}
				return;
			}

			var loader : Loader = new Loader();
			var onCompleteHandler : Function = function(event : Event) : void
			{
				var loaderInfo : LoaderInfo = event.currentTarget as LoaderInfo;
				var content : DisplayObject = loaderInfo.content;
				loaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoErrorHandler);

				if (callBack != null)
				{
					callBack.call(null, content);
				}
				loader = null;
			}
			var onIoErrorHandler : Function = function(event : IOErrorEvent) : void
			{
				var loaderInfo : LoaderInfo = event.currentTarget as LoaderInfo;
				loaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoErrorHandler);
				trace(getQualifiedClassName(this) + ".toDisplayObject() :" + event.text);
				if (callBack != null)
				{
					callBack.call(null, null);
				}
			}
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoErrorHandler);
			loader.loadBytes(byteArray);
		}

		public static function getRandomBitmapData(width : int = 512, height : int = 512) : BitmapData
		{
			// Generate BMP
			var s : Shape = new Shape();
			for (var i : int = 0; i < 1000; i++)
			{
				s.graphics.lineStyle(Math.random() * 5, Math.random() * 0xffffff);
				s.graphics.moveTo(Math.random() * width, Math.random() * height);
				s.graphics.curveTo(Math.random() * width, Math.random() * height, Math.random() * width, Math.random() * height);
			}
			var canvas : BitmapData = new BitmapData(width, height, false, Math.random() * 0xffffff);
			canvas.draw(s);

			return canvas;
		}

		/**
		 * 向右旋转90度
		 * @param bmp
		 * @return
		 *
		 */
		public static function scaleRight(bmp : BitmapData) : BitmapData
		{
			var m : Matrix = new Matrix();
			m.rotate(Math.PI / 2);
			m.translate(bmp.height, 0);
			var bd : BitmapData = new BitmapData(bmp.height, bmp.width, true, 0);
			bd.draw(bmp, m);
			return bd;
		}

		/**
		 * 向左旋转90度
		 * @param bmp
		 * @return
		 *
		 */
		public static function scaleLeft(bmp : BitmapData) : BitmapData
		{
			var m : Matrix = new Matrix();
			m.rotate(-Math.PI / 2);
			m.translate(0, bmp.width);
			var bd : BitmapData = new BitmapData(bmp.height, bmp.width, true, 0);
			bd.draw(bmp, m);
			return bd;
		}

		/**
		 * 绘制并创建一个位图。这个位图能确保容纳整个图像。
		 *
		 * @param displayObj
		 * @return
		 *
		 */
		public static function drawToBitmap(displayObj : DisplayObject, transparent : Boolean = true, fillColor : uint = 0x0, extend : int = 0) : BitmapData
		{
			var rect : Rectangle = displayObj.getBounds(displayObj);
			if (rect.width > 0 && rect.height > 0)
			{
				var m : Matrix = new Matrix();
				m.translate(-rect.x + extend, -rect.y + extend);
				var bitmap : BitmapData = new BitmapData(Math.ceil(rect.width) + extend + extend, Math.ceil(rect.height) + extend + extend, transparent, fillColor);
				bitmap.draw(displayObj, m);
				return bitmap;
			}
			return null;
		}

		/**
		 * 用绘制的位图替换原来的显示对象，保持原来的坐标
		 * @param displayObj
		 * @return
		 *
		 */
		public static function replaceWithBitmap(displayObj : DisplayObject, pixelSnapping : String = "auto", smoothing : Boolean = false, extend : int = 0) : Bitmap
		{
			var bitmap : Bitmap = new Bitmap(drawToBitmap(displayObj, true, 0, extend), pixelSnapping, smoothing);
			var rect : Rectangle = displayObj.getBounds(displayObj);
			bitmap.x = displayObj.x + rect.x - extend;
			bitmap.y = displayObj.y + rect.y - extend;
			return bitmap;
		}

		/**
		 * 缩放绘制位图填充某个区域
		 * @param source
		 * @param target
		 * @param targetRect
		 * @param smoothing 平滑
		 */
		public static function drawToRectangle(source : IBitmapDrawable, target : BitmapData, targetRect : Rectangle, smoothing : Boolean = false) : void
		{
			var m : Matrix = new Matrix();
			m.createBox(targetRect.width / source["width"], targetRect.height / source["height"], 0, targetRect.x, targetRect.y);
			target.draw(source, m, null, null, null, smoothing);
		}

		/**
		 * 缩放BitmapData
		 *
		 * @param source
		 * @param scaleX
		 * @param scaleY
		 * @return
		 *
		 */
		public static function scale(source : BitmapData, scaleX : Number = 1.0, scaleY : Number = 1.0, disposeSource : Boolean = true) : BitmapData
		{
			var result : BitmapData = new BitmapData(source.width * scaleX, source.height * scaleY, source.transparent, 0xFFFFFF);
			var m : Matrix = new Matrix();
			m.scale(scaleX, scaleY);
			result.draw(source, m);
			if (disposeSource)
				source.dispose()
			return result;
		}

		/**
		 * 水平翻转
		 */
		public static function flipH(source : BitmapData, disposeSource : Boolean = true) : BitmapData
		{
			var result : BitmapData = new BitmapData(source.width, source.height, source.transparent, 0xFFFFFF);
			var m : Matrix = new Matrix();
			m.a = -m.a;
			m.tx = source.width;
			result.draw(source, m);
			if (disposeSource)
				source.dispose()
			return result;
		}

		/**
		 * 垂直翻转
		 */
		public static function flipV(source : BitmapData, disposeSource : Boolean = true) : BitmapData
		{
			var result : BitmapData = new BitmapData(source.width, source.height, source.transparent, 0xFFFFFF);
			var m : Matrix = new Matrix();
			m.d = -m.d;
			m.ty = source.height;
			result.draw(source, m);
			if (disposeSource)
				source.dispose()
			return result;
		}

		/**
		 * 截取BitmapData
		 *
		 * @param source
		 * @param clipRect
		 * @return
		 *
		 */
		public static function clip(source : BitmapData, clipRect : Rectangle, disposeSource : Boolean = true) : BitmapData
		{
			var result : BitmapData = new BitmapData(clipRect.width, clipRect.height, source.transparent, 0xFFFFFF);
			result.copyPixels(source, clipRect, new Point());
			if (disposeSource)
				source.dispose()
			return result;
		}

		/**
		 * 获得位图有像素的范围
		 *
		 * @param source
		 * @return
		 *
		 */
		public static function getSoildRect(source : BitmapData) : Rectangle
		{
			var mask : BitmapData = source.clone();
			mask.threshold(mask, mask.rect, new Point(), ">", 0, 0xFFFFFFFF, 0xFFFFFFFF);
			var clipRect : Rectangle = mask.getColorBoundsRect(0xFFFFFFFF, 0xFFFFFFFF, true);
			mask.dispose();

			return clipRect;
		}

		/**
		 * 清除位图内容
		 *
		 * @param source
		 *
		 */
		public static function clear(source : BitmapData) : void
		{
			source.fillRect(source.rect, 0);
		}

		/**
		 * 获取位图的非透明区域，可以用来做图片按钮的hitArea区域
		 *
		 * @param source	图像源
		 * @return
		 *
		 */
		public static function getMask(source : BitmapData) : Shape
		{
			var s : Shape = new Shape();
			s.graphics.beginFill(0);
			for (var i : int = 0; i < source.width; i++)
			{
				for (var j : int = 0; j < source.height; j++)
				{
					if (source.getPixel32(i, j))
						s.graphics.drawRect(i, j, 1, 1);
				}
			}
			s.graphics.endFill();
			return s;
		}

		/**
		 * 回收一个数组内所有的BitmapData
		 *
		 * @param bitmapDatas
		 *
		 */
		public static function dispose(items : Array) : void
		{
			for each (var item : * in items)
			{
				if (item is BitmapData)
					(item as BitmapData).dispose();

				if (item is Bitmap)
				{
					(item as Bitmap).bitmapData.dispose();
					if ((item as Bitmap).parent)
						(item as Bitmap).parent.removeChild(item as Bitmap);
				}
			}
		}
	}
}