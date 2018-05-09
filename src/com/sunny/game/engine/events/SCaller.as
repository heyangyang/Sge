package com.sunny.game.engine.events
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.utils.SDictionary;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个调用
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
	public class SCaller extends SObject implements SICaller
	{
		private var _isDisposed : Boolean;
		private var _callers : SDictionary;

		public function SCaller()
		{
			super();
			_isDisposed = false;
		}

		public function addCall(type : Object, caller : Function) : void
		{
			if (!_callers)
				_callers = new SDictionary();
			if (!_callers.hasValue(type))
				_callers.setValue(type, new SDictionary());
			var funcs : SDictionary = _callers.getValue(type) as SDictionary;
			funcs.setValue(caller, caller);
		}

		public function removeCall(type : Object, caller : Function) : void
		{
			if (!_callers)
				return;
			var funcs : SDictionary = _callers.getValue(type) as SDictionary;
			if (funcs)
			{
				funcs.deleteValue(caller);
				if (funcs.length == 0)
					_callers.deleteValue(type);
			}
		}

		public function call(type : Object, ... args) : void
		{
			if (!_callers)
				return;
			var funcs : SDictionary = _callers.getValue(type) as SDictionary;
			if (funcs)
			{
				for each (var func : Function in funcs.dic)
				{
					func.apply(null, args);
					if (_isDisposed)
						return;
				}
			}
		}

		sunny_engine function call(type : Object, argArray : Array) : void
		{
			if (!_callers)
				return;
			var funcs : SDictionary = _callers.getValue(type) as SDictionary;
			if (funcs)
			{
				for each (var func : Function in funcs.dic)
				{
					func.apply(null, argArray);
					if (_isDisposed)
						return;
				}
			}
		}

		public function dispose() : void
		{
			if (_isDisposed)
				return;
			if (!_callers)
				return;
			for each (var dic : SDictionary in _callers.dic)
			{
				if (dic)
				{
					dic.clear();
					dic = null;
				}
			}
			_callers.clear();
			_callers = null;
			_isDisposed = true;
		}
	}
}