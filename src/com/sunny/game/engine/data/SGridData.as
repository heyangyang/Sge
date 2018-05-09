package com.sunny.game.engine.data
{
	public class SGridData
	{
		public var markType : int;
		public var gridX : int;
		public var gridY : int;
		public var pixelX : int;
		public var pixelY : int;

		public function SGridData(markType : int, gridX : int, gridY : int,pixelX : int,pixelY : int)
		{
			this.markType = markType;
			this.gridX = gridX;
			this.gridY = gridY;
			this.pixelX = pixelX;
			this.pixelY = pixelY;
		}
		
		public function destroy():void
		{
		}
	}
}