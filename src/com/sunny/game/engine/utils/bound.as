package com.sunny.game.engine.utils
{
	import flash.geom.Rectangle;

	public function bound(dest : Rectangle, left : int, top : int, width : int, height : int) : void
	{
		var right : int = left + width;
		var bottom : int = top + height;
		if (left < dest.left)
			dest.left = left;
		if (top < dest.top)
			dest.top = top;
		if (right > dest.right)
			dest.right = right;
		if (bottom > dest.bottom)
			dest.bottom = bottom;
	}
}