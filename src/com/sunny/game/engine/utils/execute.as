package com.sunny.game.engine.utils
{
	/**
	 * 执行方法，如果方法参数不匹配将自动裁剪或填充(null)参数列表 cropped / filled
	 */
	public function execute(func : Function, ... args) : void
	{
		if (func != null)
		{
			var i : int;
			var maxNumArgs : int = func.length;

			for (i = args.length; i < maxNumArgs; ++i)
				args[i] = null;

			func.apply(null, args.slice(0, maxNumArgs));
		}
	}
}
