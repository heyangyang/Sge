package com.sunny.game.engine.events
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	import com.sunny.game.engine.ns.sunny_engine;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个调用池
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
	public class SCallPool
	{
		private static var _instance : SCallPool;

		public static function getInstance() : SCallPool
		{
			if (!_instance)
				_instance = new SCallPool(new Private());
			return _instance;
		}

		private var _caller : SCaller;

		public function SCallPool(access : Private = null)
		{
			if (access != null)
				super();
			else
				throw new SunnyGameEngineError("SCallPool类不能实例化。");

			_caller = new SCaller();
		}

		public function addCall(type : String, caller : Function) : void
		{
			if (_caller)
				_caller.addCall(type, caller);
		}

		public function removeCall(type : String, caller : Function) : void
		{
			if (_caller)
				_caller.removeCall(type, caller);
		}

		public function call(type : String, ... arg) : void
		{
			if (_caller)
				_caller.sunny_engine::call(type, arg);
		}
	}
}

class Private
{
}