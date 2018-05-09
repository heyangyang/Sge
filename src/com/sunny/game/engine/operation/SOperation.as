package com.sunny.game.engine.operation
{
	import com.sunny.game.engine.events.SEventDispatcher;
	import com.sunny.game.engine.events.SOperationEvent;
	import com.sunny.game.engine.utils.core.SAbstractUtil;
	
	import flash.utils.Dictionary;

	[Event(name="operation_start", type="sunny.game.studio.uiEditor.events.OperationEvent")]
	[Event(name="operation_complete", type="sunny.game.studio.uiEditor.events.OperationEvent")]
	[Event(name="operation_error", type="sunny.game.studio.uiEditor.events.OperationEvent")]

	/**
	 * 队列基类
	 *
	 * 队列可使用Queue（顺序加载）或者GroupOper（并发加载）启动。加载队列本身同时也是一个加载器。
	 *
	 * 事件调用顺序：result -> resultFuncition -> end -> 触发OPERATION_COMPLETE事件 -> 触发队列的CHILD_OPERATION_COMPLETE -> 执行下个队列
	 * 重写result方法要注意它的super.result会立即启动下个队列，因此需要放在最后（如果没有队列则会中断）。或者用重写resultFuncition代替，它一定是在队列切换前执行的。
	 * 而end方法无论成功或者失败都已经执行，可以在此放置回收代码。
	 *
	 * SSpawn要求动作本身是可以同时执行的，比如：移动式翻转、变色、缩放等。需要特别注意的是，同步执行最后完成的时间由基本动作中用时最大者决定。
   * SSequence
					 * 序列的使用非常简单，该类从CCActionInterval派生，本身就可以被CCNode对象执行。该类的作用就是线性排列若干个动作，然后按先后次序逐个执行。
	 *
	 */
	public class SOperation extends SEventDispatcher implements SIOperation
	{
		public static const NONE : int = 0;
		public static const WAIT : int = 1;
		public static const RUN : int = 2;
		public static const END : int = 3;

		private static var instances : Dictionary = new Dictionary(); //维持实例字典

		public function SOperation()
		{
			super();
			SAbstractUtil.preventConstructor(this, SOperation);
		}

		/**
		 * 标示
		 */
		public var id : String;

		/**
		 * 当前所处的队列
		 */
		public var queue : SIQueue;

		/**
		 * 当前状态
		 */
		public var step : int = NONE;

		/**
		 * 最后一次的结果
		 */
		public var lastResult : *;

		/**
		 * 是否不等待而立即执行下一个Oper
		 */
		public var immediately : Boolean = false;

		/**
		 * 是否在出错的时候继续队列
		 */
		public var continueWhenFail : Boolean = true;

		/**
		 * 是否在执行期间维持自身实例（必须在执行前设置）
		 */
		public var holdInstance : Boolean = false;

		/**
		 * 立即执行
		 *
		 */
		public function execute() : void
		{
			var e : SOperationEvent = new SOperationEvent(SOperationEvent.OPERATION_START);
			e.oper = this;
			dispatchEvent(e);

			step = RUN;

			if (holdInstance)
				instances[this] = true;

			if (immediately) //立即执行则立即触发完成事件
			{
				e = new SOperationEvent(SOperationEvent.OPERATION_COMPLETE);
				e.oper = this;
				dispatchEvent(e);
			}
		}

		/**
		 * 调用成功函数
		 *
		 */
		public function result(event : * = null) : void
		{
			lastResult = event;

			resultFunction(event);
			end(event);

			var e : SOperationEvent = new SOperationEvent(SOperationEvent.OPERATION_COMPLETE);
			e.oper = this;
			e.result = event;
			dispatchEvent(e);

			this.queue = null;

			step = END;
		}

		/**
		 * 调用失败函数
		 *
		 */
		public function fault(event : * = null) : void
		{
			lastResult = event;

			failFunction(event);
			end(event);

			var e : SOperationEvent = new SOperationEvent(SOperationEvent.OPERATION_ERROR);
			e.oper = this;
			e.result = event;
			dispatchEvent(e);

			this.queue = null;

			step = END;
		}

		/**
		 * 推入队列
		 *
		 * @param queue	使用的队列，为空则为默认队列
		 *
		 */
		public function commit(queue : SOperQueue = null) : void
		{
			if (!queue)
				queue = SOperQueue.defaultQueue;

			queue.commitChild(this);
		}

		/**
		 * 成功函数
		 * @param event
		 *
		 */
		protected function resultFunction(event : * = null) : void
		{

		}

		/**
		 * 失败函数
		 * @param event
		 *
		 */
		protected function failFunction(event : * = null) : void
		{

		}

		/**
		 * 结束函数
		 * @param event
		 *
		 */
		protected function end(event : * = null) : void
		{
			if (holdInstance)
				delete instances[this];
		}

		/**
		 * 中断队列
		 *
		 */
		public function halt() : void
		{
			end();

			if (queue)
				queue.haltChild(this);
		}
	}
}