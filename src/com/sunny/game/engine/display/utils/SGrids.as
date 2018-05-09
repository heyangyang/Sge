package com.sunny.game.engine.display.utils
{
	import com.sunny.game.engine.display.SSprite;

	/**
	 *
	 * <p>
	 * SunnyGame的一个网格
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
	public class SGrids extends SSprite
	{
		private var _totalHeight : uint = 100;
		private var _totalWidth : uint = 100;

		public function SGrids()
		{
			super();
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}

		override public function render() : void
		{
			super.render();

			var rows : int = Math.ceil(_totalHeight / 5);
			var column : int = Math.ceil(_totalWidth / 5);
			generate(rows, column, 5, 5);
		}

		private function generate(rows : Number, column : Number, w : Number = 5, h : Number = 5) : void
		{
			clear();
			var totalWidth : Number = column * w;
			var totalHeight : Number = rows * h;
			for (var i : int = 0; i < totalWidth; i++)
			{
				for (var j : int = 0; j < totalHeight; j++)
				{
					if (i % 2 == 0)
					{
						if (j % 2 == 0)
							graphics.beginFill(0xcccccc);
						else
							graphics.beginFill(0x999999);
					}
					else
					{
						if (j % 2 == 0)
							graphics.beginFill(0x999999);
						else
							graphics.beginFill(0xcccccc);
					}
					graphics.drawRect(i * w, j * h, w, h);
					graphics.endFill();
				}
			}
		}

		public function get totalHeight() : uint
		{
			return _totalHeight;
		}

		public function set totalHeight(value : uint) : void
		{
			if (_totalHeight == value)
				return;
			_totalHeight = value;
			dirty();
		}

		public function get totalWidth() : uint
		{
			return _totalWidth;
		}

		public function set totalWidth(value : uint) : void
		{
			if (_totalWidth == value)
				return;
			_totalWidth = value;
			dirty();
		}
	}
}