package com.sunny.game.engine.display
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.ui.events.base.EventMap;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	/**
	 *
	 * <p>
	 * SunnyGame的一个脏Sprite
	 * 基类，用于对图元进行包装。replace参数为false时将不会对源图元产生影响，可作为单独的控制类使用
	 * replace参数为true时，将会将Skin替换成此类。
	 *
	 * 增加嵌套而不使用逻辑类是考虑到实际应用时更方便，而且可以更容易实现更替内容和旋转等操作。
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
	public class SDirtySprite extends Sprite implements SIDisplayObjectContainer
	{
		private static var _stage : Stage;
		private static var dirtyList : Vector.<SDirtySprite> = new Vector.<SDirtySprite>();

		public static function install(stage : Stage) : void
		{
			if (_stage)
				return;
			_stage = stage;
			if (_stage)
			{
				SShellVariables.nativeStage = _stage;
				_stage.addEventListener(Event.RENDER, renderDirty);
			}
		}

		public static function renderDirty(evt : Event = null) : void
		{
			while (dirtyList.length > 0)
			{
				var ds : SDirtySprite = dirtyList.pop();
				var db : Boolean = (ds._dirty == DIRTY);
				if (db)
					ds.render();
			}
		}

		private static const CLEAN : int = 0; // no changes
		private static const DIRTY : int = 1; // re-rendering needed
		private static const VISIT : int = 2; // was re-rendered, but on list

		private var _eventMap : EventMap;
		/** @private */
		protected var _dirty : int = DIRTY;

		/**
		 * 是否已经被销毁
		 */
		protected var _isDisposed : Boolean = false;

		/**
		 * 是否在移出显示列表的时候删除自身
		 */
		public var destroyWhenRemoved : Boolean = false;

		public function SDirtySprite()
		{
			super();
			dirtyList.push(this);
			init();
			if (stage)
				addedToStageHandler(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}

		/**
		 *
		 * 初始化方法
		 *
		 */
		protected function init() : void
		{
		}

		private function addedToStageHandler(evt : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true); // use weak reference
			if (stage)
			{
				install(stage);
				if (_dirty == DIRTY)
					stage.invalidate();
			}
			addListenerHandler();
			addToStage();
		}

		private function removedFromStageHandler(evt : Event) : void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true); // use weak reference
			_eventMap && _eventMap.unmapListeners();
			removedFromStage();
			if (destroyWhenRemoved)
			{
				destroy();
			}
		}

		/**
		 * 在被加入显示列表时调用
		 *
		 */
		protected function addToStage() : void
		{
		}

		/**
		 * 添加事件
		 *
		 */
		protected function addListenerHandler() : void
		{

		}

		protected function removedFromStage() : void
		{

		}

		/**
		 * 事件管理数据
		 * @return
		 *
		 */
		public function get eventMap() : EventMap
		{
			if (_eventMap == null)
				_eventMap = new EventMap();
			return _eventMap;
		}

		/**
		 * 添加组件事件
		 * @param dispatcher
		 * @param eventString
		 * @param listener
		 * @param eventClass
		 *
		 */
		protected function addViewListener(dispatcher : EventDispatcher, eventString : String, listener : Function, eventClass : Class = null) : void
		{
			if (dispatcher)
				eventMap.mapListener(dispatcher, eventString, listener, eventClass);
		}

		/**
		 * 移除组件事件
		 * @param dispatcher
		 * @param eventString
		 * @param listener
		 * @param eventClass
		 *
		 */
		protected function removeViewListener(dispatcher : EventDispatcher, eventString : String, listener : Function, eventClass : Class = null) : void
		{
			if (dispatcher)
				eventMap.unmapListener(dispatcher, eventString, listener, eventClass);
		}

		public final function dirty() : void
		{
			if (_dirty == DIRTY)
				return;
			_dirty = DIRTY;
			dirtyList.push(this);
			if (stage)
			{
				install(stage);
				stage.invalidate();
			}
		}

		public override function set width(v : Number) : void
		{
			v = Math.round(v);
			super.width = v;
		}

		public override function set height(v : Number) : void
		{
			v = Math.round(v);
			super.height = v;
		}

		public override function get width() : Number
		{
			if (_dirty == DIRTY)
			{
				_dirty = VISIT;
				render();
			}
			return super.width;
		}

		public override function get height() : Number
		{
			if (_dirty == DIRTY)
			{
				_dirty = VISIT;
				render();
			}
			return super.height;
		}

		public override function getRect(targetCoordinateSpace : DisplayObject) : Rectangle
		{
			if (_dirty == DIRTY)
			{
				_dirty = VISIT;
				render();
			}
			return super.getRect(targetCoordinateSpace);
		}

		public override function getBounds(targetCoordinateSpace : DisplayObject) : Rectangle
		{
			if (_dirty == DIRTY)
			{
				_dirty = VISIT;
				render();
			}
			return super.getBounds(targetCoordinateSpace);
		}

		public override function hitTestObject(obj : DisplayObject) : Boolean
		{
			if (_dirty == DIRTY)
			{
				_dirty = VISIT;
				render();
			}
			var ds : SDirtySprite = obj as SDirtySprite;
			if (ds && ds._dirty == DIRTY)
			{
				ds._dirty = VISIT;
				ds.render();
			}
			return super.hitTestObject(obj);
		}

		public override function hitTestPoint(x : Number, y : Number, shapeFlag : Boolean = false) : Boolean
		{
			if (_dirty == DIRTY)
			{
				_dirty = VISIT;
				render();
			}
			return super.hitTestPoint(x, y, shapeFlag);
		}

		public function render() : void
		{
			_dirty = CLEAN;
		}

		/** @inheritDoc */
		public override function toString() : String
		{
			var s : String = super.toString();
			return name == null ? s : s + " \"" + name + "\"";
		}

		public override function set x(v : Number) : void
		{
			v = Math.round(v);
			super.x = v;
		}

		public override function set y(v : Number) : void
		{
			v = Math.round(v);
			super.y = v;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function getClass() : Class
		{
			return this["constructor"];
		}

		/**
		 * 销毁方法
		 *
		 */
		public function destroy() : void
		{
			if (_isDisposed)
				return;

			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

			if (parent && parent.contains(this))
				parent.removeChild(this);
			_eventMap = null;
			_isDisposed = true;
		}
	}
}