package com.sunny.game.engine.events
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.ns.sunny_engine;
	
	import flash.utils.Dictionary;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个基本事件派发器
	 * </p>
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @see SEvent
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public class SEventDispatcher extends SObject implements SIEventDispatcher, SIDestroy
	{
		internal var _eventListeners : Dictionary;
		protected var _isDisposed : Boolean;

		public function SEventDispatcher()
		{
			super();
			_isDisposed = false;
		}

		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void
		{
			if (_eventListeners == null)
				_eventListeners = new Dictionary();

			var listeners : Vector.<Function> = _eventListeners[type] as Vector.<Function>;
			if (listeners == null)
				_eventListeners[type] = new <Function>[listener];
			else if (listeners.indexOf(listener) == -1) // check for duplicates
				listeners.push(listener);
		}

		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void
		{
			if (_eventListeners)
			{
				var listeners : Vector.<Function> = _eventListeners[type] as Vector.<Function>;
				var numListeners : int = listeners ? listeners.length : 0;

				if (numListeners > 0)
				{
					//不能改变原始的列表
					var index : int = 0;
					var restListeners : Vector.<Function> = new Vector.<Function>(numListeners - 1);
					var otherListener : Function;

					for (var i : int = 0; i < numListeners; ++i)
					{
						otherListener = listeners[i];
						if (otherListener != listener)
							restListeners[int(index++)] = otherListener;
					}

					_eventListeners[type] = restListeners;
				}
			}
		}

		public function removeEventListeners(type : String = null) : void
		{
			if (type && _eventListeners)
				delete _eventListeners[type];
			else
				_eventListeners = null;
		}

		public function dispatchEvent(event : SEvent) : void
		{
			var bubbles : Boolean = event.bubbles;

			if (!bubbles && (_eventListeners == null || !(event.type in _eventListeners)))
				return;

			//设置目标之后恢复，允许重新派发事件而不需要克隆

			var previousTarget : SIEventDispatcher = event.target;
			event.setTarget(this);
			invokeEvent(event);

			if (previousTarget)
				event.setTarget(previousTarget);
		}

		internal function invokeEvent(event : SEvent) : Boolean
		{
			var listeners : Vector.<Function> = _eventListeners ? _eventListeners[event.type] as Vector.<Function> : null;
			var numListeners : int = listeners == null ? 0 : listeners.length;

			if (numListeners)
			{
				event.setCurrentTarget(this);
				var listener : Function;
				var numArgs : int;
				//enumerate
				for (var i : int = 0; i < numListeners; ++i)
				{
					listener = listeners[i] as Function;
					numArgs = listener.length;

					if (numArgs == 0)
						listener();
					else if (numArgs == 1)
						listener(event);
					else
						listener(event, event.data);

					if (event.stopsImmediatePropagation)
						return true;
				}

				return event.stopsPropagation;
			}
			else
			{
				return false;
			}
		}

		/**
		 * 使用内部事件池，避免分配 avoid allocations.
		 * @param type
		 * @param data
		 * @param bubbles
		 * @param cancelable
		 *
		 */
		public function dispatchEventWith(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false) : void
		{
			if (bubbles || hasEventListener(type))
			{
				var event : SEvent = SEvent.fromPool(type, data, bubbles, cancelable);
				dispatchEvent(event);
				SEvent.toPool(event);
			}
		}

		public function hasEventListener(type : String) : Boolean
		{
			var listeners : Vector.<Function> = _eventListeners ? _eventListeners[type] as Vector.<Function> : null;
			return listeners ? listeners.length != 0 : false;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_eventListeners)
			{
				for (var type : String in _eventListeners)
				{
					_eventListeners[type] = null;
					delete _eventListeners[type];
				}
				_eventListeners = null;
			}
			_isDisposed = true;
		}
	}
}