package com.sunny.game.engine.entity
{
	import com.sunny.game.engine.component.SIComponent;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.data.SEntityData;

	/**
	 *
	 * <p>
	 * SunnyGame的基础实体接口
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
	public interface SIEntity extends SIDestroy
	{
		function get id() : int;
		function get state() : SIEntityState;
		function get data() : SEntityData;
		function addComponent(comp : SIComponent, priority : int = 0) : int;
		function getComponent(type : *) : SIComponent;
		function removeComponent(comp : SIComponent) : void;
	}
}