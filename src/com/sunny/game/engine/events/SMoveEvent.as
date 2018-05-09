package com.sunny.game.engine.events
{
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * 移动事件
	 *
	 *
	 *
	 */
	public class SMoveEvent extends Event
	{
		public static const MOVE : String = "move";

		public var lastPosition : Point;
		public var position : Point;

		public function SMoveEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		public override function clone() : Event
		{
			var evt : SMoveEvent = new SMoveEvent(type, bubbles, cancelable);
			evt.lastPosition = this.lastPosition;
			evt.position = this.position;
			return evt;
		}
	}
}