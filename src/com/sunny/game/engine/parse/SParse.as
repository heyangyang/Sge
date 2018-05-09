package com.sunny.game.engine.parse
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.utils.SUtil;

	/**
	 * 这个类用于将操作保存为数据
	 *
	 *
	 */
	public class SParse extends SObject implements SIParse
	{
		private var _parent : SIParse;
		private var _children : Array = [];

		public function SParse()
		{
			super();
		}
		
		/** @inheritDoc*/
		public function parse(target : *) : void
		{
			var children : Array = this.children;
			if (children)
			{
				for (var i : int = 0; i < children.length; i++)
					(children[i] as SIParse).parse(target);
			}
		}

		/** @inheritDoc*/
		public function set parent(v : SIParse) : void
		{
			_parent = v;
		}

		public function get parent() : SIParse
		{
			return _parent;
		}

		/** @inheritDoc*/
		public function set children(v : Array) : void
		{
			_children = v;
		}

		public function get children() : Array
		{
			return _children;
		}

		/**
		 * 添加
		 * @param obj
		 *
		 */
		public function addChild(obj : SIParse) : void
		{
			children.push(obj);
			obj.parent = this;
		}

		/**
		 * 删除
		 * @param obj
		 *
		 */
		public function removeChild(obj : SIParse) : void
		{
			SUtil.remove(children, obj);
			obj.parent = null;
		}

		/**
		 * 创建一个由子对象组成的集合
		 *
		 * @param para
		 * @return
		 *
		 */
		public static function create(para : Array) : SParse
		{
			var p : SParse = new SParse();
			for (var i : int = 0; i < para.length; i++)
				p.addChild(para[i]);

			return p;
		}
	}
}