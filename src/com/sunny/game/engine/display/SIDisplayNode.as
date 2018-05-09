package com.sunny.game.engine.display
{
	import com.sunny.game.engine.core.SINode;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	/**
	 *
	 * <p>
	 * SunnyGame的一个显示节点接口
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
	public interface SIDisplayNode extends SINode
	{
		function get width() : Number;
		function set width(value : Number) : void;
		function get height() : Number;
		function set height(value : Number) : void;
		function get x() : Number;
		function set x(value : Number) : void;
		function get y() : Number;
		function set y(value : Number) : void;
		function get mouseX() : Number;
		function get mouseY() : Number;
		function localToGlobal(point : Point) : Point;
		function globalToLocal(point : Point) : Point;
		function set alpha(value : Number) : void;
		function get alpha() : Number;
		function set filters(value : Array) : void;
		function get filters() : Array;
		function set transform(value : Transform) : void;
		function get transform() : Transform;
		function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void;
		function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void;
		function dispatchEvent(event : Event) : Boolean;
		function set mouseChildren(value : Boolean) : void;
		function get mouseChildren() : Boolean;
		function set mouseEnabled(value : Boolean) : void;
		function get mouseEnabled() : Boolean;
		function set buttonMode(value : Boolean) : void;
		function set tabEnabled(value : Boolean) : void;
		function get stage() : Stage;
		function set visible(value : Boolean) : void;
		function get visible() : Boolean;
		function set scaleX(value : Number) : void;
		function get scaleX() : Number;
		function set scaleY(value : Number) : void;
		function get scaleY() : Number;
		function set rotation(value : Number) : void;
		function get rotation() : Number;
		function startDrag(lockCenter : Boolean = false, bounds : Rectangle = null) : void;
		function stopDrag() : void;
		function set blendMode(value : String) : void;
		function get blendMode() : String;
		function getRect(targetCoordinateSpace : SIDisplayNode) : Rectangle;
		function set cacheAsBitmap(value : Boolean) : void;
		function set mask(value : SIDisplayNode) : void;
		function get mask() : SIDisplayNode;
		function set focusRect(value : Object) : void;
		function set tabChildren(value : Boolean) : void;
	}
}