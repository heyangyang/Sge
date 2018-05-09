package com.sunny.game.engine.events
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.display.SIData;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.ns.sunny_engine;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个基本事件，包含常用事件类型(Event type)
	 * </p>to
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @see SIEventDispatcher
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public class SEvent extends SObject implements SIData, SIDestroy
	{
		private static var eventPool : Vector.<SEvent> = new <SEvent>[];

		/**
		 * 显示对象添加到父对象
		 */
		public static const ADDED : String = "added";
		/**
		 * 显示对象添加到舞台
		 */
		public static const ADDED_TO_STAGE : String = "addedToStage";
		/**
		 * 进入帧
		 */
		public static const ENTER_FRAME : String = "enterFrame";
		/**
		 * 显示对象从父对象移除
		 * 执行destory方法时触发的事件（可中断，若是直接被removeChild，即使触发了这个事件也无法中断了）
		 */
		public static const REMOVED : String = "removed";
		/**
		 * 显示对象从舞台移除
		 */
		public static const REMOVED_FROM_STAGE : String = "removedFromStage";
		/**
		 * 触发事件
		 */
		public static const TRIGGERED : String = "triggered";
		/**
		 * 显示对象 is being flattened.
		 */
		public static const FLATTEN : String = "flatten";
		/**
		 * 调整尺寸
		 */
		public static const RESIZE : String = "resize";

		public static const MOUSE_LEAVE : String = "mouseLeave";

		/**
		 * 完成事件
		 */
		public static const COMPLETE : String = "complete";

		/**
		 * stage3D rendering context 创建完成(re)created
		 */
		public static const CONTEXT3D_CREATE : String = "context3DCreate";
		/**
		 * 显示对象的根创建
		 */
		public static const ROOT_CREATED : String = "rootCreated";

		/**
		 * 上下文丢失(context loss)之后通知资源管理AssetManager
		 */
		public static const TEXTURES_RESTORED : String = "texturesRestored";

		/**
		 * 动画对象(animated object)请求从动画移除
		 */
		public static const REMOVE_FROM_ANIMATION : String = "removeFromAnimation";
		/**
		 * 更新事件
		 */
		public static const UPDATE_COMPLETE : String = "update_complete";

		/**
		 * 创建完毕
		 */
		public static const CREATE_COMPLETE : String = "create_complete";

		/**
		 * 刷新事件
		 */
		public static const REFRESH_COMPLETE : String = "refresh_complete"

		/**
		 * 显示事件（可中断）
		 */
		public static const SHOW : String = "show";

		/**
		 * 隐藏事件（可中断）
		 */
		public static const HIDE : String = "hide";

		/**
		 * 数据变化
		 */
		public static const DATA_CHANGE : String = "data_change";

		/**
		 * 屏幕激活
		 */
		public static const ACTIVATE : String = "activate";
		/**
		 * 屏幕休眠
		 */
		public static const DEACTIVATE : String = "deactivate";

		public static const CHANGE : String = "change";

		public static const CANCEL : String = "cancel";

		public static const SCROLL : String = "scroll";

		public static const OPEN : String = "open";

		public static const CLOSE : String = "close";

		public static const SELECT : String = "select";

		private var _target : SIEventDispatcher;
		private var _currentTarget : SIEventDispatcher;
		private var _type : String;
		private var _bubbles : Boolean;
		private var _cancelable : Boolean;
		private var _stopsPropagation : Boolean;
		private var _stopsImmediatePropagation : Boolean;
		private var _isDefaultPrevented : Boolean;

		/**
		 * 可携带data
		 */
		protected var _data : *;
		protected var _isDisposed : Boolean;

		private var mVisitedObjects : Vector.<SEventDispatcher>;

		public function SEvent(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super();
			_type = type;
			_bubbles = bubbles;
			_cancelable = cancelable;
			_data = data;

			_target = null;
			_currentTarget = null;
			_stopsPropagation = false;
			_stopsImmediatePropagation = false;
			_isDefaultPrevented = false;

			_isDisposed = false;
		}

		public function dispatch() : void
		{
			SEventPool.getInstance().dispatchEvent(this);
		}

		/**
		 * 派发/分发自定义冒泡链，在事件期间，每个对象只访问一次
		 * @param chain
		 *
		 */
		sunny_engine function dispatchBubbles(chain : Vector.<SEventDispatcher>) : void
		{
			if (chain && chain.length)
			{
				if (!mVisitedObjects)
					mVisitedObjects = new <SEventDispatcher>[];
				var chainLength : int = bubbles ? chain.length : 1;
				var previousTarget : SIEventDispatcher = target;
				setTarget(chain[0] as SEventDispatcher);

				for (var i : int = 0; i < chainLength; ++i)
				{
					var chainElement : SEventDispatcher = chain[i] as SEventDispatcher;
					if (mVisitedObjects.indexOf(chainElement) == -1)
					{
						var stopPropagation : Boolean = chainElement.invokeEvent(this);
						mVisitedObjects[mVisitedObjects.length] = chainElement;
						if (stopPropagation)
							break;
					}
				}
				setTarget(previousTarget);
			}
		}

		public function get data() : *
		{
			return _data;
		}

		public function set data(value : *) : void
		{
			_data = value;
		}

		/**
		 * 是否冒泡
		 * @return
		 *
		 */
		public function get bubbles() : Boolean
		{
			return _bubbles;
		}

		public function get cancelable() : Boolean
		{
			return _cancelable;
		}

		/**
		 * 派发事件的对象
		 * @return
		 *
		 */
		public function get target() : SIEventDispatcher
		{
			return _target;
		}

		/**
		 * 当前冒泡的对象
		 * @return
		 *
		 */
		public function get currentTarget() : SIEventDispatcher
		{
			return _currentTarget;
		}

		/**
		 * 事件标识identifies
		 * @return
		 *
		 */
		public function get type() : String
		{
			return _type;
		}

		// properties for internal use

		/** @private */
		internal function setTarget(value : SIEventDispatcher) : void
		{
			_target = value;
		}

		/** @private */
		internal function setCurrentTarget(value : SIEventDispatcher) : void
		{
			_currentTarget = value;
		}

		/** @private */
		internal function setData(value : Object) : void
		{
			_data = value;
		}

		/** @private */
		internal function get stopsPropagation() : Boolean
		{
			return _stopsPropagation;
		}

		/** @private */
		internal function get stopsImmediatePropagation() : Boolean
		{
			return _stopsImmediatePropagation;
		}

		// prevent default
		/**
		 * 取消事件的默认行为。
		 *
		 */
		public function preventDefault() : void
		{
			if (_cancelable)
				_isDefaultPrevented = true;
		}

		/**
		 * 检查是否preventDefault()方法被调用
		 * @return
		 *
		 */
		public function isDefaultPrevented() : Boolean
		{
			return _isDefaultPrevented;
		}

		public function clone() : SEvent
		{
			var evt : SEvent = new SEvent(_type, _data, _bubbles, _cancelable);
			return evt;
		}

		public static function dispatchEvent(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false) : void
		{
			var event : SEvent = SEvent.fromPool(type, data, bubbles, cancelable);
			event.dispatch();
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			_type = null;
			_bubbles = false;
			_cancelable = false;
			_data = null;

			_target = null;
			_currentTarget = null;
			_stopsPropagation = false;
			_stopsImmediatePropagation = false;
			_isDefaultPrevented = false;

			if (mVisitedObjects)
			{
				mVisitedObjects.length = 0;
				mVisitedObjects = null;
			}
			_isDisposed = true;
		}

		/**
		 * Prevents阻止侦听者在listeners下一个冒泡阶段the next bubble stage接收事件receiving the event
		 *
		 */
		public function stopPropagation() : void
		{
			_stopsPropagation = true;
		}

		/**
		 * Prevents阻止任何侦听者listeners接收事件receiving the event
		 *
		 */
		public function stopImmediatePropagation() : void
		{
			_stopsPropagation = _stopsImmediatePropagation = true;
		}

		// event pooling

		/** @private */
		sunny_engine static function fromPool(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false) : SEvent
		{
			if (eventPool.length > 0)
				return eventPool.pop().reset(type, data, bubbles, cancelable);
			else
				return new SEvent(type, data, bubbles, cancelable);
		}

		/** @private */
		sunny_engine static function toPool(event : SEvent) : void
		{
			event._data = event._target = event._currentTarget = null;
			eventPool[eventPool.length] = event; // avoiding 'push'
		}

		/** @private */
		sunny_engine function reset(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false) : SEvent
		{
			_type = type;
			_bubbles = bubbles;
			_cancelable = cancelable;
			_data = data;
			_target = _currentTarget = null;
			_stopsPropagation = _stopsImmediatePropagation = false;
			return this;
		}
	}
}