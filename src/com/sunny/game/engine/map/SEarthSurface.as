package com.sunny.game.engine.map
{
	import com.sunny.game.engine.algorithm.seek.SRoadSeeker;
	import com.sunny.game.engine.core.SMapConfig;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.display.SGridLayer;
	import com.sunny.game.engine.display.SGridPointLayer;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.manager.SFileSystemManager;
	import com.sunny.game.engine.manager.SResourceManager;
	import com.sunny.game.engine.render.base.SNormalContainer;
	import com.sunny.game.engine.render.interfaces.SIContainer;
	import com.sunny.game.engine.resource.SResource;
	import com.sunny.game.engine.utils.SCommonUtil;

	import flash.display.Sprite;
	import flash.utils.ByteArray;

	/**
	 *
	 * <p>
	 * SunnyGame的一个土地表面
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
	public class SEarthSurface extends SBlockCombinationSurface implements SISceneMap
	{
		public static const EVENT_MAX_MULTI_DISTANCE_CHANGE : String = "EVENT_MAX_MULTI_DISTANCE_CHANGE";

		/**
		 * 远景地图
		 */
		private var _distantMap : SDistantSurface;
		/**
		 * 近景地图
		 */
		private var _nearMap : SNearSurface;

		private var _earthInited : Function;

		private var _multiDistance : int;
		private var _maxMultiDistance : int;
		private var _mapBlocks : Array;

		private var _dataInited : Boolean;

		/**
		 * 网格层
		 */
		private var _gridLayer : SGridLayer;
		private var _gridLayerVisible : Boolean;

		/**
		 * 格子点层
		 */
		private var _gridPointLayer : SGridPointLayer;
		private var _gridPointLayerVisible : Boolean;
		private var _showWalkable : Boolean;
		private var _showMaskable : Boolean;
		private var _showUnwalkable : Boolean;
		private var _showSafe : Boolean;
		private var _showJump : Boolean;

		public var gridUrl : String;
		public var gridVersion : String;

		private var _mapId : String;
		private var _onConfigComplete : Function;
		private var _onProgress : Function;
		private var container : SIContainer;

		public function SEarthSurface(container : SIContainer)
		{
			super("EarthSurface");
			this.container = container;
			container.addGameChildAt(bufferBitmap, 0);
		}

//		override protected function onAdded(e : Event) : void
//		{
//			super.onAdded(e);
//			if (_distantMap)
//			{
//				container.addGameChildAt(_distantMap.bufferBitmap, container.getGameChildIndex(_bufferBitmap));
//			}
//		}

		public function set showGrids(value : Boolean) : void
		{
			_gridLayerVisible = value;
			if (_gridLayerVisible)
				showGridLayer();
			else
				hideGridLayer();
		}

		/**
		 * 显示网格
		 *
		 */
		private function showGridLayer() : void
		{
			if (!_gridLayer)
			{
				_gridLayer = new SGridLayer();
				if (container)
					SNormalContainer(container).addChild(_gridLayer);
				if (_dataInited)
					_gridLayer.drawGrids();
			}
			if (_dataInited)
				_gridLayer.visible = true;
		}

		private function hideGridLayer(clearMemory : Boolean = false) : void
		{
			if (_gridLayer)
				_gridLayer.visible = false;
			if (clearMemory)
			{
				if (_gridLayer)
					_gridLayer.destroy();
				_gridLayer = null;
			}
		}

		private function checkGridPointLayerVisible() : void
		{
			_gridPointLayerVisible = _showWalkable || _showMaskable || _showUnwalkable || _showSafe || _showJump;
			if (_gridPointLayerVisible)
				showGridPointLayer();
			else
				hideGridPointLayer();
		}

		/**
		 * 显示格子点
		 *
		 */
		private function showGridPointLayer() : void
		{
			if (!_gridPointLayer)
			{
				_gridPointLayer = new SGridPointLayer();
				if (container)
					SNormalContainer(container).addChild(_gridPointLayer);
				_gridPointLayer.showWalkable = _showWalkable;
				_gridPointLayer.showMaskable = _showMaskable;
				_gridPointLayer.showUnwalkable = _showUnwalkable;
				_gridPointLayer.showSafe = _showSafe;
				_gridPointLayer.showJump = _showJump;
				if (_dataInited)
					_gridPointLayer.initPoints(_mapBlocks);
			}
			if (_dataInited)
				_gridPointLayer.visible = true;
		}

		private function hideGridPointLayer(clearMemory : Boolean = false) : void
		{
			if (_gridPointLayer)
				_gridPointLayer.visible = false;
			if (clearMemory)
			{
				if (_gridPointLayer)
					_gridPointLayer.destroy();
				_gridPointLayer = null;
			}
		}

		public function set showWalkable(value : Boolean) : void
		{
			_showWalkable = value;
			if (_gridPointLayer)
				_gridPointLayer.showWalkable = _showWalkable;
			checkGridPointLayerVisible();
		}

		public function set showMaskable(value : Boolean) : void
		{
			_showMaskable = value;
			if (_gridPointLayer)
				_gridPointLayer.showMaskable = _showMaskable;
			checkGridPointLayerVisible();
		}

		public function set showUnwalkable(value : Boolean) : void
		{
			_showUnwalkable = value;
			if (_gridPointLayer)
				_gridPointLayer.showUnwalkable = _showUnwalkable;
			checkGridPointLayerVisible();
		}

		public function set showSafe(value : Boolean) : void
		{
			_showSafe = value;
			if (_gridPointLayer)
				_gridPointLayer.showSafe = _showSafe;
			checkGridPointLayerVisible();
		}

		public function set showJump(value : Boolean) : void
		{
			_showJump = value;
			if (_gridPointLayer)
				_gridPointLayer.showJump = _showJump;
			checkGridPointLayerVisible();
		}

		override public function clear() : void
		{
			if (_distantMap)
				_distantMap.destroy();
			_distantMap = null;
			if (_nearMap)
				_nearMap.destroy();
			_nearMap = null;
			_mapBlocks = null;
			if (gridUrl)
			{
				gridUrl = null;
				gridVersion = null;
			}

			_dataInited = false;
			hideGridLayer(true);
			hideGridPointLayer(true);
//			if (_unwalks)
//			{
//				_unwalks.length = 0;
//				_unwalks = null;
//			}
			_mapId = null;
			_onConfigComplete = null;
			super.clear();
		}

		/**
		 * 初始化地图
		 * @param id
		 * @param onComplete
		 * @param inited
		 *
		 */
		public function load(mapId : String, onComplete : Function = null, onProgress : Function = null) : void
		{
			clear();
			_mapId = mapId;
			_onConfigComplete = onComplete;
			_onProgress = onProgress;
			SResourceManager.getInstance().createResource(_mapId, SFileSystemManager.getInstance().sceneFileSystem).onComplete(onConfigComplete).onProgress(onProgress).load();
		}

		private function onConfigComplete(res : SResource) : void
		{
			var bytes : ByteArray = res.getBinary(true);
			bytes.position = 0;
			setConfig(XML(bytes.readUTFBytes(bytes.bytesAvailable)));
			gridUrl = String(_config.grid.@url);
			gridVersion = String(_config.grid.@version);
			if (gridUrl)
			{
				SResourceManager.getInstance().createResource(gridUrl).setVersion(gridVersion).onComplete(onBlockComplete).onProgress(_onProgress).onIOError(onBlockError).load();
			}
			else
			{
				updateBlocks();
				if (_onConfigComplete != null)
					_onConfigComplete();
				_onConfigComplete = null;
			}
		}

		private function onBlockComplete(res : SResource) : void
		{
			var bytes : ByteArray = res.getBinary(true);
			bytes.position = 0;
			var mapBlocks : Array = bytes.readObject() as Array;
			if (!mapBlocks || mapBlocks.length == 0 || mapBlocks[0].length == 0)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "地图数据出现mapBlocks=" + mapBlocks ? mapBlocks.toString() : 'null');
			}
			updateBlocks(mapBlocks);

			if (_onConfigComplete != null)
				_onConfigComplete();
			_onProgress = null;
			_onConfigComplete = null;
		}

		private function onBlockError(res : SResource) : void
		{
			updateBlocks();
			if (_onConfigComplete != null)
				_onConfigComplete();
			_onConfigComplete = null;
		}

		override protected function parseMapData() : void
		{
			super.parseMapData();
			SMapConfig.version = _config.@version;
			SMapConfig.mapWidth = _mapWidth;
			SMapConfig.mapHeight = _mapHeight;
			SMapConfig.mapName = _mapName;
			if (SMapConfig.version == "2")
			{
				SMapConfig.TILE_WIDTH = _config.@tileWidth;
				SMapConfig.TILE_HEIGHT = _config.@tileHeight;
				SMapConfig.GRID_WIDTH = _config.@gridWidth;
				SMapConfig.GRID_HEIGHT = _config.@gridHeight;
			}
			else
			{
				SMapConfig.TILE_WIDTH = 200;
				SMapConfig.TILE_HEIGHT = 200;
				SMapConfig.GRID_WIDTH = 50;
				SMapConfig.GRID_HEIGHT = 50;
			}
			SMapConfig.BIG_MAP_SCALE = _config.bm.@scale;

			if (hasDistant(_config))
				_transparent = true;
			_maxMultiDistance = int(_config.@multiDistance);
			if (_maxMultiDistance < 1)
				_maxMultiDistance = 1;
			_multiDistance = 1;

			SMapConfig.smallMapResourceId = _smallMapResourceId;
			SMapConfig.smallMapVersion = _smallMapVersion;

			setScrollBorder(_config.@left, _config.@top, _config.@right, _config.@bottom);
			initMapData();
		}

		override protected function initMapData() : void
		{
			super.initMapData();
			if (hasDistant(_config))
			{
				_distantMap = new SDistantSurface();
				if (_container.sparent)
					container.addGameChildAt(_distantMap.bufferBitmap, container.getGameChildIndex(_container));
				_distantMap.setConfig(XML(_config.distant));
			}

			_dataInited = true;
//			if (_gridLayerVisible)
//				showGridLayer();
//			if (_gridPointLayerVisible)
//				showGridPointLayer();
		}

		//地图描述和格子数据加载完成后进入游戏
		override public function run() : void
		{
			super.run();
			if (_distantMap)
				_distantMap.run();
			if (_nearMap)
				_nearMap.run();
		}

		override public function setViewSize(viewWidth : int, viewHeight : int) : void
		{
			SMapConfig.viewWidth = viewWidth;
			SMapConfig.viewHeight = viewHeight;
			super.setViewSize(viewWidth, viewHeight);
			if (_distantMap)
				_distantMap.setViewSize(viewWidth, viewHeight);
			if (_nearMap)
				_nearMap.setViewSize(viewWidth, viewHeight);
		}

		private function hasDistant(config : XML) : Boolean
		{
			return Boolean(config.hasOwnProperty("distant"));
		}

		private function hasNear(config : XML) : Boolean
		{
			return Boolean(config.hasOwnProperty("near"));
		}

		public function updateBlocks(mapBlocks : Array = null) : void
		{
			if (mapBlocks)
			{
				_mapBlocks = mapBlocks;
				if (_maxMultiDistance > 1)
				{
					var multiBlocks : Array = [];
					var blockColumsLen : int = _mapBlocks.length;
					var multiColumsLen : int = blockColumsLen * _maxMultiDistance;
					var blockRowsLen : int = _mapBlocks[0].length;
					for (var i : int = 0; i < multiColumsLen; i++)
					{
						var data : Array = [];
						multiBlocks.push(data);
						for (var j : int = 0; j < blockRowsLen; j++)
						{
							data.push(_mapBlocks[i % blockColumsLen][j]);
						}
					}
					_mapBlocks = multiBlocks;
				}
				SRoadSeeker.getInstance().init(_mapBlocks);

				// 寻找当前屏幕范围内的不可走区域，并将其绘制在不可走区域画布上
				/*_viewUnwalks=_unwalks.filter(filterPointDatas);
				   buildBlockAreas(_unwalkShape, _viewUnwalks);
				 */
				// 寻找当前屏幕范围内的遮罩区域，并将其绘制在遮罩区域画布上
//				if (_masks)
//					_viewMasks = _masks.filter(filterPointDatas);
				//buildBlockAreas(_maskShape, _viewMasks);

//				if (_pks)
//					_viewPKs = _pks.filter(filterPointDatas);
				//buildBlockAreas(_pkShape, _viewPKs);

				if (_gridPointLayer)
					_gridPointLayer.drawGridPoints(_mapBlocks);
			}
		}

		/**
		 * 检测某一组坐标点是否有至少一个在当前屏幕矩形中
		 *
		 * @param element
		 * @param index
		 * @param arr
		 * @return
		 *
		 */
		private function filterPointDatas(item : *, index : int, array : Array) : Boolean
		{
			var value : int = item;
			var x : int;
			var y : int;
			x = SCommonUtil.getXFromInt(item * SMapConfig.GRID_WIDTH);
			y = SCommonUtil.getYFromInt(item * SMapConfig.GRID_HEIGHT);
			if (_bufferRect.contains(x, y))
				return true;
			x = SCommonUtil.getXFromInt(item * SMapConfig.GRID_WIDTH + SMapConfig.GRID_WIDTH);
			if (_bufferRect.contains(x, y))
				return true;
			y = SCommonUtil.getYFromInt(item * SMapConfig.GRID_HEIGHT + SMapConfig.GRID_HEIGHT);
			if (_bufferRect.contains(x, y))
				return true;
			x = SCommonUtil.getXFromInt(item * SMapConfig.GRID_WIDTH);
			if (_bufferRect.contains(x, y))
				return true;
			return false;
		}

		override protected function refreshBuffer() : void
		{
			if (!_updatable)
				return;
			super.refreshBuffer();
			if (_maxMultiDistance > 1)
				updateBlocks();
		}

		/**
		 * 屏幕大小 改变
		 * @param w
		 * @param h
		 *
		 */
		override public function resize(w : int, h : int) : void
		{
			super.resize(w, h);
			if (_distantMap)
				_distantMap.resize(w, h);
			if (_nearMap)
				_nearMap.resize(w, h);
		}

		override protected function setScrollBorder(left : int, top : int, right : int, bottom : int) : void
		{
			super.setScrollBorder(left, top, right, bottom);
			SMapConfig.leftBorder = _leftBorder;
			SMapConfig.topBorder = _topBorder;
			SMapConfig.rightBorder = _rightBorder;
			SMapConfig.bottomBorder = _bottomBorder;
			initBlockBorder();
		}

		/**
		 * 设置可寻路的范围
		 *
		 */
		private function initBlockBorder() : void
		{
			if (_leftCols >= 0 && _topRows >= 0 && _rightCols > 0 && _bottomRows > 0)
			{
				var columTop : int = 0;
				var rowTop : int = 0;
				var columBottom : int = SMapConfig.validWidth;
				var rowBottom : int = SMapConfig.validHeight;
				SRoadSeeker.getInstance().setBlockBorder(rowTop, rowBottom * _maxMultiDistance, columTop, columBottom);
			}
		}

		override public function loadSmallMap(inited : Function = null) : void
		{
			if (_distantMap)
			{
				_earthInited = inited;
				super.loadSmallMap(distantInited);
			}
			else if (_nearMap)
			{
				_earthInited = inited;
				super.loadSmallMap(nearInited);
			}
			else
			{
				super.loadSmallMap(inited);
			}
		}

		private function distantInited() : void
		{
			_distantElapsedTime = 0;
			if (_nearMap)
				_distantMap.loadSmallMap(nearInited);
			else
				_distantMap.loadSmallMap(earthInited);
		}

		private function nearInited() : void
		{
			_nearElapsedTime = 0;
			_nearMap.loadSmallMap(earthInited);
		}

		private function earthInited() : void
		{
			if (_earthInited != null)
				_earthInited();
			_earthInited = null;
		}

		/**
		 * 将遮挡区域画到其对应的画布上
		 *
		 * @param blockAreaBD
		 * @param blockAreaArray
		 *
		 */
		private function buildBlockAreas(blockSprite : Sprite, datas : Array) : void
		{
			blockSprite.graphics.clear();
			blockSprite.graphics.beginFill(0);

			if (datas)
			{
				for (var i : int = 0; i < datas.length; i++)
				{
					var value : int = datas[i];
					var blockX : int = SCommonUtil.getXFromInt(value);
					var blockY : int = SCommonUtil.getYFromInt(value);
					var startX : int = blockX * SMapConfig.GRID_WIDTH - _bufferRect.x;
					var startY : int = blockY * SMapConfig.GRID_HEIGHT - _bufferRect.y;
					blockSprite.graphics.drawRect(startX, startY, SMapConfig.GRID_WIDTH, SMapConfig.GRID_HEIGHT);
				}
			}
			blockSprite.graphics.endFill();
		}

		private var _distantElapsedTime : int = 0;
		private var _nearElapsedTime : int = 0;

		override public function update(elapsedTime : int = 0) : void
		{
			if (!_updatable)
				return;
			super.update(elapsedTime);
			if (_distantMap)
			{
				_distantElapsedTime += elapsedTime;
				if (_distantElapsedTime >= 40)
				{
					_distantMap.update(_distantElapsedTime);
					_distantElapsedTime = 0;
				}
			}
			if (_nearMap)
			{
				_nearElapsedTime += elapsedTime;
				if (_nearElapsedTime >= 40)
				{
					_nearMap.update(_nearElapsedTime);
					_nearElapsedTime = 0;
				}
			}
		}

		override public function focus(viewX : Number, viewY : Number) : void
		{
			super.focus(viewX, viewY);
			if (_distantMap)
				_distantMap.focus(viewX, viewY);
			if (_nearMap)
				_nearMap.focus(viewX, viewY);

			if (_gridLayer)
			{
				_gridLayer.x = -_viewX;
				_gridLayer.y = -_viewY;
			}
			if (_gridPointLayer)
			{
				_gridPointLayer.x = -_viewX;
				_gridPointLayer.y = -_viewY;
			}
		}

		override public function destroy() : void
		{
			super.destroy();
			_onProgress = null;
//			if (_unwalkShape && _unwalkShape.parent)
//				_unwalkShape.parent.removeChild(_unwalkShape);
//			_unwalkShape = null;
//
//			if (_maskShape && _maskShape.parent)
//				_maskShape.parent.removeChild(_maskShape);
//			_maskShape = null;
//
//			if (_pkShape && _pkShape.parent)
//				_pkShape.parent.removeChild(_pkShape);
//			_pkShape = null;
		}

		public function get distantMap() : SDistantSurface
		{
			return _distantMap;
		}

		public function get nearMap() : SNearSurface
		{
			return _nearMap;
		}

		public function set multiDistance(value : int) : void
		{
			if (value >= 1 && value <= _maxMultiDistance)
			{
				if (_multiDistance != value)
				{
					_multiDistance = value;
					updateCamera();
				}
			}
		}

		public function get maxMultiDistance() : int
		{
			return _maxMultiDistance;
		}

//
//		override protected function copyTileBitmapData(tileX : int, tileY : int) : void
//		{
//			createMapTile(tileX, tileY);
//
//			if (_maxMultiDistance <= 1)
//			{
//				if (tileX >= 0 && tileY >= 0 && tileX < _mapCols && tileY < _mapRows)
//				{
//					drawTileBitmapData(tileX, tileY);
//				}
//				else
//				{
//					drawEmptyTile(tileX, tileY);
//				}
//			}
//			else
//			{
//				super.copyTileBitmapData(tileX, tileY);
//			}
//		}

		public function get multiDistance() : int
		{
			return _multiDistance;
		}

		public function set maxMultiDistance(value : int) : void
		{
			_maxMultiDistance = value;
			if (_maxMultiDistance < 1)
				_maxMultiDistance = 1;
			initBlockBorder();
			updateBlocks(_mapBlocks);
			SEvent.dispatchEvent(EVENT_MAX_MULTI_DISTANCE_CHANGE);
		}

		public function get gridLayer() : SGridLayer
		{
			return _gridLayer;
		}

		public function get gridPointLayer() : SGridPointLayer
		{
			return _gridPointLayer;
		}
	}
}