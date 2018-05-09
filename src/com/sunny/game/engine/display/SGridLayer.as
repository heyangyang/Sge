package com.sunny.game.engine.display
{
	import com.sunny.game.engine.core.SMapConfig;
	import com.sunny.game.engine.enum.SGridType;
	import com.sunny.game.engine.ui.SUIStyle;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *
	 * <p>
	 * SunnyGame的一个网格层
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
	public class SGridLayer extends SSprite
	{
		/**
		 * 当前的网格类型 正形或菱形
		 */
		private var gridType : int;
		/**
		 * 要绘制的网格层
		 */
		private var _wireframe : Shape;
		private var _wireframeBitmapData : BitmapData;
		private var _wireframeBitmap : Bitmap;

		private var _gridLineColor : uint = 0x333333; //线条颜色

		public function SGridLayer()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false;
		}


		private var _toolBitmapData : BitmapData;
		private var _toolTxt : TextField;
		private var _toolTxtBitmapData : BitmapData;

		public function drawGridsUseBitMap() : void
		{
			if (!_wireframe)
			{
				_wireframe = new Shape();
				_wireframeBitmap = new Bitmap();
				this.addChild(_wireframeBitmap);
				_wireframe.graphics.lineStyle(1, _gridLineColor);
				_wireframe.graphics.moveTo(0, 0);
				_wireframe.graphics.lineTo(SMapConfig.GRID_WIDTH, 0);
				_wireframe.graphics.moveTo(0, 0);
				_wireframe.graphics.lineTo(0, SMapConfig.GRID_HEIGHT);
				if (_wireframeBitmapData)
					_wireframeBitmapData.dispose();
				_wireframeBitmapData = new BitmapData(_wireframe.width, _wireframe.height, true, 0);
				_wireframeBitmapData.draw(_wireframe);

				_toolTxt = new TextField();
				_toolTxt.defaultTextFormat = new TextFormat(SUIStyle.TEXT_FONT, 12, _gridLineColor);
			}
			if(_toolBitmapData)
				_toolBitmapData.dispose();
			_toolBitmapData = new BitmapData(SMapConfig.validWidth, SMapConfig.validHeight, true, 0);

			//绘制正形网格
			for (var i : int = 0; i <= SMapConfig.getGridRows(); i++)
			{
				for (var j : int = 0; j <= SMapConfig.getGridColumns(SGridType.RECTANGLE); j++)
				{
					_toolBitmapData.copyPixels(_wireframeBitmapData, _wireframeBitmapData.rect, new Point(j * SMapConfig.GRID_WIDTH, i * SMapConfig.GRID_HEIGHT));
					_toolTxt.text = j + "," + i;
					_toolTxt.width = _toolTxt.textWidth + 4;
					_toolTxt.height = _toolTxt.textHeight + 4;
					_toolTxtBitmapData = new BitmapData(_toolTxt.width, _toolTxt.height, true, 0);
					_toolTxtBitmapData.draw(_toolTxt);
					_toolBitmapData.copyPixels(_toolTxtBitmapData, _toolTxtBitmapData.rect, new Point(j * SMapConfig.GRID_WIDTH + 2, i * SMapConfig.GRID_HEIGHT + 2));
				}
			}
			_wireframeBitmap.bitmapData = _toolBitmapData;
		}

		private var _clearFlagData : BitmapData;
		private var _flagData : BitmapData;
		private var _flags : Array;

		public function clearFlags() : void
		{
			if (_flags)
			{
				if (!_clearFlagData)
					_clearFlagData = new BitmapData(SMapConfig.GRID_WIDTH - 2, SMapConfig.GRID_HEIGHT - 2, true, 0);
				for each (var p : Point in _flags)
				{
					_wireframeBitmapData.copyPixels(_clearFlagData, _clearFlagData.rect, new Point(p.x * SMapConfig.GRID_WIDTH + 1, p.y * SMapConfig.GRID_HEIGHT + 1));
				}
				_flags = null;
			}
		}

		public function drawFlag(color : uint, gridX : int, gridY : int) : void
		{
			if (_wireframeBitmapData)
			{
				if (!_flagData)
					_flagData = new BitmapData(SMapConfig.GRID_WIDTH - 2, SMapConfig.GRID_HEIGHT - 2, true, color);
				_wireframeBitmapData.copyPixels(_flagData, _flagData.rect, new Point(gridX * SMapConfig.GRID_WIDTH + 1, gridY * SMapConfig.GRID_HEIGHT + 1));
				if (!_flags)
					_flags = new Array();
				_flags.push(new Point(gridX, gridY));
			}
		}

		public function draeSmallFlag(color : uint, x : int, y : int) : void
		{
			if (_toolBitmapData)
			{
				var flagBd : BitmapData = new BitmapData(SMapConfig.GRID_WIDTH - 10, SMapConfig.GRID_HEIGHT - 10, true, color);
				_toolBitmapData.copyPixels(flagBd, flagBd.rect, new Point(x * SMapConfig.GRID_WIDTH, y * SMapConfig.GRID_HEIGHT));
				flagBd.dispose();
			}
		}

		override public function destroy() : void
		{
			if (_wireframe)
			{
				if (_wireframe.parent)
					_wireframe.parent.removeChild(_wireframe);
				_wireframe = null;
			}
			if (_wireframeBitmap)
			{
				if (_wireframeBitmap.parent)
					_wireframeBitmap.parent.removeChild(_wireframeBitmap);
				_wireframeBitmap = null;
			}
			if (_wireframeBitmapData)
			{
				_wireframeBitmapData.dispose();
				_wireframeBitmapData = null;
			}
			if (_toolBitmapData)
			{
				_toolBitmapData.dispose();
				_toolBitmapData = null;
			}
			_toolTxt = null;
			if (_clearFlagData)
			{
				_clearFlagData.dispose();
				_clearFlagData = null;
			}
			if (_flagData)
			{
				_flagData.dispose();
				_flagData = null;
			}
			_flags = null;
			super.destroy();
		}

		public function drawGrids(gridType : int = 1) : void
		{
			if (!_wireframe)
			{
				_wireframe = new Shape();
				_wireframeBitmap = new Bitmap();
				this.addChild(_wireframeBitmap);
			}

			_wireframe.graphics.clear();
			this.gridType = gridType;

			//绘制网格	
			var mapWidth : int = SMapConfig.validWidth;
			var mapHeight : int = SMapConfig.validHeight;

			_wireframe.graphics.lineStyle(1, _gridLineColor);

			if (gridType == SGridType.RECTANGLE) //正形
			{
				//绘制正形网格
				for (var i : int = 0; i <= SMapConfig.getGridRows(); i++)
				{
					_wireframe.graphics.moveTo(0, i * SMapConfig.GRID_HEIGHT);
					_wireframe.graphics.lineTo(mapWidth, i * SMapConfig.GRID_HEIGHT);
				}

				for (var j : int = 0; j <= SMapConfig.getGridColumns(gridType); j++)
				{
					_wireframe.graphics.moveTo(j * SMapConfig.GRID_WIDTH, 0);
					_wireframe.graphics.lineTo(j * SMapConfig.GRID_WIDTH, mapHeight);
				}
			}
			else //菱形
			{
				//绘制菱形网格
				for (i = 0; i < 2 * SMapConfig.getGridRows(); i += 2) //画坚线
				{
					for (j = 0; j < 2 * SMapConfig.getGridColumns(gridType); j += 2) //画横线
					{
						_wireframe.graphics.moveTo(j * SMapConfig.GRID_WIDTH / 2, (i + 1) * SMapConfig.GRID_HEIGHT / 2);
						_wireframe.graphics.lineTo((j + 1) * SMapConfig.GRID_WIDTH / 2, i * SMapConfig.GRID_HEIGHT / 2);
						_wireframe.graphics.lineTo((j + 2) * SMapConfig.GRID_WIDTH / 2, (i + 1) * SMapConfig.GRID_HEIGHT / 2);
						_wireframe.graphics.lineTo((j + 1) * SMapConfig.GRID_WIDTH / 2, (i + 2) * SMapConfig.GRID_HEIGHT / 2);
						_wireframe.graphics.lineTo(j * SMapConfig.GRID_WIDTH / 2, (i + 1) * SMapConfig.GRID_HEIGHT / 2);
					}
				}
			}
			if (_wireframeBitmapData)
				_wireframeBitmapData.dispose();
			_wireframeBitmapData = new BitmapData(_wireframe.width, _wireframe.height, true, 0);
			_wireframeBitmapData.draw(_wireframe);
			_wireframeBitmap.bitmapData = _wireframeBitmapData;
		}

		private var _mapWidth : int; //地图网格宽度
		private var _mapHeight : int; //地图网格高度

		private var _tilePixelWidth : int; //一个网格的象素宽
		private var _tilePixelHeight : int; //一个网格的象素高
		private var _wHalfTile : int; //网格象素宽的一半
		private var _hHalfTile : int; //网格象素高的一半

		//画制菱形网格
		private function drawGrid(mapWidth : int, mapHeight : int, tilePixelWidth : int, tilePixelHeight : int) : void
		{
			_mapWidth = mapWidth;
			_mapHeight = mapHeight;
			_tilePixelWidth = tilePixelWidth;
			_tilePixelHeight = tilePixelHeight;
			//var row:int = this._mapHeight/this._tilePixelHeight;
			//var col:int = this._mapWidth/this._tilePixelWidth; 

			var col : int = Math.floor(this._mapWidth / this._tilePixelWidth);
			var row : int = Math.round(this._mapHeight / this._tilePixelHeight);

			this._wHalfTile = int(this._tilePixelWidth / 2);
			this._hHalfTile = int(this._tilePixelHeight / 2);

			_wireframe.graphics.lineStyle(1, _gridLineColor, 1);

			var dblMapWidth : int = col * 2 + 1;
			var dblMapHeight : int = row * 2 + 1;
			for (var i : int = 1; i < dblMapWidth; i = i + 2)
			{
				_wireframe.graphics.moveTo(i * this._wHalfTile, 0);
				if (dblMapHeight + i >= dblMapWidth)
				{
					_wireframe.graphics.lineTo(dblMapWidth * this._wHalfTile, (dblMapWidth - i) * this._hHalfTile);
				}
				else
				{
					_wireframe.graphics.lineTo((dblMapHeight + i) * this._wHalfTile, dblMapHeight * this._hHalfTile);
				}

				_wireframe.graphics.moveTo(i * this._wHalfTile, 0);
				if (i <= dblMapHeight)
				{
					_wireframe.graphics.lineTo(0, i * this._hHalfTile);
				}
				else
				{
					_wireframe.graphics.lineTo((i - dblMapHeight) * this._wHalfTile, dblMapHeight * this._hHalfTile); //i-row-1
				}
			}

			for (var j : int = 1; j < dblMapHeight; j = j + 2)
			{
				_wireframe.graphics.moveTo(0, j * this._hHalfTile);
				if (dblMapHeight - j >= dblMapWidth)
				{
					_wireframe.graphics.lineTo(dblMapWidth * this._wHalfTile, (dblMapWidth + j) * this._hHalfTile);
				}
				else
				{
					_wireframe.graphics.lineTo((dblMapHeight - j) * this._wHalfTile, dblMapHeight * this._hHalfTile);
				}
			}

			for (var m : int = 0; m < dblMapHeight; m = m + 2)
			{
				_wireframe.graphics.moveTo(dblMapWidth * this._wHalfTile, m * this._hHalfTile);
				if (dblMapWidth - dblMapHeight + m < 0)
				{
					_wireframe.graphics.lineTo(0, (dblMapWidth + m) * this._hHalfTile);
				}
				else
				{
					_wireframe.graphics.lineTo((dblMapWidth - dblMapHeight + m) * this._wHalfTile, dblMapHeight * this._hHalfTile);
				}
			}
			//重设宽高，滚动条用
			//this.width = col * this._tilePixelWidth;;
			//trace("this.width"+this.width)
			//this.height = (row + 1) * this._tilePixelHeight / 2;
			//trace("this.height"+this.height);	
		}
	}
}