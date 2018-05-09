package com.sunny.game.engine.net
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	import com.sunny.game.engine.utils.SByteArray;

	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * 一个消息广播器
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
	public class SNotifier implements SINotifier
	{
		private var _handlers : Dictionary;

		public function SNotifier()
		{
			_handlers = new Dictionary();
		}

		public function onReceiveMessage(protocalId : int, buffer : SByteArray) : void
		{
			var handler : Function = _handlers[protocalId];
			if (handler != null)
				handler(buffer);
		}

		/**
		 *
		 * @param protocalId
		 * @param handler function(buffer : SByteArray):void
		 *
		 */
		public function bindingHandler(protocalId : int, handler : Function) : void
		{
			if (_handlers[protocalId])
			{
				throw new SunnyGameEngineError("协议" + protocalId + "已经绑定处理方法！");
				return;
			}
			_handlers[protocalId] = handler;
		}
	}
}