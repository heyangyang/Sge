package com.sunny.game.engine.utils
{
	import flash.events.Event;

	/**
	 * 使用函数代理 , 可用于传递参数，也可以使用重写事件传递
	 *  使用方法:
	 *	mc.addEventListener(MouseEvent.MOUSE_CLICK, SFunctionProxy.getProxyFun(onClickHandler,1,"hello"));
	 *	function onClickHandler(e:MouseEvent,...arg) {
	 *	   trace(e)
	 *	   trace(arg)
	 *	}
	 */
	public final class SFunctionProxy
	{
		public static function getProxyFun(func : Function, ... arg) : Function
		{
			var _fun : Function = function(... _arg) : void
			{
				_arg = arg;
				func.apply(null, arg);
			}
			return _fun;
		}

		public static function getEventProxyFun(func : Function, ... arg) : Function
		{
			var _fun : Function = function(e : Event, ... _arg) : void
			{
				_arg = arg;
				_arg.unshift(e);
				func.apply(null, _arg);
			}
			return _fun;
		}
	}

}