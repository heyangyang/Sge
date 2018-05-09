package com.sunny.game.engine.display
{
	import com.sunny.game.engine.ns.sunny_ui;

	import flash.display.Graphics;
	import flash.display.Shape;

	use namespace sunny_ui;

	/**
	 *
	 * <p>
	 * SunnyGame的一个用户界面绘图
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
	public class SShapeDisplay extends SDisplayNode
	{
		private var _shape : Shape;

		public function SShapeDisplay()
		{
			super();
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_shape = new Shape();
			_container.addChild(_shape);
		}

		public function get graphics() : Graphics
		{
			return _shape.graphics;
		}

		override public function destroy() : void
		{
			if (_shape)
			{
				if (_shape.parent)
					_shape.parent.removeChild(_shape);
				_shape = null;
			}
			super.destroy();
		}
	}
}