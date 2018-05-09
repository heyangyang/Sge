package com.sunny.game.engine.core
{
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个节点接口
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
	public interface SINode extends SIDestroy
	{
		function removeFromParent() : void;
		function addToParent(parent : SINode, index : int = -1) : void;
		function addChildAt(child : SINode, index : int) : SINode;
		function removeChild(child : SINode) : SINode;
		function removeChildAt(index : int) : SINode;
		function addChild(child : SINode) : SINode;
		function getChildAt(index : int) : SINode;
		function get name() : String;
		function set name(value : String) : void;
		function getChildIndex(child : SINode) : int;
		function setChildIndex(child : SINode, index : int) : void;
		function get numChildren() : int;
		function get parent() : SINode;
		function swapChildren(child1 : SINode, child2 : SINode) : void;
		function swapChildrenAt(index1 : int, index2 : int) : void;
		function equals(value : Object) : Boolean;
	}
}