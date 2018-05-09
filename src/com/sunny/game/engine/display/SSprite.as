package com.sunny.game.engine.display
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.events.SMouseEvent;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;

	/**
	 *
	 * <p>
	 * SunnyGame的一个Sprite
	 * 这个类实现了光标和提示接口，以及属性变化事件
	 *
	 * 建议全部可视对象都以此类作为基类，而不仅仅是组件。
	 *
	 */
	public class SSprite extends SDirtySprite implements SISprite, SIDestroy
	{
		/**
		 * 可以在使用过程中传递数据
		 */
		protected var _data : *;
		private var _clickTime : int = -1;
		private var _clickEvent : MouseEvent;

		public function SSprite()
		{
			super();
		}

		override protected function init() : void
		{
			focusRect = null;
			cacheAsBitmap = false;
			tabEnabled = false;
			tabChildren = false;
			mouseEnabled = false;
			mouseChildren = false;
			doubleClickEnabled = false;
		}

		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			if (type == SMouseEvent.EVENT_CLICK)
				this.addEventListener(MouseEvent.CLICK, onMouseClickHandler, useCapture, priority, useWeakReference);
			else if (type == SMouseEvent.EVENT_DOUBLE_CLICK)
				this.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClickHandler, useCapture, priority, useWeakReference);
		}

		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void
		{
			super.removeEventListener(type, listener, useCapture);
			if (type == SMouseEvent.EVENT_CLICK)
				this.removeEventListener(MouseEvent.CLICK, onMouseClickHandler, useCapture);
			else if (type == SMouseEvent.EVENT_DOUBLE_CLICK)
				this.removeEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClickHandler, useCapture);
		}

		private function onMouseClickHandler(evt : MouseEvent) : void
		{
			if (doubleClickEnabled)
			{
				if (_clickTime == -1)
				{
					_clickTime = getTimer();
					_clickEvent = evt;
				}
				this.addEventListener(Event.ENTER_FRAME, onMouseEnterFrame, false, 0, true);
			}
			else
				dispatchEvent(new MouseEvent(MouseEvent.CLICK, evt.bubbles, evt.cancelable));
		}
		
		private function onMouseDoubleClickHandler(evt : MouseEvent) : void
		{
			clearClick();
			dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK, evt.bubbles, evt.cancelable));
		}

		private function onMouseEnterFrame(evt : Event) : void
		{
			if (_clickTime != -1 && getTimer() - _clickTime >= 200)
			{
				if (_clickEvent)
				{
					dispatchEvent(new MouseEvent(MouseEvent.CLICK, _clickEvent.bubbles, _clickEvent.cancelable));
				}
				clearClick();
			}
		}

		private function clearClick() : void
		{
			_clickTime = -1;
			_clickEvent = null;
			this.removeEventListener(Event.ENTER_FRAME, onMouseEnterFrame);
		}

		/**
		 * 清除内存，并把自己从父级列表中删除
		 */
		/** @inheritDoc*/
		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			clear();
			clearClick();
			super.destroy();
		}

		/**
		 * 清除当前Sprite上所有的东西
		 *
		 */
		public function clear() : void
		{
			removeAllChildren();
			graphics.clear();
			filters = null;
			mask = null;
			_data = null;
		}

		/**
		 * 清除所有子对象
		 */
		public function removeAllChildren() : void
		{
			while (numChildren > 0)
				this.removeChildAt(0);
		}

		/**
		 * 设置数据
		 * @return
		 *
		 */
		public function get data() : *
		{
			return _data;
		}

		public function set data(value : *) : void
		{
			if (!_data && !value)
				return;
			_data = value;
			dispatchEvent(new Event(SEvent.DATA_CHANGE));
		}

		public function relativeCoordinate(target : DisplayObject) : Point
		{
			var point : Point = new Point(x, y);
			if (target)
			{
				var global : Point = point;
				if (parent)
				{
					global = parent.localToGlobal(point);
					if (target.parent)
						point = target.parent.globalToLocal(global);
				}
			}
			return point;
		}

		/**
		 * 是否成为焦点
		 * @param value
		 *
		 */
		public function set focus(value : Boolean) : void
		{
			if (value)
				SShellVariables.focus = this;
			else
				SShellVariables.focusStage();
		}

		public function get focus() : Boolean
		{
			return SShellVariables.focus == this;
		}
	}
}