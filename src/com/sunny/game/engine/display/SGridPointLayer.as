package com.sunny.game.engine.display
{
	import com.sunny.game.engine.core.SMapConfig;
	import com.sunny.game.engine.data.SGridData;
	import com.sunny.game.engine.enum.SGridType;
	import com.sunny.game.engine.enum.SRoadPointType;
	import com.sunny.game.engine.utils.SArrayUtil;
	import com.sunny.game.engine.utils.SCommonUtil;
	import com.sunny.game.engine.utils.SHashMap;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的一个格子点层
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
	public class SGridPointLayer extends Bitmap
	{
		//地图格类型 空白低点 最后会根据设置 转换为相应不可移动或者可移动区域
		public static const MARK_TYPE_SPACE : int = 0;
		//地图格类型 路点
		public static const MARK_TYPE_ROAD : int = 1;
		//地图格类型 障碍
		public static const MARK_TYPE_HINDER : int = 2;
		//地图格类型 遮挡
		public static const MARK_TYPE_MASK : int = 3;
		//地图格类型 安全区
		public static const MARK_TYPE_SAFE : int = 4;
		//地图格类型 安全区遮挡
		public static const MARK_TYPE_SAFE_MASK : int = 5;
		//地图格类型 跳跃区
		public static const MARK_TYPE_JUMP : int = 6;

		public static const SPACE_TYPE_TO_NONE : int = 0;
		//保存时将空白区域转换为路点
		public static const SPACE_TYPE_TO_ROAD : int = 1;
		//保存时将空白区域转换为障碍
		public static const SPACE_TYPE_TO_HINDER : int = 2;

		//绘制圆形路点标记常量标识
		public static var MARK_CIRCLE : int = 1;
		//绘制正形路点标记常量标识
		public static var MARK_RECTANGLE : int = 2;
		//绘制菱形路点标记常量标识
		public static var MARK_DIAMOND : int = 3;
		//绘制带十字线菱形路点标记常量标识
		public static var MARK_LINE_DIAMOND : int = 4;
		//路点颜色
		public static var ROAD_COLOR : uint = 0x33FF33;
		//障碍点颜色
		public static var HINDER_COLOR : uint = 0xFF0033;
		//遮挡点颜色
		public static var MASK_COLOR : uint = 0x0033FF;
		//PK点颜色
		public static var PK_COLOR : uint = 0xFFFF33;
		//PK遮挡点颜色
		public static var PK_MASK_COLOR : uint = 0xFF33FF;
		//跳跃点颜色
		public static var JUMP_COLOR : uint = 0xFF3300;

		private var _showWalkable : Boolean = false;
		private var _showUnwalkable : Boolean = false;
		private var _showMaskable : Boolean = false;
		private var _showSafe : Boolean = false;
		private var _showJump : Boolean = false;

		//一个HashMap 对象，存储所有标记过的路点 
		private var _markMap : SHashMap;
		//HashMap 对象，存储所有属于建筑物的路点
		private var _buildingPointMap : SHashMap;

		//用来区分当前路点层使用的图形标记是圆形还是菱形
		private var _gridMark : int = MARK_RECTANGLE;
		/**
		 * 缓冲区
		 */
		public var bufferBitmapData : BitmapData;
		//绘制路点图形标记的代理函数
		private var _gridMarkCreater : Function;
		private var _grids : Array;

		public function SGridPointLayer()
		{
			super();
			_markMap = new SHashMap();
			_buildingPointMap = new SHashMap();
			//判断当前路点层使用的图形标记是圆形还是菱形
			setGridMarkShape(_gridMark);
		}

		private function setGridMarkShape(gridMark : int) : void
		{
			switch (gridMark)
			{
				//圆形路点图形标记模式
				case MARK_CIRCLE:
					_gridMarkCreater = drawCircleShape;
					break;
				//正形路点图形标记模式
				case MARK_RECTANGLE:
					_gridMarkCreater = drawRectangleShape;
					break;
				//菱形路点图形标记模式
				case MARK_DIAMOND:
					_gridMarkCreater = drawDiamondShape;
					break;
				//十字线菱形路点图形标记模式
				case MARK_LINE_DIAMOND:
					_gridMarkCreater = drawLineDiamondShape;
					break;
			}
		}

		private function getColorByType(type : int) : uint
		{
			return (type == MARK_TYPE_ROAD) ? ROAD_COLOR : ((type == MARK_TYPE_HINDER) ? HINDER_COLOR : ((type == MARK_TYPE_SAFE) ? PK_COLOR : ((type == MARK_TYPE_SAFE_MASK) ? PK_MASK_COLOR : ((type == MARK_TYPE_JUMP) ? JUMP_COLOR : MASK_COLOR))));
		}

		/**
		 * 建筑编辑器中的障碍
		 * @param type
		 * @param pt
		 * @return
		 *
		 */
		private function drawLineDiamondShape(type : int) : Shape
		{
			var halfWidth : int = Math.ceil(SMapConfig.GRID_WIDTH / 2);
			var halfHeight : int = Math.ceil(SMapConfig.GRID_HEIGHT / 2);

			var cell : Shape = new Shape();
			var cellColor : uint = getColorByType(type);

			//外框
			cell.graphics.lineStyle(1, cellColor, 0.5);
			cell.graphics.moveTo(0, halfHeight);
			cell.graphics.lineTo(halfWidth, 0);
			cell.graphics.lineTo(2 * halfWidth, halfHeight);
			cell.graphics.lineTo(halfWidth, 2 * halfHeight);
			cell.graphics.lineTo(0, halfHeight);
			//里框
			var hoff : int = 2 * halfHeight / 4;
			var woff : int = hoff * (2 * halfWidth) / (2 * halfHeight);
			cell.graphics.moveTo(woff, halfHeight);
			cell.graphics.lineTo(halfWidth, hoff);
			cell.graphics.lineTo(2 * halfWidth - woff, halfHeight);
			cell.graphics.lineTo(halfWidth, 2 * halfHeight - hoff);
			cell.graphics.lineTo(woff, halfHeight);
			//交叉线
			cell.graphics.moveTo(0, halfHeight);
			cell.graphics.lineTo(2 * halfWidth, halfHeight);
			cell.graphics.moveTo(halfWidth, 0);
			cell.graphics.lineTo(halfWidth, 2 * halfHeight);

			cell.width = SMapConfig.GRID_WIDTH;
			cell.height = SMapConfig.GRID_HEIGHT;
			return cell;
		}

		/**
		 * 绘制圆形的路点标记
		 * @param type
		 * @param pt
		 * @return
		 *
		 */
		private function drawCircleShape(type : int) : Shape
		{
			var halfWidth : int = Math.ceil(SMapConfig.GRID_WIDTH / 2);
			var halfHeight : int = Math.ceil(SMapConfig.GRID_HEIGHT / 2);

			var radius : Number = halfHeight;
			var cell : Shape = new Shape();
			var cellColor : uint = getColorByType(type);
			cell.graphics.beginFill(0, 0);
			cell.graphics.drawRect(0, 0, 2 * halfWidth, 2 * halfHeight);
			cell.graphics.endFill();
			cell.graphics.beginFill(cellColor, 0.5);
			cell.graphics.drawCircle(radius + (halfWidth - radius), radius + (halfHeight - radius), radius);
			cell.graphics.endFill();
			cell.width = SMapConfig.GRID_WIDTH;
			cell.height = SMapConfig.GRID_HEIGHT;
			return cell;
		}

		/**
		 * 绘制矩形的路点标记
		 * @param type
		 * @param pt
		 * @return
		 *
		 */
		private function drawRectangleShape(type : int) : Shape
		{
			var halfWidth : int = Math.ceil(SMapConfig.GRID_WIDTH / 2);
			var halfHeight : int = Math.ceil(SMapConfig.GRID_HEIGHT / 2);

			var cell : Shape = new Shape();
			var cellColor : uint = getColorByType(type);
			cell.graphics.beginFill(cellColor, 0.5);
			cell.graphics.moveTo(0, 0);
			cell.graphics.lineTo(2 * halfWidth, 0);
			cell.graphics.lineTo(2 * halfWidth, 2 * halfHeight);
			cell.graphics.lineTo(0, 2 * halfHeight);
			cell.graphics.lineTo(0, 0);
			cell.graphics.endFill();
			cell.width = SMapConfig.GRID_WIDTH;
			cell.height = SMapConfig.GRID_HEIGHT;
			return cell;
		}

		/**
		 * 绘制菱形的路点标记
		 * @param type
		 * @param pt
		 * @return
		 *
		 */
		private function drawDiamondShape(type : int) : Shape
		{
			var halfWidth : int = Math.ceil(SMapConfig.GRID_WIDTH / 2);
			var halfHeight : int = Math.ceil(SMapConfig.GRID_HEIGHT / 2);

			var cell : Shape = new Shape();
			var cellColor : uint = getColorByType(type);
			cell.graphics.beginFill(cellColor, 0.5);
			cell.graphics.moveTo(0, halfHeight);
			cell.graphics.lineTo(halfWidth, 0);
			cell.graphics.lineTo(2 * halfWidth, halfHeight);
			cell.graphics.lineTo(halfWidth, 2 * halfHeight);
			cell.graphics.lineTo(0, halfHeight);
			cell.graphics.endFill();
			cell.width = SMapConfig.GRID_WIDTH;
			cell.height = SMapConfig.GRID_HEIGHT;
			return cell;
		}

		public function hasSpaceTypeMark() : Boolean
		{
			return !(_markMap.values().length == SMapConfig.getGridColumns(SGridType.RECTANGLE) * SMapConfig.getGridRows() && _grids.length == SMapConfig.getGridColumns(SGridType.RECTANGLE) && _grids[0].length == SMapConfig.getGridRows());
		}

		public function initPoints(grids : Array) : void
		{
			for each (var data : SGridData in _markMap.values())
				data.destroy();
			_markMap.clear();
			if (_spaceBitmapData)
				_spaceBitmapData.dispose();
			if (_markDatas)
			{
				for each (var bmd : BitmapData in _markDatas)
					bmd.dispose();
			}
			_markDatas = new Dictionary();
			if (bufferBitmapData)
				bufferBitmapData.dispose();
			_spaceBitmapData = new BitmapData(SMapConfig.GRID_WIDTH, SMapConfig.GRID_HEIGHT, true, 0);
			bufferBitmapData = new BitmapData(SMapConfig.validWidth, SMapConfig.validHeight, true, 0);
			this.bitmapData = bufferBitmapData;
			_grids = grids;
			drawGridPoints(_grids);
		}

		public function drawGridPoints(grids : Array) : void
		{
			//绘制标记格子
			if (grids && grids.length > 0)
			{
				var ixLen : int = grids.length;
				var iyLen : int = grids[0].length;
				for (var ix : int = 0; ix < ixLen; ix++)
				{
					for (var iy : int = 0; iy < iyLen; iy++)
					{
						var value : int = grids[ix][iy];
						var mapKey : String = ix + "_" + iy;
						if (value == SRoadPointType.WALKABLE_VALUE)
						{
							addMarkPoint(SGridType.RECTANGLE, ix, iy, MARK_TYPE_ROAD);
						}
						else if (value == SRoadPointType.UNWALKABLE_VALUE)
						{
							if (!_buildingPointMap.containsKey(mapKey))
								addMarkPoint(SGridType.RECTANGLE, ix, iy, MARK_TYPE_HINDER);
						}
						else if (value == SRoadPointType.MASKABLE_VALUE)
						{
							if (!_buildingPointMap.containsKey(mapKey))
								addMarkPoint(SGridType.RECTANGLE, ix, iy, MARK_TYPE_MASK);
						}
						else if (value == SRoadPointType.SAFE_VALUE)
						{
							if (!_buildingPointMap.containsKey(mapKey))
								addMarkPoint(SGridType.RECTANGLE, ix, iy, MARK_TYPE_SAFE);
						}
						else if (value == SRoadPointType.SAFE_MASKABLE_VALUE)
						{
							if (!_buildingPointMap.containsKey(mapKey))
								addMarkPoint(SGridType.RECTANGLE, ix, iy, MARK_TYPE_SAFE_MASK);
						}
						else if (value == SRoadPointType.JUMP_VALUE)
						{
							if (!_buildingPointMap.containsKey(mapKey))
								addMarkPoint(SGridType.RECTANGLE, ix, iy, MARK_TYPE_JUMP);
						}
					}
				}
			}
		}

		//根据类型画出单元格
		public function addMarkPoint(gridType : int, gridX : int, gridY : int, markType : int) : void
		{
			if (gridX < 0 || gridX > SMapConfig.getGridColumns(SGridType.RECTANGLE) || gridY < 0 || gridY > SMapConfig.getGridRows())
				return;
			var type : int = 0;
			//如果是路点
			if (markType == MARK_TYPE_ROAD)
			{
				type = MARK_TYPE_ROAD;
					//如果是障碍
			}
			else if (markType == MARK_TYPE_HINDER)
			{
				type = MARK_TYPE_HINDER;
			}
			else if (markType == MARK_TYPE_MASK)
			{
				type = MARK_TYPE_MASK;
			}
			else if (markType == MARK_TYPE_SAFE)
			{
				type = MARK_TYPE_SAFE;
			}
			else if (markType == MARK_TYPE_SAFE_MASK)
			{
				type = MARK_TYPE_SAFE_MASK;
			}
			else if (markType == MARK_TYPE_JUMP)
			{
				type = MARK_TYPE_JUMP;
			}
			else
			{
				throw new Error("未知标记类型！");
			}

			var mapKey : String = gridX + "_" + gridY;
			if (_markMap.containsKey(mapKey))
			{
				var gridData : SGridData = _markMap.get(mapKey) as SGridData;
				if (gridData.markType == MARK_TYPE_SAFE && markType == MARK_TYPE_MASK)
					markType = MARK_TYPE_SAFE_MASK;
				else if (gridData.markType == MARK_TYPE_MASK && markType == MARK_TYPE_SAFE)
					markType = MARK_TYPE_SAFE_MASK;
				else if (gridData.markType == MARK_TYPE_SAFE_MASK && markType == MARK_TYPE_MASK)
					markType = MARK_TYPE_SAFE_MASK;
				else if (gridData.markType == MARK_TYPE_SAFE_MASK && markType == MARK_TYPE_SAFE)
					markType = MARK_TYPE_SAFE_MASK;
			}

			addGridPoint(gridType, markType, gridX, gridY);
		}

		private function addGridPoint(gridType : int, markType : int, gridX : int, gridY : int) : void
		{
			var pt : Point = SCommonUtil.getPixelPointByGrid(gridType, SMapConfig.GRID_WIDTH, SMapConfig.GRID_HEIGHT, gridX, gridY);
			var halfWidth : int = Math.ceil(SMapConfig.GRID_WIDTH / 2);
			var halfHeight : int = Math.ceil(SMapConfig.GRID_HEIGHT / 2);

			pt.x += halfWidth & 1;
			pt.y += halfHeight & 1;
			pt.x = pt.x - halfWidth;
			pt.y = pt.y - halfHeight;

			var mapKey : String = gridX + "_" + gridY;

			var gridData : SGridData;
			var bmd : BitmapData;

			var gridMark : int;
			if (markType == MARK_TYPE_ROAD)
				gridMark = MARK_LINE_DIAMOND;
			else if (markType == MARK_TYPE_SAFE)
				gridMark = MARK_CIRCLE;
			else if (markType == MARK_TYPE_SAFE_MASK)
				gridMark = MARK_CIRCLE;
			else if (markType == MARK_TYPE_JUMP)
				gridMark = MARK_CIRCLE;
			else
				gridMark = MARK_RECTANGLE;
			setGridMarkShape(gridMark);

			if (_markMap.containsKey(mapKey))
			{
				gridData = _markMap.get(mapKey) as SGridData;
				if (gridData.markType != markType)
				{
					bmd = _spaceBitmapData;
					bufferBitmapData.copyPixels(bmd, bmd.rect, new Point(gridData.pixelX, gridData.pixelY));
					_markMap.remove(mapKey);
					gridData.destroy();

					if ((markType == MARK_TYPE_ROAD && _showWalkable) || (markType == MARK_TYPE_HINDER && _showUnwalkable) || (markType == MARK_TYPE_MASK && _showMaskable) || (markType == MARK_TYPE_SAFE_MASK && _showMaskable) || (markType == MARK_TYPE_SAFE && _showSafe) || (markType == MARK_TYPE_SAFE_MASK && _showSafe) || (markType == MARK_TYPE_JUMP && _showJump))
					{
						bmd = _markDatas[markType];
						if (!bmd)
							bmd = createMarkData(markType);
						bufferBitmapData.copyPixels(bmd, bmd.rect, new Point(pt.x, pt.y));
					}

					var newObj : SGridData = new SGridData(markType, gridX, gridY, pt.x, pt.y);
					_markMap.put(mapKey, newObj);
				}
				else if (gridData.markType == markType)
				{
					if ((markType == MARK_TYPE_ROAD && _showWalkable) || (markType == MARK_TYPE_HINDER && _showUnwalkable) || (markType == MARK_TYPE_MASK && _showMaskable) || (markType == MARK_TYPE_SAFE_MASK && _showMaskable) || (markType == MARK_TYPE_SAFE && _showSafe) || (markType == MARK_TYPE_SAFE_MASK && _showSafe) || (markType == MARK_TYPE_JUMP && _showJump))
					{
						bmd = _markDatas[markType];
						if (!bmd)
							bmd = createMarkData(markType);
						bufferBitmapData.copyPixels(bmd, bmd.rect, new Point(gridData.pixelX, gridData.pixelY));
					}
				}
			}
			else
			{
				if ((markType == MARK_TYPE_ROAD && _showWalkable) || (markType == MARK_TYPE_HINDER && _showUnwalkable) || (markType == MARK_TYPE_MASK && _showMaskable) || (markType == MARK_TYPE_SAFE_MASK && _showMaskable) || (markType == MARK_TYPE_SAFE && _showSafe) || (markType == MARK_TYPE_SAFE_MASK && _showSafe) || (markType == MARK_TYPE_JUMP && _showJump))
				{
					bmd = _markDatas[markType];
					if (!bmd)
						bmd = createMarkData(markType);
					bufferBitmapData.copyPixels(bmd, bmd.rect, new Point(pt.x, pt.y));
				}
				gridData = new SGridData(markType, gridX, gridY, pt.x, pt.y);
				_markMap.put(mapKey, gridData);
			}
			bmd = null;
		}

		private var _spaceBitmapData : BitmapData;
		private var _markDatas : Dictionary;

		public function createMarkData(markType : int) : BitmapData
		{
			if (_markDatas[markType])
				return _markDatas[markType];
			var shape : Shape = _gridMarkCreater(markType);
			var bmd : BitmapData = new BitmapData(shape.width, shape.height, true, 0);
			bmd.draw(shape);
			_markDatas[markType] = bmd;
			return bmd;
		}

		public function set showMaskable(value : Boolean) : void
		{
			_showMaskable = value;
			updateGrids();
		}

		public function get showMaskable() : Boolean
		{
			return _showMaskable;
		}

		public function get showUnwalkable() : Boolean
		{
			return _showUnwalkable;
		}

		public function set showUnwalkable(value : Boolean) : void
		{
			_showUnwalkable = value;
			updateGrids();
		}

		public function get showWalkable() : Boolean
		{
			return _showWalkable;
		}

		public function set showWalkable(value : Boolean) : void
		{
			_showWalkable = value;
			updateGrids();
		}

		public function get showSafe() : Boolean
		{
			return _showSafe;
		}

		public function set showSafe(value : Boolean) : void
		{
			_showSafe = value;
			updateGrids();
		}

		public function get showJump() : Boolean
		{
			return _showJump;
		}

		public function set showJump(value : Boolean) : void
		{
			_showJump = value;
			updateGrids();
		}

		private function updateGrids() : void
		{
			if (bufferBitmapData)
			{
				bufferBitmapData.fillRect(bufferBitmapData.rect, 0);
				_grids = getGridDatas(SPACE_TYPE_TO_NONE);
				if (_grids)
					drawGridPoints(_grids);
			}
		}

		public function getGridDatas(spaceType : int) : Array
		{
			var gridPointDatas : Array;
			if (spaceType == SPACE_TYPE_TO_ROAD)
				gridPointDatas = SArrayUtil.constructTwoDimensionalArray(SMapConfig.getGridColumns(SGridType.RECTANGLE), SMapConfig.getGridRows(), SRoadPointType.WALKABLE_VALUE);
			else if (spaceType == SPACE_TYPE_TO_HINDER)
				gridPointDatas = SArrayUtil.constructTwoDimensionalArray(SMapConfig.getGridColumns(SGridType.RECTANGLE), SMapConfig.getGridRows(), SRoadPointType.UNWALKABLE_VALUE);
			else
				gridPointDatas = SArrayUtil.constructTwoDimensionalArray(SMapConfig.getGridColumns(SGridType.RECTANGLE), SMapConfig.getGridRows(), SRoadPointType.WALKABLE_VALUE);
			for each (var data : SGridData in _markMap.values())
			{
				var type : int = data.markType;
				var value : int = 0;
				switch (type)
				{
					case MARK_TYPE_ROAD:
						value = SRoadPointType.WALKABLE_VALUE;
						break;
					case MARK_TYPE_HINDER:
						value = SRoadPointType.UNWALKABLE_VALUE;
						break;
					case MARK_TYPE_MASK:
						value = SRoadPointType.MASKABLE_VALUE;
						break;
					case MARK_TYPE_SAFE:
						value = SRoadPointType.SAFE_VALUE;
						break;
					case MARK_TYPE_SAFE_MASK:
						value = SRoadPointType.SAFE_MASKABLE_VALUE;
						break;
					case MARK_TYPE_JUMP:
						value = SRoadPointType.JUMP_VALUE;
						break;
					case MARK_TYPE_SPACE:
						if (spaceType == SPACE_TYPE_TO_ROAD)
						{
							value = SRoadPointType.WALKABLE_VALUE;
						}
						else if (spaceType == SPACE_TYPE_TO_HINDER)
						{
							value = SRoadPointType.UNWALKABLE_VALUE;
						}
						else
						{
							value = SRoadPointType.WALKABLE_VALUE;
						}
						break;
					default:
						throw new Error("地图信息数组中有未知因素！");
						break;

				}
				if (data.gridX < SMapConfig.getGridColumns(SGridType.RECTANGLE) && data.gridY < SMapConfig.getGridRows())
					gridPointDatas[data.gridX][data.gridY] = value;
			}
			return gridPointDatas;
		}

		public function removeMarkPoint(gridX : int, gridY : int) : void
		{
			var mapKey : String = gridX + "_" + gridY;
			removeRoadPoint(mapKey);
		}

		//移除路点
		private function removeRoadPoint(mapKey : String) : void
		{
			var gridData : SGridData;
			var ditmapData : BitmapData;
			if (_markMap.containsKey(mapKey))
			{
				gridData = _markMap.get(mapKey) as SGridData;
				if (gridData.markType == MARK_TYPE_ROAD)
				{
					ditmapData = _spaceBitmapData;
					bufferBitmapData.copyPixels(ditmapData, ditmapData.rect, new Point(gridData.pixelX, gridData.pixelY));

					_markMap.remove(mapKey);
					gridData.destroy();
				}
				else if (gridData.markType == MARK_TYPE_HINDER)
				{
					//obj.count--;
					//if (obj.count == 0)
					{
						ditmapData = _spaceBitmapData;
						bufferBitmapData.copyPixels(ditmapData, ditmapData.rect, new Point(gridData.pixelX, gridData.pixelY));

						_markMap.remove(mapKey);
						gridData.destroy();
						if (_buildingPointMap.containsKey(mapKey))
							_buildingPointMap.remove(mapKey);
					}
					//else
					{
						//	_markMap.put(mapKey, obj);
					}
				}
				else if (gridData.markType == MARK_TYPE_MASK)
				{
					ditmapData = _spaceBitmapData;
					bufferBitmapData.copyPixels(ditmapData, ditmapData.rect, new Point(gridData.pixelX, gridData.pixelY));

					_markMap.remove(mapKey);
					gridData.destroy();
				}
				else if (gridData.markType == MARK_TYPE_SAFE)
				{
					ditmapData = _spaceBitmapData;
					bufferBitmapData.copyPixels(ditmapData, ditmapData.rect, new Point(gridData.pixelX, gridData.pixelY));

					_markMap.remove(mapKey);
					gridData.destroy();
				}
				else if (gridData.markType == MARK_TYPE_SAFE_MASK)
				{
					ditmapData = _spaceBitmapData;
					bufferBitmapData.copyPixels(ditmapData, ditmapData.rect, new Point(gridData.pixelX, gridData.pixelY));

					_markMap.remove(mapKey);
					gridData.destroy();
				}
				else if (gridData.markType == MARK_TYPE_JUMP)
				{
					ditmapData = _spaceBitmapData;
					bufferBitmapData.copyPixels(ditmapData, ditmapData.rect, new Point(gridData.pixelX, gridData.pixelY));

					_markMap.remove(mapKey);
					gridData.destroy();
				}
			}
		}

		public function get gridMark() : int
		{
			return _gridMark;
		}

		public function set gridMark(val : int) : void
		{
			_gridMark = val;
			setGridMarkShape(_gridMark);
		}

		//将指定单元格设置为初始状态
		public function resetCell(xIndex : int, yIndex : int) : void
		{
			var mapKey : String = xIndex + "_" + yIndex;
			var gridData : SGridData = _markMap.get(mapKey) as SGridData;
			if (gridData != null)
			{
				var ditmapData : BitmapData = _spaceBitmapData;
				bufferBitmapData.copyPixels(ditmapData, ditmapData.rect, new Point(gridData.pixelX, gridData.pixelY));
				_markMap.remove(mapKey);
				gridData.destroy();
			}
		}

		public function destroy() : void
		{
			if (this.parent)
				this.parent.removeChild(this);
		}

	/**
	 *
	 * originPX, originPY	建筑物元点在地图坐标系中的像素坐标
	 * building				建筑物显示对象
	 * walkable 			是否可行走
	 */
	/*public function drawWalkableBuilding(building : Building, originPX : int, originPY : int, wb : Boolean) : void
	   {
	   var walkableStr : String = building.configXml.walkable;
	   var wa : Array = walkableStr.split(",");

	   if (wa == null || wa.length < 2)
	   return;

	   var cellWidth : Number = this.parentApplication._cellWidth;
	   var cellHeight : Number = this.parentApplication._cellHeight;
	   var row : int = this.parentApplication._row;
	   var col : int = this.parentApplication._col;
	   var xtmp : int, ytmp : int;

	   for (var i : int = 0; i < wa.length; i += 2)
	   {
	   xtmp = originPX + int(wa[i]);
	   ytmp = originPY + int(wa[i + 1]);
	   var pt : Point = SCommonUtils.getCellPoint(cellWidth, cellHeight, xtmp, ytmp);
	   var mapKey : String = pt.x + "," + pt.y;

	   if (wb == false) //增加阻挡
	   {
	   if (pt.x >= 0 && xtmp > 0)
	   {

	   //将建筑物中的障碍点记录在 _buildingPointMap 中
	   if (!_buildingPointMap.containsKey(mapKey))
	   _buildingPointMap.put(mapKey, new Point(pt.x, pt.y));

	   drawCell(pt.x, pt.y, GRID_TYPE_HINDER);
	   this.parentApplication._mapArr[pt.y][pt.x] = GRID_TYPE_HINDER;
	   }
	   }
	   else //删除阻挡
	   {
	   if (pt.x >= 0 && xtmp > 0)
	   removeRoadPoint(mapKey, pt);
	   }
	   }

	 }*/
	}
}