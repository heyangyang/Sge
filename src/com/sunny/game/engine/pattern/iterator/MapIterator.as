package com.sunny.game.engine.pattern.iterator
{
	public class MapIterator extends ArrayIterator
	{
		public function MapIterator(map:Object)
		{
			var arr:Array = new Array();
			for each(var item:Object in map)
			{
				arr.push(item);
			}
			
			super(arr);
		}
	}
}