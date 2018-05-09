package com.sunny.game.engine.operation
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.events.SOperationEvent;


	[Event(name="child_operation_start", type="sunny.game.studio.uiEditor.events.OperationEvent")]
	[Event(name="child_operation_complete", type="sunny.game.studio.uiEditor.events.OperationEvent")]
	[Event(name="child_operation_error", type="sunny.game.studio.uiEditor.events.OperationEvent")]

	/**
	 * 队列系统
	 *
	 * 引用defaultQueue将会创建默认queue。而这个默认queue是最常用的，一般情况下不需要再手动创建队列。
	 *
	 *
	 *
	 */
	public class SOperQueue extends SOperation implements SIQueue
	{
		private static var _defaultQueue : SOperQueue;

		/**
		 * 默认队列
		 */
		public static function get defaultQueue() : SOperQueue
		{
			if (!_defaultQueue)
				_defaultQueue = new SOperQueue();

			return _defaultQueue;
		}

		/**
		 * 子Oper数组
		 */
		public var children : Array = [];

		/**
		 * 是否在队列不为空时自动执行
		 */
		public var autoStart : Boolean = true;

		public function SOperQueue(children : Array = null, holdInstance : Boolean = false)
		{
			super();

			this.holdInstance = holdInstance;

			if (!children)
				children = [];

			for (var i : int = 0; i < children.length; i++)
			{
				var obj : SOperation = children[i] as SOperation;
				obj.queue = this;
				obj.step = SOperation.WAIT;
			}
			this.children = children;
		}

		/**
		 * 推入队列
		 *
		 */
		public function commitChild(obj : SOperation) : void
		{
			obj.queue = this;
			obj.step = SOperation.WAIT;
			this.children.length
			if (this == defaultQueue)
				trace("ADD QUEUE")

			children.push(obj);
			if (autoStart && children.length == 1)
				doLoad();
		}

		/**
		 * 移出队列
		 *
		 */
		public function haltChild(obj : SOperation) : void
		{
			obj.queue = null;
			obj.step = SOperation.NONE;

			var index : int = children.indexOf(obj);
			if (index == -1)
				return;

			if (index == 0) //如果正在加载，而跳到下一个
				nexthandler(null);
			else
				children.splice(index, 1);
		}

		private function doLoad() : void
		{
			if (children.length > 0)
			{
				var oper : SOperation = children[0];
				oper.addEventListener(SOperationEvent.OPERATION_START, starthandler);
				oper.addEventListener(SOperationEvent.OPERATION_COMPLETE, nexthandler);
				oper.addEventListener(SOperationEvent.OPERATION_ERROR, nexthandler);
				oper.execute();
			}
			else
			{
				result();
			}
		}

		private function starthandler(event : SOperationEvent) : void
		{
			var oper : SOperation = event.currentTarget as SOperation;
			oper.removeEventListener(SOperationEvent.OPERATION_START, starthandler);

			var e : SOperationEvent = new SOperationEvent(SOperationEvent.CHILD_OPERATION_START);
			e.oper = this;
			e.childOper = oper;
			dispatchEvent(e);
		}

		private function nexthandler(event : SOperationEvent) : void
		{
			var oper : SOperation = children[0] as SOperation;
			oper.removeEventListener(SOperationEvent.OPERATION_START, starthandler);
			oper.removeEventListener(SOperationEvent.OPERATION_COMPLETE, nexthandler);
			oper.removeEventListener(SOperationEvent.OPERATION_ERROR, nexthandler);

			children.shift();

			if (oper.continueWhenFail || !event || event.type == SOperationEvent.OPERATION_COMPLETE)
				doLoad();
			else
				fault(event);

			if (event)
			{
				var e : SOperationEvent = new SOperationEvent(event.type == SOperationEvent.OPERATION_COMPLETE ? SOperationEvent.CHILD_OPERATION_COMPLETE : SOperationEvent.CHILD_OPERATION_ERROR);
				e.oper = this;
				e.childOper = oper;
				e.result = event.result;
				dispatchEvent(e);
			}
		}

		/** @inheritDoc*/
		public override function commit(queue : SOperQueue = null) : void
		{
			if (!queue)
				queue = SOperQueue.defaultQueue;

			if (queue == this)
				SDebug.error("不能将自己推入自己的队列中")
			else
				super.commit(queue);
		}

		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();

			doLoad();
		}

		/** @inheritDoc*/
		public override function halt() : void
		{
			super.halt();

			if (children.length > 0)
			{
				children = children.slice(0, 1);
				(children[0] as SOperation).halt();
			}
		}
	}
}
