package com.sunny.game.engine.core
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.enum.SThreadMessageType;
	import com.sunny.game.engine.fileformat.pak.SPakDecoder;
	import com.sunny.game.engine.lang.thread.SThreadMessage;
	import com.sunny.game.rpg.component.SSeekRoadComponent;
	
	import flash.net.registerClassAlias;

	/**
	 *
	 * <p>
	 * SunnyGame的一个主线程消息广播
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
	public class SMainThreadNotify
	{
		private var id : int;
		private var decoder : SPakDecoder;

		public function SMainThreadNotify()
		{
			registerClassAlias("SThreadMessage", SThreadMessage);
		}

		public function onMessageReceived(message : SThreadMessage) : void
		{
			id = message.id;
			switch (message.type)
			{
				case SThreadMessageType.ERROR:
					SDebug.errorPrint(this, "主线程消息接收到后台线程发生错误！" + "\r\n" + message.id);
					break;
				case SThreadMessageType.THREAD_MESSAGE_UNLOAD:
					decoder = SPakDecoder.getPakDecoder(id);
					if (decoder)
						decoder.notifyIOError();
					break;
				case SThreadMessageType.THREAD_MESSAGE_SEEK_ROAD:
					var threadCommandId : int = message.args[0];
					var result : Array = message.args[1];
					var method : String = message.args[2];
					var seek : SSeekRoadComponent = SSeekRoadComponent.getSeeks(id);
					if (seek && !seek.isDisposed && seek.threadCommandId == threadCommandId)
					{
						if (method == "walkToFrontGrid")
							seek.walkByPaths(result, 0, method, message.args[3]);
						else
							seek.walkByPaths(result, 0, method);
					}
					break;
			}
			decoder = null;
		}
	}
}