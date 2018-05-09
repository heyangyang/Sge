package com.sunny.game.engine.component.bound
{
	import com.sunny.game.engine.core.SComponent;
	import com.sunny.game.engine.entity.SRenderableEntity;

	/**
	 *
	 * <p>
	 * SunnyGame的一个包围区域组件
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
	public class SBoundingComponent extends SComponent
	{
		//屏幕坐标
		public var left : Number = 0;
		public var top : Number = 0;
		public var width : Number = 0;
		public var height : Number = 0;

		protected var _sceneEntity : SRenderableEntity;

		public function SBoundingComponent(id : * = null)
		{
			super(id || SBoundingComponent);
		}

		override public function notifyAdded() : void
		{
			super.notifyAdded();
			_sceneEntity = owner as SRenderableEntity;
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			super.destroy();
			_sceneEntity = null;
		}
	}
}