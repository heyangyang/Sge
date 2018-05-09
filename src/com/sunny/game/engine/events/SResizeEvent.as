package com.sunny.game.engine.events
{

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/** A ResizeEvent is dispatched by the stage when the size of the Flash container changes.
	 *  Use it to update the Starling viewport and the stage size.
	 *
	 *  <p>The event contains properties containing the updated width and height of the Flash
	 *  player. If you want to scale the contents of your stage to fill the screen, update the
	 *  <code>Starling.current.viewPort</code> rectangle accordingly. If you want to make use of
	 *  the additional screen estate, update the values of <code>stage.stageWidth</code> and
	 *  <code>stage.stageHeight</code> as well.</p>
	 *
	 *  @see com.sunny.game.engine.gpu.display.Stage
	 *  @see com.sunny.game.engine.gpu.core.Starling
	 */

	/**
	 * 缩放事件
	 *
	 *
	 *
	 */
	public class SResizeEvent extends SEvent
	{
		/** 调整大小（大小变化）事件类型 */
		public static const RESIZE : String = "resize";
		/**
		 * 子对象大小变化
		 */
		public static const CHILD_RESIZE : String = "child_resize";

		/**
		 * 缩放前的大小
		 */
		public var lastSize : Point;
		/**
		 * 缩放后新的大小
		 */
		public var size : Point;

		/**
		 * 变化大小的子对象
		 */
		public var child : DisplayObject;

		/** Creates a new ResizeEvent. */
		public function SResizeEvent(type : String, width : int, height : int, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			size = new Point(width, height);
			super(type, size, bubbles, cancelable);
		}

		/** The updated width of the player. */
		public function get width() : int
		{
			return size.x;
		}

		/** The updated height of the player. */
		public function get height() : int
		{
			return size.y;
		}

		public override function clone() : SEvent
		{
			var evt : SResizeEvent = new SResizeEvent(type, width, height, bubbles, cancelable);
			evt.lastSize = this.lastSize;
			evt.data = this.data;
			evt.child = this.child;
			return evt;
		}
	}
}