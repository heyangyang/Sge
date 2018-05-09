package com.sunny.game.engine.plugin
{
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个插件接口，所有插件都应实现此接口。
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
	public interface SIPlugin extends SIDestroy
	{
		/**
		 * 安装插件时由target对象调用。
		 * @param target 要安装插件的对象。
		 */
		function setup(target : Object) : Boolean;
		/**
		 * 一个布尔值，指示插件是否启用。
		 */
		function get enabled() : Boolean;
		function set enabled(value : Boolean) : void;
	}
}