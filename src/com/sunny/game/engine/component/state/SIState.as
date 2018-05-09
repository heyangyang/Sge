package com.sunny.game.engine.component.state
{
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个状态接口
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
	public interface SIState extends SIDestroy
	{
		function enter() : void;
		function exit() : void;
		function execute(elapsedTime : int) : void;
		function set stateMachine(value : SIStateMachine) : void;
		function get type() : uint;
	}
}