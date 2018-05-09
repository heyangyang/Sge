package com.sunny.game.engine.map
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	import flash.geom.Point;

	/**
	 *
	 * <p>
	 * SunnyGame的一个远景表面，暂时只支持200的倍数
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
	public class SDistantSurface extends SBlockCombinationSurface
	{
		/**
		 * 由于地图不一定是块大小的整数倍，如果需要循环则需要一个成余数倍数的偏移值
		 */
		private var _bufferTileOffsetPoint : Point;

		/**
		 * 暂定1,2,3分别为随移动滚动和自动向左、向右
		 */
		private var _rollType : int;
		private var _rollSpeed : int;
		private var _rollPosition : int;

		public function SDistantSurface()
		{
			super("DistantSurface");
		}

		override protected function initMapData() : void
		{
			_bufferTileOffsetPoint = new Point(0, 0);
			super.initMapData();
		}

		/**
		 * 初始化地图
		 *
		 */
		override protected function parseMapData() : void
		{
			super.parseMapData();
			_rollType = 1; //配置中没有，暂时向下兼容
			_rollSpeed = 1;
			_rollPosition = 0;
			var rollTypeStr : String = _config.@rollType;
			if (rollTypeStr)
				_rollType = int(rollTypeStr);
			if (_rollType == 2)
				_rollPosition = int.MAX_VALUE;
			else if (_rollType == 3)
				_rollPosition = 0;
			else if (_rollType == 4)
				_rollPosition = int.MAX_VALUE;
			else if (_rollType == 5)
				_rollPosition = 0;
			var rollSpeedStr : String = _config.@rollSpeed;
			if (rollSpeedStr)
				_rollSpeed = int(rollSpeedStr);

			initMapData();
			setScrollBorder(_config.@left, _config.@top, _config.@right, _config.@bottom);
		}

		/**
		 * 设置焦点
		 * @param tx
		 * @param ty
		 *
		 */
		override public function focus(viewX : Number, viewY : Number) : void
		{
			if (!_config)
				throw new SunnyGameEngineError("没有初始化地图配置！");

			viewX = viewX < 0 ? 0 : viewX;
			viewY = viewY < 0 ? 0 : viewY;

			if (_rollType == 1)
			{
				//这里实现远景换算
				viewX = viewX * 0.1;
				viewY = viewY * 0.1; //(_viewHeight - _mapHeight) / 2;
			}
			else if (_rollType == 2)
			{
				_rollPosition -= _rollSpeed;
				viewX = _rollPosition;
				viewY = viewY * 0.1; //(_viewHeight - _mapHeight) / 2;
			}
			else if (_rollType == 3)
			{
				_rollPosition += _rollSpeed;
				viewX = _rollPosition;
				viewY = viewY * 0.1; //(_viewHeight - _mapHeight) / 2;
			}
			else if (_rollType == 4)
			{
				_rollPosition -= _rollSpeed;
				viewX = viewX * 0.1; //(_viewHeight - _mapHeight) / 2;
				viewY = _rollPosition;
			}
			else if (_rollType == 5)
			{
				_rollPosition += _rollSpeed;
				viewX = viewX * 0.1; //(_viewHeight - _mapHeight) / 2;
				viewY = _rollPosition;
			}
			else if (_rollType == 6)
			{
				_rollPosition -= _rollSpeed;
				viewX = _rollPosition;
				viewY = -(_viewHeight - _mapHeight) / 2;
			}
			else if (_rollType == 7)
			{
				_rollPosition += _rollSpeed;
				viewX = _rollPosition;
				viewY = -(_viewHeight - _mapHeight) / 2;
			}
			else if (_rollType == 8)
			{
				_rollPosition -= _rollSpeed;
				viewX = _rollPosition;
				viewY = 0;
			}
			else if (_rollType == 9)
			{
				_rollPosition += _rollSpeed;
				viewX = _rollPosition;
				viewY = 0;
			}
			super.focus(viewX, viewY);
		}

		override public function destroy() : void
		{
			super.destroy();
		}
	}
}