package com.sunny.game.engine.basic
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个启动接口
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
	public interface SIStartup
	{
		function start() : void;
		function pause() : void;
		function stop() : void;
		function update() : void;
		function present() : void;
		function get game() : SIGame;
	}
}