package com.sunny.game.engine.display.text
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.ns.sunny_plugin;

	/**
	 *
	 * <p>
	 * SunnyGame的一个文本元素
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
	public class STextElement extends SObject
	{
		sunny_plugin var shortcut : String;
		public var source : Object;
		public var params : Array;
		public var index : int;
		public var cache : Boolean;

		public function STextElement(source : Object = null, params : Array = null, index : int = -1, cache : Boolean = false)
		{
			this.source = source;
			this.params = params;
			this.index = index;
			this.cache = cache;
			sunny_plugin::shortcut = "";
			super();
		}
	}
}