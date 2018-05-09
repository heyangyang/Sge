package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.lang.destroy.SDestroyUtil;
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * 字符串过滤
	 */
	public class StringFilter extends SObject implements SIDestroy
	{
		protected var _isDisposed : Boolean;

		/**
		 * 构造函数
		 *
		 * @param	target 指定要过滤字符串的对象
		 */
		public function StringFilter(target : IEventDispatcher = null)
		{
			super();
			_isDisposed = false;
			initializeStrings();
			this.target = target;
		}

		//------------------------------------------------------------------------------------------------------------------
		// Chars
		//------------------------------------------------------------------------------------------------------------------

		// 存储所有需要过滤的字符串
		private var _strings : Dictionary = null;

		/**
		 * 添加要过滤掉的字符串
		 *
		 * @param	str 指定的过滤字符串
		 */
		public function addStrings(... strs) : void
		{
			for each (var str : Object in strs)
			{
				if (str is String)
				{
					_strings[str] = true;
				}
			}
		}

		/**
		 * 删除已指定的过滤字符串
		 *
		 * @param	str 要删除的字符串
		 */
		public function removeStrings(... strs) : void
		{
			var numberStrings : int = _strings.length;
			for each (var str : Object in strs)
			{
				if (str is String)
				{
					delete _strings[str];
				}
			}
		}

		/**
		 * 判断是否包含指定的字符串
		 *
		 * @param	str
		 *
		 * @return
		 */
		public function contains(str : String) : Boolean
		{
			return _strings[str] != undefined;
		}

		private function initializeStrings() : void
		{
			_strings = new Dictionary()
		}

		private function destroyStrings() : void
		{
			if (_strings != null)
			{
				SDestroyUtil.breakMap(_strings);
				_strings = null;
			}
		}

		//------------------------------------------------------------------------------------------------------------------
		// Target
		//------------------------------------------------------------------------------------------------------------------

		// 字符串过滤目标
		private var _target : IEventDispatcher = null;

		/**
		 * 指定一个要过滤字符串的对象
		 */
		public function set target(target : IEventDispatcher) : void
		{
			destroyTarget();
			_target = target;
			_target.addEventListener(Event.CHANGE, changeHandler);
		}

		/**
		 * @private
		 */
		public function get target() : IEventDispatcher
		{
			return _target;
		}

		private function changeHandler(event : Event) : void
		{
			if (event.target is TextField)
			{
				var tf : TextField = TextField(event.target);
				var text : String = tf.text;
				var index : int;
				var changed : Boolean;
				while (true)
				{
					changed = false;
					for (var str : String in _strings)
					{
						if ((index = text.indexOf(str)) != -1)
						{
							changed = true;
							text = text.substring(0, index) + text.substring(index + str.length, text.length);
						}
					}

					if (!changed)
					{
						break;
					}
				}

				tf.text = text;
			}
		}

		private function destroyTarget() : void
		{
			if (_target != null)
			{
				_target.removeEventListener(Event.CHANGE, changeHandler);
				_target = null;
			}
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		//------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */
		public function destroy() : void
		{
			destroyTarget();
			destroyStrings();
			_isDisposed = true;
		}
	}
}