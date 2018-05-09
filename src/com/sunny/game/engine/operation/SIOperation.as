package com.sunny.game.engine.operation
{
	import com.sunny.game.engine.events.SIEventDispatcher;
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个操作接口
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
	public interface SIOperation extends SIEventDispatcher, SIDestroy
	{
		/**
		 * 立即执行
		 *
		 */
		function execute() : void

		/**
		 * 成功函数
		 *
		 */
		function result(event : * = null) : void

		/**
		 * 失败函数
		 *
		 */
		function fault(event : * = null) : void

		/**
		 * 推入队列
		 *
		 * @param queue	使用的队列，为空则为默认队列
		 *
		 */
		function commit(queue : SOperQueue = null) : void

		/**
		 * 中断队列
		 *
		 */
		function halt() : void
	}
}