package com.sunny.game.engine.lang.exceptions
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	import flash.display.Stage;

	/**
	 * 全局异常。
	 * 是GlobalExceptionHandler的另一个版本
	 */
	public class AdvancedGlobalExceptionHandler extends SObject implements SIDestroy
	{
		private var _stage : Stage = null;

		private var _exceptionHandler : Function = null;

		protected var _isDisposed : Boolean;

		/**
		 * 构造函数
		 *
		 * @param	stage	舞台对象
		 * @param	globalExceptionHandler	异常处理函数，原型func(data:Object):void或func(void)void
		 */
		public function AdvancedGlobalExceptionHandler(stage : Stage, pGlobalExceptionHandler : Function)
		{
			super();
			if (stage == null)
			{
				throw new SNullPointerException("Null stage")
			}
			if (pGlobalExceptionHandler == null)
			{
				throw new SNullPointerException("Null context");
			}
			_isDisposed = false;
			_stage = stage;
			_exceptionHandler = pGlobalExceptionHandler;
			_stage.addEventListener(AdvancedGlobalExceptionEvent.GLOBAL_EXCEPTION, globalExceptionHandler);
		}

		/**
		 * 抛出全局异常事件，将触发处理函数。同样也可以在一个显示对象上抛出全局异常，该显示对象必须在显示列表中
		 *
		 * @param	exception
		 */
		public function throwGlobalException(exception : AdvancedGlobalExceptionEvent) : void
		{
			_stage.dispatchEvent(exception);
		}

		private function globalExceptionHandler(event : AdvancedGlobalExceptionEvent) : void
		{
			_exceptionHandler.length == 0 ? _exceptionHandler() : _exceptionHandler(event.data);
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		//------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------------------

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_stage != null)
			{
				_stage.removeEventListener(AdvancedGlobalExceptionEvent.GLOBAL_EXCEPTION, globalExceptionHandler);
				_stage = null;
				_exceptionHandler = null;
			}
			_isDisposed = true;
		}
	}
}