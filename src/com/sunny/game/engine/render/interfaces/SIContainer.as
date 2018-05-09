package com.sunny.game.engine.render.interfaces
{

	public interface SIContainer extends SIDisplay
	{
		function set x(value : Number) : void;
		function set y(value : Number) : void;
		function get x() : Number;
		function get y() : Number;

		function set scaleX(value : Number) : void;
		function set scaleY(value : Number) : void;
		function get scaleX() : Number;
		function get scaleY() : Number;

		function get numChildren() : int;
		function removeGameChildAt(index : int) : void;
		function removeGameChild(child : SIDisplay) : void;
		function addGameChild(child : SIDisplay) : void;
		function addGameChildAt(child : SIDisplay, index : int) : void;
		function getGameChildIndex(child : SIDisplay) : int;
		function setGameChildIndex(child : SIDisplay, index : int) : void;
		
		function get sparent() : SIContainer;
	}
}