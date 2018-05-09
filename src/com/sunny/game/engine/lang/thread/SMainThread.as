package com.sunny.game.engine.lang.thread
{
	import com.sunny.game.engine.core.SMainThreadNotify;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.events.SEventPool;
	import com.sunny.game.engine.events.SThreadEvent;
	import com.sunny.game.engine.fileformat.pak.SAnimationDecoder;
	import com.sunny.game.engine.lang.memory.SObjectPool;
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.parser.SPakResourceParser;
	
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;

	/**
	 *
	 * <p>
	 * SunnyGame的一个主线程
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
	public class SMainThread
	{
		protected var mainToBackChannel : MessageChannel;
		protected var backToMainChannel : MessageChannel;
		protected var backWorker : Worker;
		protected var mainThreadNotify : SMainThreadNotify;
		protected var share_bytes : ByteArray;

		public function SMainThread(notify : SMainThreadNotify = null)
		{
			mainThreadNotify = notify;
			super();
		}

		protected function initWorker(workerBytes : ByteArray) : void
		{
			if (!SShellVariables.isPrimordial)
				return;
			if (!mainThreadNotify)
				mainThreadNotify = new SMainThreadNotify();

			share_bytes = new ByteArray();
			share_bytes.shareable = true;
			share_bytes.writeUTF(SShellVariables.applicationVersion);
			share_bytes.writeUTF(SShellVariables.resourceURL);

			backWorker = WorkerDomain.current.createWorker(workerBytes);
			mainToBackChannel = Worker.current.createMessageChannel(backWorker);
			backToMainChannel = backWorker.createMessageChannel(Worker.current);
			backWorker.setSharedProperty(SThreadType.BACK_TO_MAIN_THREAD, backToMainChannel);
			backWorker.setSharedProperty(SThreadType.MAIN_TO_BACK_THREAD, mainToBackChannel);
			backWorker.setSharedProperty("supportDirectX", SShellVariables.supportDirectX);
			backWorker.setSharedProperty("share_bytes", share_bytes);


			backToMainChannel.addEventListener(Event.CHANNEL_MESSAGE, onBackToMain, false, 0, true);
			SEventPool.addEventListener(SThreadEvent.EVENT_MAIN_THREAD_SEND, onSendHandler);
			SEventPool.addEventListener(SThreadEvent.LOAD_SEND, onLoadSend);
			backWorker.addEventListener(Event.WORKER_STATE, handleBGWorkerStateChange);
			backWorker.start();

			SDebug.infoPrint(this, "主线程初始化...");
		}

		private function handleBGWorkerStateChange(evt : Event) : void
		{
			if (backWorker.state == WorkerState.TERMINATED)
			{
				throw new Error("线程挂掉了!" + SShellVariables.isPrimordial);
			}
		}

		protected function onBackToMain(event : Event) : void
		{
			if (!backToMainChannel.messageAvailable)
				return;
			var message : * = backToMainChannel.receive(true);
			if (message is SThreadMessage)
			{
				mainThreadNotify.onMessageReceived(message);
				SObjectPool.recycle(message, SThreadMessage);
			}
			else if (message is Array)
			{
				parse(message);
			}
			else
			{
				if(SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "parseId failed:" + message);
				SPakResourceParser.removeLoadMessage(message);
				SPakResourceParser.sendLoadMessage();
			}
		}

		private function parse(message : Array) : void
		{
			var id : String = message[0];
			var decoder : SAnimationDecoder = SReferenceManager.getInstance().createDirectAnimationDeocder(id, SShellVariables.supportDirectX);
			decoder.parseBackThreadMessage(message);
			//这次使用时临时创建，不会引用，一定记得释放
			decoder.release();
			decoder.notifyAll();
			SPakResourceParser.removeLoadMessage(id);
			SPakResourceParser.sendLoadMessage();
		}

		private function onLoadSend(e : SThreadEvent) : void
		{
			mainToBackChannel.send(e.data);
		}

		private function onSendHandler(e : SThreadEvent) : void
		{
			send(e.message);
		}

		public function send(message : SThreadMessage) : void
		{
			mainToBackChannel.send(message);
			SObjectPool.recycle(message, SThreadMessage);
		}
	}
}