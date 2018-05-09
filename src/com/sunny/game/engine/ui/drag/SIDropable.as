package com.sunny.game.engine.ui.drag
{
	import com.sunny.game.engine.display.SIDisplayObjectContainer;

	/**
	 *
	 * <p>
	 * SunnyGame的一个可拖动释放接口
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
	public interface SIDropable extends SIDisplayObjectContainer
	{
		/**
		 * 是否允许释放
		 */
		function get dropEnabled() : Boolean;
		function set dropEnabled(value : Boolean) : void;
		/**
		 * 是否打断释放。打断释放时会抛出事件，可以使用事件中提供的方法来决定继续进行释放还是终止这次的行为
		 *
		 */
		function interruptDrop(dragInitiator : SIDragInitiator) : Boolean;
		function get dropData() : *;
		function set dropData(value : *) : void;
	}
}