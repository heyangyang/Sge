package com.sunny.game.engine.render.interfaces
{
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	import flash.geom.ColorTransform;

	/**
	 *
	 * <p>
	 * SunnyGame的渲染数据接口
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
	public interface SIRenderData extends SIDestroy
	{
		function dispose(clearMemory : Boolean = false) : void;
		function notifyAddedToRender() : void;
		function notifyRemovedFromRender() : void;
		function addChild(child : SIRenderData) : SIRenderData;
		function addChildAt(child : SIRenderData, index : int) : SIRenderData;
		function removeChild(child : SIRenderData) : SIRenderData;
		function removeChildAt(index : int) : SIRenderData;
		function getChildAt(index : int) : SIRenderData;
		function getChildIndex(child : SIRenderData) : int;
		function getChildByName(name : String) : SIRenderData;
		function removeAllChildren() : void;
		function get children() : Vector.<SIRenderData>;
		function get numChildren() : int;
		function get parent() : SIRenderData;
		function set parent(value : SIRenderData) : void;
		function get render() : SIBitmap;
		function set render(value : SIBitmap) : void;
		function get rendable() : Boolean;
		function get isRendering() : Boolean;
		function rotate(rotate : Number, rotatePointX : Number = 0, rotatePointY : Number = 0) : void;
		function get x() : Number;
		function set x(value : Number) : void;
		function get y() : Number;
		function set y(value : Number) : void;
		function get width() : Number;
		function set width(value : Number) : void;
		function get height() : Number;
		function set height(value : Number) : void;
		function get scaleX() : Number;
		function set scaleX(value : Number) : void;
		function get scaleY() : Number;
		function set scaleY(value : Number) : void;
		function get alpha() : Number;
		function set alpha(value : Number) : void;
		function get filters() : Array;
		function set filters(value : Array) : void;
		function get rotation() : Number;
		function set rotation(value : Number) : void;
		function get rotatePointX() : Number;
		function set rotatePointX(value : Number) : void;
		function get rotatePointY() : Number;
		function set rotatePointY(value : Number) : void;
		function get blendMode() : String;
		function set blendMode(value : String) : void;
		function get colorTransform() : ColorTransform;
		function set colorTransform(value : ColorTransform) : void;

		function set bitmapData(value : SIBitmapData) : void;
		function get bitmapData() : SIBitmapData;

		function get depth() : int;
		function set depth(value : int) : void;
		function get layer() : int;
		function set layer(value : int) : void;
		function get order() : int;
		function set order(value : int) : void;
		function get visible() : Boolean;
		function set visible(value : Boolean) : void;
		function get name() : String;
		function set name(value : String) : void;
		function set alphaMultiplier(value : Number) : void;
		function get alphaMultiplier() : Number;
		function recycle() : void;
	}
}