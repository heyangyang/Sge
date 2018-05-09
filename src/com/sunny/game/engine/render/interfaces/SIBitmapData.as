package com.sunny.game.engine.render.interfaces
{
	import flash.geom.Rectangle;

	public interface SIBitmapData
	{
		function dispose() : void;
		function get width() : int;
		function get height() : int;
		function get rect() : Rectangle;
		function getPixel(x : int, y : int) : uint;
	}
}