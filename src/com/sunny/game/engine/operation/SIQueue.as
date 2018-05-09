package com.sunny.game.engine.operation
{

	public interface SIQueue extends SIOperation
	{
		/**
		 * 推入队列
		 *
		 */
		function commitChild(obj : SOperation) : void

		/**
		 * 移出队列
		 *
		 */
		function haltChild(obj : SOperation) : void
	}
}