package com.sunny.game.engine.weather
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 *
	 * <p>
	 * SunnyGame的天气-雾
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
	public class SFog extends SWeather
	{
		public var numOctaves : int;
		public var skyColor : uint;
		public var cloudsHeight : int;
		public var cloudsWidth : int;
		public var periodX : Number;
		public var periodY : Number;
		public var scrollAmountX : int;
		public var scrollAmountY : int;
		public var maxScrollAmount : int;

		private var cloudsBitmapData : BitmapData;
		private var cloudsBitmap : Bitmap;
		private var cmf : ColorMatrixFilter;
		private var blueBackground : Shape;
		private var displayWidth : int;
		private var displayHeight : int;
		private var seed : int;
		private var offsets : Array;
		private var sliceDataH : BitmapData;
		private var sliceDataV : BitmapData;
		private var sliceDataCorner : BitmapData;
		private var horizCutRect : Rectangle;
		private var vertCutRect : Rectangle;
		private var cornerCutRect : Rectangle;
		private var horizPastePoint : Point;
		private var vertPastePoint : Point;
		private var cornerPastePoint : Point;
		private var originPoint : Point = new Point();

		public function SFog(parent : Sprite, viewRect : Rectangle, level : int = 1, useBG : Boolean = true, col : uint = 0x2255aa)
		{
			super(parent, viewRect, level);

			name = "雾";

			skyColor = col;
			periodX = periodY = 150;
			scrollAmountX = -1;
			scrollAmountY = 2;
			maxScrollAmount = _maxDelta;
			numOctaves = 5;

			cloudsBitmap = new Bitmap(cloudsBitmapData);
			this.addChild(cloudsBitmap);

			var matrix : Array = new Array();
			matrix = matrix.concat([0, 0, 0, 0, 255]); // red
			matrix = matrix.concat([0, 0, 0, 0, 255]); // green
			matrix = matrix.concat([0, 0, 0, 0, 255]); // blue
			matrix = matrix.concat([0.5, 0, 0, 0, 0]); // alpha

//			matrix = matrix.concat([0.5, 0.5, 0.5, 0, 0]); // red
//			matrix = matrix.concat([0, 0, 0, 0, 255]); // green
//			matrix = matrix.concat([0, 0, 0, 0, 255]); // blue
//			matrix = matrix.concat([0.7, 0, 0, 0, 0]); // alpha

			cmf = new ColorMatrixFilter(matrix);
			resize(_viewRect.width, _viewRect.height);
			validuateChange();
		}

		override protected function validuateChange() : void
		{
			super.validuateChange();
			cloudsBitmap.scrollRect = _viewRect;
			if (cloudsBitmapData)
			{
				cloudsBitmapData.dispose();
			}
			displayWidth = _viewRect.width;
			displayHeight = _viewRect.height;
			//using a factor of 1.5 below makes the cloud pattern larger than the display, so that the repetition
			//of the wrapped clouds during scrolling is not as apparent.
			cloudsWidth = Math.floor(displayWidth + 50);
			cloudsHeight = Math.floor(displayHeight + 50);

			cloudsBitmapData = new BitmapData(cloudsWidth, cloudsHeight, true, 0);
			cloudsBitmap.bitmapData = cloudsBitmapData;
			makeClouds();
			setRectangles();
		}

		private function setRectangles() : void
		{
			//clamp scroll amounts
			scrollAmountX = (scrollAmountX > maxScrollAmount) ? maxScrollAmount : ((scrollAmountX < -maxScrollAmount) ? -maxScrollAmount : scrollAmountX);
			scrollAmountY = (scrollAmountY > maxScrollAmount) ? maxScrollAmount : ((scrollAmountY < -maxScrollAmount) ? -maxScrollAmount : scrollAmountY);

			if (scrollAmountX != 0)
			{
				sliceDataV = new BitmapData(maxScrollAmount, cloudsHeight, true, 0);
			}
			if (scrollAmountY != 0)
			{
				sliceDataH = new BitmapData(cloudsWidth, maxScrollAmount, true, 0);
			}
			if ((scrollAmountX != 0) && (scrollAmountY != 0))
			{
				sliceDataCorner = new BitmapData(maxScrollAmount, maxScrollAmount, true, 0);
			}

			horizCutRect = new Rectangle(0, cloudsHeight - scrollAmountY, cloudsWidth - Math.abs(scrollAmountX), Math.abs(scrollAmountY));
			vertCutRect = new Rectangle(cloudsWidth - scrollAmountX, 0, Math.abs(scrollAmountX), cloudsHeight - Math.abs(scrollAmountY));
			cornerCutRect = new Rectangle(cloudsWidth - scrollAmountX, cloudsHeight - scrollAmountY, Math.abs(scrollAmountX), Math.abs(scrollAmountY));

			horizPastePoint = new Point(scrollAmountX, 0);
			vertPastePoint = new Point(0, scrollAmountY);
			cornerPastePoint = new Point(0, 0);

			if (scrollAmountX < 0)
			{
				cornerCutRect.x = vertCutRect.x = 0;
				cornerPastePoint.x = vertPastePoint.x = cloudsWidth + scrollAmountX;
				horizCutRect.x = -scrollAmountX;
				horizPastePoint.x = 0;
			}
			if (scrollAmountY < 0)
			{
				cornerCutRect.y = horizCutRect.y = 0;
				cornerPastePoint.y = horizPastePoint.y = cloudsHeight + scrollAmountY;
				vertCutRect.y = -scrollAmountY;
				vertPastePoint.y = 0;
			}

			_verPasteRect.width = vertCutRect.width = _cornerPasteRect.width = cornerCutRect.width = Math.abs(scrollAmountX);
			_verPasteRect.height = vertCutRect.height = cloudsHeight - Math.abs(scrollAmountY);
			_horPasteRect.width = horizCutRect.width = cloudsWidth - Math.abs(scrollAmountX);
			_horPasteRect.height = horizCutRect.height = _cornerPasteRect.height = cornerCutRect.height = Math.abs(scrollAmountY);
		}

		private function makeClouds() : void
		{
			seed = int(Math.random() * 0xFFFFffff);

			//create offsets array:
			offsets = new Array();
			for (var i : int = 0; i <= numOctaves - 1; i++)
			{
				offsets.push(new Point());
			}

			//draw clouds
			cloudsBitmapData.perlinNoise(periodX, periodY, numOctaves, seed, true, true, 1, true, offsets);
			cloudsBitmapData.applyFilter(cloudsBitmapData, cloudsBitmapData.rect, new Point(), cmf);

		}

		private var _verPasteRect : Rectangle = new Rectangle();
		private var _horPasteRect : Rectangle = new Rectangle();
		private var _cornerPasteRect : Rectangle = new Rectangle();

		override public function update() : void
		{
			if (!_visible || !isRunning)
				return;

			super.update();

			var scrollX : int = scrollAmountX - _deltaOffsetX;
			var scrollY : int = scrollAmountY - _deltaOffsetY;

			//copy to buffers the part that will be cut off
			if (scrollX < 0)
			{
				cornerCutRect.x = vertCutRect.x = 0;
				cornerPastePoint.x = vertPastePoint.x = cloudsWidth + scrollX;
				horizCutRect.x = -scrollX;
				horizPastePoint.x = 0;
			}
			else
			{
				cornerCutRect.x = vertCutRect.x = cloudsWidth - scrollX;
				cornerPastePoint.x = vertPastePoint.x = 0;
				horizCutRect.x = 0;
				horizPastePoint.x = scrollX;
			}
			if (scrollY < 0)
			{
				cornerCutRect.y = horizCutRect.y = 0;
				cornerPastePoint.y = horizPastePoint.y = cloudsHeight + scrollY;
				vertCutRect.y = -scrollY;
				vertPastePoint.y = 0;
			}
			else
			{
				cornerCutRect.y = horizCutRect.y = cloudsHeight - scrollY;
				cornerPastePoint.y = horizPastePoint.y = 0;
				vertCutRect.y = 0;
				vertPastePoint.y = scrollY;
			}
			_verPasteRect.width = vertCutRect.width = _cornerPasteRect.width = cornerCutRect.width = Math.abs(scrollX);
			_verPasteRect.height = vertCutRect.height = cloudsHeight - Math.abs(scrollY);
			_horPasteRect.width = horizCutRect.width = cloudsWidth - Math.abs(scrollX);
			_horPasteRect.height = horizCutRect.height = _cornerPasteRect.height = cornerCutRect.height = Math.abs(scrollY);

			cloudsBitmapData.lock();
			if (scrollX != 0)
				sliceDataV.copyPixels(cloudsBitmapData, vertCutRect, originPoint);
			if (scrollY != 0)
			{
				sliceDataH.copyPixels(cloudsBitmapData, horizCutRect, originPoint);
			}
			if ((scrollX != 0) && (scrollY != 0))
			{
				sliceDataCorner.copyPixels(cloudsBitmapData, cornerCutRect, originPoint);
			}
			//scroll
			cloudsBitmapData.scroll(scrollX, scrollY);

			//draw the buffers on the opposite sides
			if (scrollX != 0)
			{
				cloudsBitmapData.copyPixels(sliceDataV, _verPasteRect, vertPastePoint);
			}
			if (scrollY != 0)
			{
				cloudsBitmapData.copyPixels(sliceDataH, _horPasteRect, horizPastePoint);
			}
			if ((scrollX != 0) && (scrollY != 0))
			{
				cloudsBitmapData.copyPixels(sliceDataCorner, _cornerPasteRect, cornerPastePoint);
			}

			cloudsBitmapData.unlock();

			_deltaOffsetX = 0;
			_deltaOffsetY = 0;
		}

		override public function toString() : String
		{
			return 'Fog error';
		}

		override public function destroy() : void
		{
			if (cloudsBitmap)
			{
				this.removeChild(cloudsBitmap);
				cloudsBitmapData.dispose();
				cloudsBitmapData = null;

				sliceDataV.dispose();
				sliceDataV = null;
				sliceDataCorner.dispose();
				sliceDataCorner = null;
				sliceDataH.dispose();
				sliceDataH = null;
				cloudsBitmap = null;
			}
			super.destroy();
		}
	}

}
