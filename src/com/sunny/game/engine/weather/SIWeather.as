package com.sunny.game.engine.weather
{
	import com.sunny.game.engine.core.SIResizable;

	/**
	 *
	 * <p>
	 * SunnyGame的天气接口
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
	public interface SIWeather extends SIResizable
	{
		function scroll(viewX : Number, viewY : Number) : void;
		function start() : void;
		function stop() : void;
		function show() : void;
		function hide() : void;
		function destroy() : void;
		function get level() : int;
		function set level(value : int) : void;
		function get name() : String;
		function set name(value : String) : void;
		function get isRunning() : Boolean;
	}
}