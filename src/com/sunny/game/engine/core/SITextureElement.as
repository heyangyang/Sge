package com.sunny.game.engine.core
{
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	import flash.geom.Rectangle;

	/**
	 *
	 * <p>
	 * SunnyGame的一个贴图元素接口
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
	public interface SITextureElement extends SIDestroy
	{
		function set texture(value : Object) : void;
		function get texture() : Object;
		function get scale9Grid() : Rectangle;
		function set scale9Grid(value : Rectangle) : void;
		function get smoothing() : Boolean;
		function set smoothing(value : Boolean) : void;
		function get isDirty() : Boolean;
		function set isDirty(value : Boolean) : void;
	}
}