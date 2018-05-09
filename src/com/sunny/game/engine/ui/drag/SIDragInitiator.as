package com.sunny.game.engine.ui.drag
{
	import com.sunny.game.engine.display.SIDisplayObjectContainer;

	/**
	 *
	 * <p>
	 * SunnyGame的一个拖动发起者接口
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
	public interface SIDragInitiator extends SIDisplayObjectContainer
	{
		/**
		 * 是否允许拖动
		 */
		function get dragEnabled() : Boolean;
		function set dragEnabled(value : Boolean) : void;
		/**
		 * 成功在目标上释放时的响应
		 * @param dropable
		 * @param interrupted 被阻止
		 *
		 */
		function dropResponse(dropable : SIDropable, interrupted : Boolean) : void;
		function get dragData() : *;
		function set dragData(value : *) : void;
	}
}