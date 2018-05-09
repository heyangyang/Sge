package com.sunny.game.engine.parse
{

	public interface SIParse
	{
		/**
		 * 绘制
		 * @param target
		 *
		 */
		function parse(target : *) : void;

		/**
		 * 子对象
		 * @param v
		 *
		 */
		function get children() : Array;

		/**
		 * 父对象
		 * @param v
		 *
		 */
		function get parent() : SIParse;
		function set parent(v : SIParse) : void;
	}
}