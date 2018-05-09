package com.sunny.game.engine.events
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个事件派发接口
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
	public interface SIEventDispatcher
	{
		function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void;
		function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void;
		function removeEventListeners(type : String = null) : void;
		function dispatchEvent(event : SEvent) : void;
		function dispatchEventWith(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false) : void;
		function hasEventListener(type : String) : Boolean;
	}
}