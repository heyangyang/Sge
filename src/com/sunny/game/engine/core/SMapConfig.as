package com.sunny.game.engine.core
{
	import com.sunny.game.engine.enum.SGridType;


	/**
	 *
	 * <p>
	 * SunnyGame的一个地图配置
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
	public final class SMapConfig
	{
		public static var version : String;
		/**
		 * 分块宽度
		 */
		public static var TILE_WIDTH : int = 200;
		/**
		 * 分块高度
		 */
		public static var TILE_HEIGHT : int = 200;

		/**
		 * 格子宽度
		 */
		public static var GRID_WIDTH : int = 50;
		/**
		 * 格子高度
		 */
		public static var GRID_HEIGHT : int = 50;

		/**
		 * 小地图相对场景地图缩放比例
		 */
		public static const SMALL_MAP_SCALE : Number = 0.1;

		/**
		 * 大地图相对场景地图缩放比例
		 */
		public static var BIG_MAP_SCALE : Number = 0.2;
		/**
		 * 地图宽度
		 */
		public static var mapWidth : int = 0;
		/**
		 * 地图高度
		 */
		public static var mapHeight : int = 0;

		public static var leftBorder : int = 0;
		public static var topBorder : int = 0;
		public static var rightBorder : int = 0;
		public static var bottomBorder : int = 0;

		public static var viewWidth : int = 0;
		public static var viewHeight : int = 0;

		public static function get validMapWidth() : int
		{
			return rightBorder - leftBorder;
		}

		public static function get validMapHeight() : int
		{
			return bottomBorder - topBorder;
		}

		/**
		 * 地图名称
		 */
		public static var mapName : String = "";

		public static var smallMapResourceId : String;
		public static var smallMapVersion : String;

		public static function getGridColumns(gridType : int) : int
		{
			if (gridType == SGridType.RECTANGLE)
				return int(validWidth / SMapConfig.GRID_WIDTH);
			else
				return getGridRows() * 2;
		}

		public static function getGridRows() : int
		{
			return int(validHeight / SMapConfig.GRID_HEIGHT);
		}

		public static function get validWidth() : int
		{
			return int((rightBorder - leftBorder) / SMapConfig.GRID_WIDTH) * SMapConfig.GRID_WIDTH;
		}

		public static function get validHeight() : int
		{
			return int((bottomBorder - topBorder) / SMapConfig.GRID_HEIGHT) * SMapConfig.GRID_HEIGHT;
		}

	/*public static function getGridColumns(gridType : int) : int
	{
		if (gridType == SGridType.RECTANGLE)
			return Math.ceil(SMapConfig.mapWidth / SMapConfig.GRID_WIDTH);
		else
			return getGridRows() * 2;
	}

	public static function getGridRows() : int
	{
		return Math.ceil(SMapConfig.mapHeight / SMapConfig.GRID_HEIGHT);
	}*/
	}
}