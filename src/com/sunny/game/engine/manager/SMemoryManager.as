package com.sunny.game.engine.manager
{
	import flash.utils.Dictionary;

	/**
	 * 内存管理
	 * @author yangyang
	 *
	 */
	public class SMemoryManager
	{

		private static var memory : Dictionary = new Dictionary();

		public function SMemoryManager()
		{
		}

		public static function recycle(obj : *, recycleClass : Class) : void
		{
			var resClass : Class = obj["constructor"];
			if (resClass != recycleClass)
				return;
			var tmpArr : Array = memory[resClass];

			if (tmpArr == null || tmpArr.length == 0)
			{
				memory[resClass] = [obj];
				return;
			}
			if (tmpArr.length <= 30 && tmpArr.indexOf(obj) == -1)
			{
				tmpArr.push(obj);
			}
			else
			{
				trace(recycleClass);
			}
		}

		/**
		 * 获得垃圾站的对象
		 * @param resClass
		 * @return
		 *
		 */
		public static function getObject(resClass : Class, param : * = null) : *
		{
			var tmpArr : Array = memory[resClass];
			if (tmpArr == null || tmpArr.length == 0)
			{
				if (param)
					return new resClass(param);
				return new resClass();
			}
			return tmpArr.pop();
		}
	}
}