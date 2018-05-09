package com.sunny.game.engine.pattern.observer
{
	/**
	 * 观察者接口
	 */
	public interface IObserver
	{
		/**
		 * 更新
		 * 
		 * @param data
		 */		
		function update(data:Object = null):void; 
	}
}