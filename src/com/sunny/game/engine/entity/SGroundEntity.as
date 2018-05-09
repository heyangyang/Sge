package com.sunny.game.engine.entity
{
	import com.sunny.game.engine.render.SBaseRenderManager;

	/**
	 *
	 * <p>
	 * SunnyGame的地面实体对象
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
	public class SGroundEntity extends SRenderableEntity
	{
		public function SGroundEntity(id : int, name : String, entityType : int = 1, render : SBaseRenderManager = null)
		{
			super(id, name, entityType, render);
			isStatic = true;
		}

		override public function register(priorityLayer : int = 2, priority : int = 0) : void
		{
			visible = true;
			super.register(priorityLayer, priority);
		}

		override public function unregister() : void
		{
			super.unregister();
			visible = false;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			super.destroy();
		}
	}
}