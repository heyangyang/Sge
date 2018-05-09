package com.sunny.game.engine.ui
{
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.utils.SUtil;
	import com.sunny.game.engine.manager.SNativeCursorProcessor;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.MouseCursor;

	/**
	 *
	 * <p>
	 * SunnyGame的一个原生光标类
	 * 此类会一直检测鼠标下的物体，实现ICursorManagerClient就会根据其cursor自动弹出。
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
	public class SNativeCursor extends EventDispatcher implements SIDestroy
	{
		/**
		 * 限定触发提示的类型
		 */
		public var onlyWithClasses : Array;
		/**
		 * 舞台
		 */
		public var stage : Stage;
		protected var _cursorProcessor : SNativeCursorProcessor;
		private var target : DisplayObject; //当前鼠标下的对象
		private var buttonDown : Boolean = false; //鼠标是否按下 
		private var _lock : Boolean = false; //锁定鼠标

		public var _textFieldCursor : String = MouseCursor.AUTO;
		public var _buttonCursor : String = MouseCursor.AUTO;

		protected var _isDisposed : Boolean;

		public function SNativeCursor(stage : Stage)
		{
			_isDisposed = false;
			this.stage = stage;
			_cursorProcessor = new SNativeCursorProcessor();

			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, updateButtonDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, updateButtonDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			stage.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		/**
		 * 手动设置光标。此光标将一直存在直到执行removeCursor
		 */
		public function lockCursor(type : String) : void
		{
			_lock = true;
			_cursorProcessor.changeCursor(type);
		}

		/**
		 * 移除光标，恢复自动获取模式
		 */
		public function unlockCursor() : void
		{
			_lock = false;
		}

		/**
		 * 锁定光标
		 * @return
		 *
		 */
		public function get lock() : Boolean
		{
			return _lock;
		}

		public function set lock(value : Boolean) : void
		{
			_lock = value;
		}

		private function mouseMoveHandler(evt : MouseEvent) : void
		{
			updateButtonDownHandler(evt);
			if (!_lock)
				_cursorProcessor.changeCursor(findCursorClass(this.target));
		}

		private function mouseOverHandler(evt : MouseEvent) : void
		{
			this.target = evt.target as DisplayObject;
			updateButtonDownHandler(evt);
		}

		private function mouseOutHandler(evt : MouseEvent) : void
		{
			this.target = null;
			updateButtonDownHandler(evt);
		}

		private function updateButtonDownHandler(evt : MouseEvent) : void
		{
			buttonDown = evt.buttonDown;
		}

		private function findCursorClass(displayObj : DisplayObject) : String
		{
			var currentCursorTarget : DisplayObject = displayObj;

			while (currentCursorTarget && currentCursorTarget.parent != currentCursorTarget)
			{
				//可编辑的文本需要显示编辑框，必须显示设备光标
				if (currentCursorTarget is TextField && TextField(currentCursorTarget).selectable)
					return _textFieldCursor;

				//拥有buttonMode的需要显示手型
				if (currentCursorTarget is Sprite && Sprite(currentCursorTarget).buttonMode == true)
					return _buttonCursor;

				if (currentCursorTarget is SICursor)
				{
					var cursor : * = (currentCursorTarget as SICursor).cursor;
					if (cursor && (onlyWithClasses == null || SUtil.isIn(currentCursorTarget, onlyWithClasses)))
						return cursor;
				}
				currentCursorTarget = currentCursorTarget.parent;
			}
			return null;
		}

		public function get cursorProcessor() : SNativeCursorProcessor
		{
			return _cursorProcessor;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		/** @inheritDoc*/
		public function destroy() : void
		{
			if (_isDisposed)
				return;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, updateButtonDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, updateButtonDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			stage.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_cursorProcessor = null;
			_isDisposed = true;
		}
	}
}