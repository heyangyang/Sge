package com.sunny.game.engine.net
{

	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.utils.SByteArray;
	
	import flash.events.ProgressEvent;
	import flash.net.ObjectEncoding;
	import flash.net.Socket;
	import flash.utils.Endian;

	/**
	 *
	 * <p>
	 * 一个套接字
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
	public class SSocket extends Socket
	{
		private var nextMessageLength : uint = 0;

		private var onMessageArrived : Function;

		private var bytes : SByteArray = new SByteArray();

		public function SSocket()
		{
			objectEncoding = ObjectEncoding.AMF3;
			endian = Endian.BIG_ENDIAN;
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}



		private function socketDataHandler(event : ProgressEvent) : void
		{
			if (nextMessageLength > 0)
			{
				if (nextMessageLength <= 1)
					SDebug.errorPrint(this, "length=1");
				if (bytesAvailable >= nextMessageLength)
				{
					readMessage(nextMessageLength);
					nextMessageLength = 0;
				}
			}

			var length : uint;
			while (nextMessageLength == 0 && bytesAvailable >= 2)
			{
				length = readUnsignedShort();
				if (length <= 0)
				{
					SDebug.errorPrint(this, "length=0");
					continue;
				}

				if (bytesAvailable >= length)
				{
					readMessage(length);
				}
				else
				{
					nextMessageLength = length;
					return;
				}
			}
		}

		private function readMessage(length : uint) : void
		{
			bytes.clear();
			readBytes(bytes, 0, length);
			onMessageArrived(bytes);
		}

		public function notifyMessageArrived(onMessageArrived : Function) : void
		{
			this.onMessageArrived = onMessageArrived;
		}

		public function clearMessageNotify() : void
		{
			onMessageArrived = null;
		}
	}
}