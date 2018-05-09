package com.sunny.game.engine.map
{
	import com.sunny.game.engine.core.SIResizable;
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	import flash.display.BitmapData;

	/**
	 *
	 * <p>
	 * SunnyGame的一个场景地图接口
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
	public interface SISceneMap extends SIResizable, SIDestroy
	{
		function load(mapId : String, onComplete : Function = null, onProgress : Function = null) : void;
		function setViewSize(viewWidth : int, viewHeight : int) : void;
		function run() : void;
		function clear() : void;
		function update(elapsedTime : int = 0) : void;
		function get smallMapBitmapData() : BitmapData;
		function loadSmallMap(inited : Function = null) : void;
		function updateBlocks(mapBlocks : Array = null) : void;
	}
}