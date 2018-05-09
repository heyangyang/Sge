package com.sunny.game.engine.events
{
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.ui.drag.SIDragInitiator;
	import com.sunny.game.engine.ui.drag.SIDropable;

	import flash.events.Event;

	/**
	 *
	 * <p>
	 * SunnyGame的一个拖拽事件
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
	public class SDragEvent extends Event implements SIDestroy
	{
		/**
		 * 开始拖动（可中断）
		 */
		public static const DRAG_START : String = "drag_start";

		/**
		 * 拖动过程中每移动执行一次
		 */
		public static const DRAG_MOVE : String = "drag_move";

		/**
		 * 停止拖动（可中断）
		 */
		public static const DRAG_STOP : String = "drag_stop";

		/**
		 * 有物品拖动到自己之上
		 */
		public static const DRAG_OVER : String = "drag_over";

		/**
		 * 有物品拖离自己
		 */
		public static const DRAG_OUT : String = "drag_out";

		/**
		 * 有物品成功拖到自己身上
		 */
		public static const DRAG_DROP : String = "drag_drop";

		/**
		 * 自己的拖动操作成功完成
		 */
		public static const DRAG_COMPLETE : String = "drag_complete";

		/**
		 * 释放被阻止
		 */
		public static const DROP_INTERRUPTTED : String = "drop_interrupted";

		/**
		 * 拖动的对象
		 */
		public var dragInitiator : SIDragInitiator;
		/**
		 * 落下的对象
		 */
		public var dropTarget : SIDropable;

		protected var _isDisposed : Boolean;

		public function SDragEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			_isDisposed = false;
			super(type, bubbles, cancelable);
		}

		public override function clone() : Event
		{
			var evt : SDragEvent = new SDragEvent(type, bubbles, cancelable);
			evt.dragInitiator = this.dragInitiator;
			evt.dropTarget = this.dropTarget;
			return evt;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			dragInitiator = null;
			dropTarget = null;
			_isDisposed = true;
		}
	}
}