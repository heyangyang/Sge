package com.sunny.game.engine.operation
{
	import com.sunny.game.engine.events.SOperationEvent;
	import com.sunny.game.engine.utils.core.SHandler;
	

	/**
	 *
	 * <p>
	 * SunnyGame的一个条件判断的操作
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
	public class SJudgmentOper extends SOperation
	{
		/**
		 * 检测函数
		 */
		public var cHandler : SHandler;
		/**
		 * cHandler返回true时执行
		 */
		public var b1 : SOperation;
		/**
		 * cHandler返回false时执行
		 */
		public var b2 : SOperation;

		private var choose : SOperation;

		public function SJudgmentOper(cHandler : * = null, b1 : SOperation = null, b2 : SOperation = null)
		{
			super();
			if (cHandler is SHandler)
				this.cHandler = cHandler;
			else
				this.cHandler = new SHandler(cHandler);

			this.b1 = b1;
			this.b2 = b2;
		}

		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();

			choose = cHandler.call() ? b1 : b2;
			if (choose)
			{
				choose.addEventListener(SOperationEvent.OPERATION_COMPLETE, result);
				choose.addEventListener(SOperationEvent.OPERATION_ERROR, fault);
				choose.execute();
			}
			else
			{
				result();
			}
		}

		/** @inheritDoc*/
		protected override function end(event : * = null) : void
		{
			super.end(event);

			if (choose)
			{
				choose.removeEventListener(SOperationEvent.OPERATION_COMPLETE, result);
				choose.removeEventListener(SOperationEvent.OPERATION_ERROR, fault);
			}
		}
	}
}