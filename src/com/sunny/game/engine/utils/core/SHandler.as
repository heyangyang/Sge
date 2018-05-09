package com.sunny.game.engine.utils.core
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.utils.SReflectUtil;

	/**
	 *
	 * <p>
	 * SunnyGame的一个带参函数执行器
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
	public class SHandler extends SObject implements SIDestroy
	{
		public var caller : *;
		public var handler : *;
		public var params : Array;

		private var _toFunction : Function;
		protected var _isDisposed : Boolean;

		/**
		 * 函数执行器
		 *
		 * @param handler	函数（可以使用字符串进行反射，参考ReflectUtil.eval）
		 * @param para	参数数组
		 * @param caller	调用者
		 *
		 */
		public function SHandler(handler : * = null, params : Array = null, caller : * = null)
		{
			super();
			this.handler = handler;
			this.params = params;
			this.caller = caller;

			_isDisposed = false;
		}

		/**
		 * 调用
		 * @return
		 *
		 */
		public function call(... params) : *
		{
			var h : *;
			if (this.handler is String)
				h = SReflectUtil.eval(this.handler.toString());
			else
				h = this.handler;

			if (h is Function)
			{
				if (params && params.length > 0)
					return h.apply(this.caller, params);
				else
					return h.apply(this.caller, this.params);
			}
			else
				return h;
		}

		/**
		 * 转换成Function
		 * @return
		 *
		 */
		public function toFunction() : Function
		{
			if (_toFunction == null)
			{
				_toFunction = function(... parameters) : *
				{
					return call();
				};
			}
			return _toFunction;

		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		/**
		 * 销毁
		 *
		 */
		public function destroy() : void
		{
			_toFunction = null;
			_isDisposed = true;
		}
	}
}