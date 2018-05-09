package com.sunny.game.engine.map
{
	import com.sunny.game.engine.component.SUpdatableComponent;
	import com.sunny.game.engine.entity.SSceneEntity;

	/**
	 *
	 * <p>
	 * SunnyGame的一个场景地图组件
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
	public class SSceneMapComponent extends SUpdatableComponent
	{
		public function SSceneMapComponent()
		{
			super(SSceneMapComponent);
		}

		override public function notifyAdded() : void
		{
			super.notifyAdded();
			if ((_owner as SSceneEntity).sceneMap)
				(_owner as SSceneEntity).sceneMap.run();
		}

		override public function notifyRemoved() : void
		{
			super.notifyRemoved();
			if ((_owner as SSceneEntity).sceneMap)
				(_owner as SSceneEntity).sceneMap.clear();
		}

		override public function update() : void
		{
			if ((_owner as SSceneEntity).sceneMap)
				(_owner as SSceneEntity).sceneMap.update();
		}
	}
}