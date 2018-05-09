package com.sunny.game.engine.desc
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个交互描述符
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
	public class SBehaviorDescriptor extends SNodeDescriptor
	{
		private var _priority : int = 0;
		private var _randomize : Boolean = false;
		private var _chance : Number = 0;

		public function SBehaviorDescriptor()
		{
			super();
		}

		public function get randomize() : Boolean
		{
			return _randomize;
		}

		public function set randomize(value : Boolean) : void
		{
			_randomize = value;
		}

		public function get priority() : int
		{
			return _priority;
		}

		public function set priority(value : int) : void
		{
			_priority = value;
		}

		public function get chance() : Number
		{
			return _chance;
		}

		public function set chance(value : Number) : void
		{
			_chance = value;
		}

		override public function readProperties(data : Object) : void
		{
			super.readProperties(data);
			_priority = data["priority"];
			_randomize = data["randomize"];
			_chance = data["chance"];
		}

		override public function writeProperties() : Object
		{
			var result : Object = super.writeProperties();
			result.priority = this.priority;
			result.randomize = this.randomize;
			result.chance = this.chance;
			return result;
		}
	}
}