package com.sunny.game.engine.enum
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.lang.clone.SCloneUtil;
	import com.sunny.game.engine.ns.sunny_engine;
	
	import flash.utils.Dictionary;

	use namespace sunny_engine;
	
	/**
	 *
	 * <p>
	 * SunnyGame的枚举，"ENUM_"开头
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
	public class SEnum extends SObject
	{
		private var _uniqueId : int;
		private var _incrementFunction : Function;

		public function SEnum()
		{
			_uniqueId = 0;
			_incrementFunction = null;
		}

		private function createUniqueId() : int
		{
			_uniqueId++;
			var value : int = _uniqueId;
			if (_incrementFunction != null)
				value = _incrementFunction(value);
			return value;
		}

		public function init() : void
		{
			var generator : Class = getClass();
			var properties : Dictionary = SCloneUtil.getProperties(generator);
			for (var property : String in properties)
			{
				if (property.indexOf("ENUM_") == 0)
				{
					var uid : int = createUniqueId();
					generator[property] = uid;
				}
			}
		}

		/**
		 *
		 * @param value function(value:int):int
		 *
		 */
		public function set incrementFunction(value : Function) : void
		{
			_incrementFunction = value;
		}
	}
}