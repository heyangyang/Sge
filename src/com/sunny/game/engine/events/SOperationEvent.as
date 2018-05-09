package com.sunny.game.engine.events
{
	import com.sunny.game.engine.operation.SOperation;

	/**
	 * 队列事件
	 *
	 *
	 *
	 */
	public class SOperationEvent extends SEvent
	{
		/**
		 * 开始
		 */
		public static const OPERATION_START : String = "operation_start";

		/**
		 * 请求完成
		 */
		public static const OPERATION_COMPLETE : String = "operation_complete";

		/**
		 * 请求失败
		 */
		public static const OPERATION_ERROR : String = "operation_error";

		/**
		 * 子对象开始
		 */
		public static const CHILD_OPERATION_START : String = "child_operation_start";

		/**
		 * 子对象请求完成
		 */
		public static const CHILD_OPERATION_COMPLETE : String = "child_operation_complete";

		/**
		 * 子对象请求失败
		 */
		public static const CHILD_OPERATION_ERROR : String = "child_operation_error";

		/**
		 * 加载器
		 */
		public var oper : SOperation;

		/**
		 * 子加载器
		 */
		public var childOper : SOperation;

		/**
		 * 返回结果
		 */
		public var result : *;

		public function SOperationEvent(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

		public override function clone() : SEvent
		{
			var evt : SOperationEvent = new SOperationEvent(type, bubbles, cancelable);
			evt.oper = this.oper;
			evt.childOper = this.childOper;
			evt.result = this.result;
			return evt;
		}
	}
}