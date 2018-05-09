package com.sunny.game.engine.data
{
	import com.sunny.game.engine.entity.SEntity;

	/**
	 *
	 * <p>
	 * SunnyGame的一个过去数据
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
	public class SPastData extends SBasicData
	{
		public var entity : SEntity;
		public var dir : int;
		public var mapX : Number;
		public var mapY : Number;

		public var gridX : int;
		public var gridY : int;

		public function SPastData()
		{
		}

		override public function destroy() : void
		{
			entity = null;
		}
	}
}