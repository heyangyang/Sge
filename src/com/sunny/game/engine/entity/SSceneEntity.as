package com.sunny.game.engine.entity
{
	import com.sunny.game.engine.map.SISceneMap;

	/**
	 *
	 * <p>
	 * SunnyGame的场景实体
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
	public class SSceneEntity extends SEntity
	{
		/**
		 * 场景中的当前地图
		 */
		private var _sceneMap : SISceneMap;

		public function SSceneEntity(sceneMap : SISceneMap)
		{
			_sceneMap = sceneMap;
			super(0, "scene");
		}

		public function get sceneMap() : SISceneMap
		{
			return _sceneMap;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			_sceneMap = null;
			super.destroy();
		}
	}
}