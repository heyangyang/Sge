package com.sunny.game.engine.lang.thread
{
	import com.sunny.game.engine.core.SBackThreadNotify;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.events.SEventPool;
	import com.sunny.game.engine.events.SThreadEvent;
	import com.sunny.game.engine.fileformat.pak.SAnimationDecoder;
	import com.sunny.game.engine.lang.memory.SObjectPool;

	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerState;
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的一个后台线程
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
	public class SBackThread
	{
		public static const BACK_TO_MAIN_THREAD : String = "backToMainThread";
		protected var worker : Worker;
		protected var mainToBackChannel : MessageChannel;
		protected var backToMainChannel : MessageChannel;
		protected var backThreadNotify : SBackThreadNotify;

		public function SBackThread(notify : SBackThreadNotify = null)
		{
			backThreadNotify = notify;
			initWorker();
		}

		protected function initWorker() : void
		{
			if (backThreadNotify == null)
				backThreadNotify = new SBackThreadNotify();
			worker = Worker.current;
			worker.addEventListener(Event.WORKER_STATE, handleBGWorkerStateChange);
			mainToBackChannel = worker.getSharedProperty(SThreadType.MAIN_TO_BACK_THREAD);
			backToMainChannel = worker.getSharedProperty(SThreadType.BACK_TO_MAIN_THREAD);
			SShellVariables.supportDirectX = worker.getSharedProperty("supportDirectX");
			if (mainToBackChannel)
			{
				mainToBackChannel.addEventListener(Event.CHANNEL_MESSAGE, onMainToBack);
				SEventPool.addEventListener(SThreadEvent.EVENT_BACK_THREAD_SEND, onSendHandler);
			}
		}

		private function handleBGWorkerStateChange(evt : Event) : void
		{
			if (worker.state == WorkerState.TERMINATED)
			{
				throw new Error("主线程挂掉!");
			}
		}

		private var dic : Dictionary = new Dictionary();

		protected function onMainToBack(event : Event) : void
		{
			if (!mainToBackChannel.messageAvailable)
				return;
			var data : * = mainToBackChannel.receive(true);
			if (data is Array)
			{
				var id : String = (data as Array).shift();
				var decoder : SAnimationDecoder = new SAnimationDecoder(id, SShellVariables.supportDirectX);
				//引用一下，防止回收
				dic[id] = decoder;
				decoder.addNotify(onAnimationParserCompleted);
				decoder.addErrorNotify(onAnimationErrorCompleted);
				decoder.loadResource.apply(null, data);
				return;
			}

			var message : SThreadMessage = data as SThreadMessage;
			backThreadNotify.onMessageReceived(message);
			SObjectPool.recycle(message, SThreadMessage);
		}

		/**
		 * 解析成功
		 * @param decoder
		 *
		 */
		private function onAnimationParserCompleted(decoder : SAnimationDecoder) : void
		{
			backToMainChannel.send(decoder.getSendMainThreadMessage());
			decoder.forceDestroy();
			delete dic[decoder.id];
		}

		/**
		 * 解析失败
		 * @param decoder
		 *
		 */
		private function onAnimationErrorCompleted(decoder : SAnimationDecoder) : void
		{
			backToMainChannel.send(decoder.id);
			decoder.forceDestroy();
			delete dic[decoder.id];
		}

		private function onSendHandler(e : SThreadEvent) : void
		{
			send(e.message);
		}

		public function send(message : SThreadMessage) : void
		{
			backToMainChannel.send(message);
			SObjectPool.recycle(message, SThreadMessage);
		}
	}
}