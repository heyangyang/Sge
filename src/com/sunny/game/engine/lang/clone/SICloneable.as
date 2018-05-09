package com.sunny.game.engine.lang.clone
{

	/**
	 * 可以克隆对象实现的接口。
	 */
	public interface SICloneable
	{
		/**
		 * 克隆对象。
		 *
		 * @return 返回当前对象的克隆。
		 */
		function clone() : *;
	}
}