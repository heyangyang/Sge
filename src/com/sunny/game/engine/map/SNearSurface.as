package com.sunny.game.engine.map
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	/**
	 *
	 * <p>
	 * SunnyGame的一个近景表面，暂时只支持200的倍数
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
	public class SNearSurface extends SBlockCombinationSurface
	{
		/**
		 * 暂定1,2,3分别为随移动滚动和自动向左、向右
		 */
		private var _rollType : int;
		private var _rollSpeed : int;
		private var _rollPosition : int;

		public function SNearSurface()
		{
			super("NearSurface");
		}

		override protected function initMapData() : void
		{
			super.initMapData();
		}

		/**
		 * 初始化地图
		 *
		 */
		override protected function parseMapData() : void
		{
			super.parseMapData();
			_transparent = true;

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
				//这里实现近景换算
				viewX = viewX * 1.6;
			}
			else if (_rollType == 2)
			{
				_rollPosition -= _rollSpeed;
				viewX = _rollPosition;
			}
			else if (_rollType == 3)
			{
				_rollPosition += _rollSpeed;
				viewX = _rollPosition;
			}

			viewY = viewY * 0.2;
			//viewY = 0; //_viewHeight - _mapHeight;

			super.focus(viewX, viewY);
		}

		override public function destroy() : void
		{
			super.destroy();
		}
	}
}