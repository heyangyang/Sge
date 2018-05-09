package com.sunny.game.engine.cfg
{
	import flash.utils.Dictionary;

	public class SConfigDescribe
	{
		/**
		 * 名称
		 */
		public var name : String;
		/**
		 * 字段
		 */
		public var fields : Array;
		/**
		 * 值
		 */
		public var values : Dictionary;
		/**
		 * 字段描述
		 */
		public var fieldDescriptions : Array;

		public function SConfigDescribe()
		{
			name = "";
			fields = [];
			values = new Dictionary();
			fieldDescriptions = [];
		}
	}
}