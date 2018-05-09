package com.sunny.game.engine.component
{
	import com.sunny.game.engine.entity.SIEntity;
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个组件接口
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
	public interface SIComponent extends SIDestroy
	{
		function get owner() : SIEntity;
		function get type() : *;
		function set owner(value : SIEntity) : void;
		function get additionIndex() : int;
		function set additionIndex(value : int) : void;
		function notifyAdded() : void;
		function notifyRemoved() : void;
		function get enabled() : Boolean;
		function set enabled(value : Boolean) : void;
	}
}