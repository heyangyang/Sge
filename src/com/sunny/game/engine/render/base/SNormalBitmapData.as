package com.sunny.game.engine.render.base
{
	import com.sunny.game.engine.render.interfaces.SIBitmapData;

	import flash.display.BitmapData;

	public class SNormalBitmapData extends BitmapData implements SIBitmapData
	{
		public var name : String;

		public function SNormalBitmapData(width : int, height : int, transparent : Boolean = true, fillColor : uint = 4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}