package com.sunny.game.engine.core
{
	import com.sunny.game.engine.algorithm.seek.SAStar;
	import com.sunny.game.engine.algorithm.seek.SRoadSeeker;
	import com.sunny.game.engine.enum.SRoadPointType;
	import com.sunny.game.engine.enum.SThreadMessageType;
	import com.sunny.game.engine.events.SThreadEvent;
	import com.sunny.game.engine.fileformat.pak.SPakDecoder;
	import com.sunny.game.engine.lang.memory.SObjectPool;
	import com.sunny.game.engine.lang.thread.SThreadMessage;
	
	import flash.net.registerClassAlias;

	/**
	 *
	 * <p>
	 * SunnyGame的一个后台线程消息广播
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
	public class SBackThreadNotify
	{
		private var id : int;
		private var decoder : SPakDecoder;
		private var resId : String;
		private var blocks : Array;

		public function SBackThreadNotify()
		{
			registerClassAlias("SThreadMessage", SThreadMessage);
		}

		public function onMessageReceived(message : SThreadMessage) : void
		{
			id = message.id;
			switch (message.type)
			{
				//寻路
				case SThreadMessageType.THREAD_MESSAGE_SEEK_ROAD:
					var threadCommandId : int = message.args[0];
					var result : Array;
					var type : String = message.args[1];
					var method : String = message.args[2];

					var startGridX : int = message.args[3];
					var startGridY : int = message.args[4];
					var endGridX : int = message.args[5];
					var endGridY : int = message.args[6];

					if (startGridX == endGridX && startGridY == endGridY)
					{
						var aroundPos : Array = SRoadSeeker.getInstance().getAroundsNoneBlock(endGridX, endGridY);
						if (aroundPos && aroundPos.length > 0)
						{
							var pos : Array = aroundPos[int(aroundPos.length * Math.random())];
							endGridX = pos[0];
							endGridY = pos[1];
						}
					}

					if (type == "find")
						result = SRoadSeeker.getInstance().find(startGridX, startGridY, endGridX, endGridY);
					else if (type == "findAvaliabe")
						result = SRoadSeeker.getInstance().findByAvaliabePoint(startGridX, startGridY, endGridX, endGridY);
					var threadMessage : SThreadMessage = SObjectPool.getObject(SThreadMessage);
					if (!threadMessage)
						threadMessage = new SThreadMessage();
					threadMessage.type = SThreadMessageType.THREAD_MESSAGE_SEEK_ROAD;
					threadMessage.id = id;
					if (method == "walkToFrontGrid")
						threadMessage.args = [threadCommandId, result, method, message.args[7]];
					else
						threadMessage.args = [threadCommandId, result, method];
					SThreadEvent.dispatchEvent(SThreadEvent.EVENT_BACK_THREAD_SEND, threadMessage);
					break;
				case SThreadMessageType.THREAD_MESSAGE_INIT_ASTAR:
					blocks = message.args[0];
					SAStar.getInstance().init(blocks);
					break;
				case SThreadMessageType.THREAD_MESSAGE_SET_BLOCK_BORDER:
					SAStar.getInstance().setBlockBorder(message.args[0], message.args[1], message.args[2], message.args[3]);
					break;
				case SThreadMessageType.THREAD_MESSAGE_ADD_UNWALK_BLOCK:
					SAStar.getInstance().mapBlocks[message.args[0]][message.args[1]] = SRoadPointType.UNWALKABLE_VALUE;
					break;
				case SThreadMessageType.THREAD_MESSAGE_RESET_BLOCKS:
					SAStar.getInstance().init(message.args[0]);
					break;
			}

			id = 0;
			decoder = null;
			resId = null;
			blocks = null;
		}

	}
}