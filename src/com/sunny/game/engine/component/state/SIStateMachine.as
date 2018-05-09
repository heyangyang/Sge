package com.sunny.game.engine.component.state
{
	import com.sunny.game.engine.entity.SIEntity;
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	/**
	 *
	 * <p>
	 * SunnyGame的状态机接口
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
	public interface SIStateMachine extends SIDestroy
	{
		function registerState(stateClass : Class) : SIState;
		function replaceState(stateClass : Class) : SIState;
		function getState(type : uint) : SIState;
		function getStateType(state : SIState) : uint;
		function changeState(type : uint) : void;
		function get currentStateType() : uint;
		function get previousStateType() : uint;
		function get owner() : SIEntity;
	}
}