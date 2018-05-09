package com.sunny.game.engine.display
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.events.SICaller;
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 *
	 * <p>
	 * SunnyGame的一个位图
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
	public class SBitmap extends Bitmap implements SIDestroy
	{
		// ------------------------------------------------
		//
		// ---o properties
		//
		// ------------------------------------------------

		protected var _originalBitmap : BitmapData;
		protected var _scale9Grid : Rectangle = null;

		// ------------------------------------------------
		//
		// ---o constructor
		//
		// ------------------------------------------------

		protected var _isDisposed : Boolean;

		public function SBitmap(bmpData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = false)
		{
			_isDisposed = false;
			// original bitmap
			_originalBitmap = bmpData;
			// super constructor
			super(_originalBitmap ? _originalBitmap.clone() : null, pixelSnapping, smoothing);
		}

		// ------------------------------------------------
		//
		// ---o public methods
		//
		// ------------------------------------------------

		/**
		 * setter bitmapData
		 */
		override public function set bitmapData(bmpData : BitmapData) : void
		{
			_originalBitmap = bmpData;
			if (_scale9Grid != null)
			{
				if (!validGrid(_scale9Grid))
				{
					_scale9Grid = null;
					assignBitmapData(_originalBitmap ? _originalBitmap.clone() : null);
				}
				else
					setSize(bmpData.width, bmpData.height);
			}
			else
			{
				assignBitmapData(_originalBitmap ? _originalBitmap.clone() : null);
			}
		}

		/**
		 * setter width
		 */
		override public function set width(w : Number) : void
		{
			if (w != width)
			{
				setSize(w, height);
			}
		}

		/**
		 * setter height
		 */
		override public function set height(h : Number) : void
		{
			if (h != height)
			{
				setSize(width, h);
			}
		}

		/**
		 * set scale9Grid
		 */
		override public function set scale9Grid(rect : Rectangle) : void
		{
			// Check if the given grid is different from the current one
			if ((!_scale9Grid && rect) || (_scale9Grid && (!rect || (rect && !_scale9Grid.equals(rect)))))
			{
				if (rect == null)
				{
					// If deleting scalee9Grid, restore the original bitmap
					// then resize it (streched) to the previously set dimensions
					var currentWidth : Number = width;
					var currentHeight : Number = height;
					_scale9Grid = null;
					setSize(currentWidth, currentHeight);
				}
				else
				{
					if (!validGrid(rect))
					{
						SDebug.warningPrint(this, "scale9grid不匹配的原始位图数据！");
						return;
					}

					_scale9Grid = rect.clone();
					resizeBitmap(width, height);
					scaleX = 1;
					scaleY = 1;
				}
			}
		}

		/**
		 * assignBitmapData
		 * Update the effective bitmapData
		 */
		private function assignBitmapData(bmp : BitmapData) : void
		{
			if (super.bitmapData)
			{
				super.bitmapData.dispose();
				super.bitmapData = null;
			}
			super.bitmapData = bmp;
		}

		private function validGrid(r : Rectangle) : Boolean
		{
			if (_originalBitmap)
				return r.right <= _originalBitmap.width && r.bottom <= _originalBitmap.height;
			return false;
		}

		/**
		 * get scale9Grid
		 */
		override public function get scale9Grid() : Rectangle
		{
			return _scale9Grid;
		}


		/**
		 * setSize
		 */
		public function setSize(w : Number, h : Number) : void
		{
			if (_scale9Grid == null)
			{
				super.width = w;
				super.height = h;
				assignBitmapData(_originalBitmap ? _originalBitmap.clone() : null);
			}
			else
			{
				if (_originalBitmap)
				{
					w = Math.max(w, _originalBitmap.width - _scale9Grid.width);
					h = Math.max(h, _originalBitmap.height - _scale9Grid.height);
					resizeBitmap(w, h);
				}
			}
		}

		/**
		 * get original bitmap
		 */
		public function getOriginalBitmapData() : BitmapData
		{
			return _originalBitmap;
		}

		// ------------------------------------------------
		//
		// ---o protected methods
		//
		// ------------------------------------------------

		/**
		 * resize bitmap
		 */
		protected function resizeBitmap(w : Number, h : Number) : void
		{
			var bmpData : BitmapData = new BitmapData(w, h, true, 0x00000000);

			var rows : Array = [0, _scale9Grid.top, _scale9Grid.bottom, _originalBitmap.height];
			var cols : Array = [0, _scale9Grid.left, _scale9Grid.right, _originalBitmap.width];

			var dRows : Array = [0, _scale9Grid.top, h - (_originalBitmap.height - _scale9Grid.bottom), h];
			var dCols : Array = [0, _scale9Grid.left, w - (_originalBitmap.width - _scale9Grid.right), w];

			var origin : Rectangle;
			var draw : Rectangle;
			var mat : Matrix = new Matrix();

			for (var cx : int = 0; cx < 3; cx++)
			{
				for (var cy : int = 0; cy < 3; cy++)
				{
					origin = new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
					draw = new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
					mat.identity();
					mat.a = draw.width / origin.width;
					mat.d = draw.height / origin.height;
					mat.tx = draw.x - origin.x * mat.a;
					mat.ty = draw.y - origin.y * mat.d;
					bmpData.draw(_originalBitmap, mat, null, null, draw, smoothing);
				}
			}
			assignBitmapData(bmpData);
		}

		public function clear() : void
		{
			_originalBitmap = null;
			_scale9Grid = null;
			if (super.bitmapData)
			{
				super.bitmapData.dispose();
				super.bitmapData = null;
			}
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			clear();
			if (this.parent)
				this.parent.removeChild(this);
			_isDisposed = true;
		}

		public function get caller() : SICaller
		{
			return null;
		}
	}
}