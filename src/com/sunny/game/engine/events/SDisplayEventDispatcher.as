package com.sunny.game.engine.events
{
	import com.sunny.game.engine.display.SIDisplayObject;

	/**
	 *
	 * <p>
	 * SunnyGame的一个显示事件派发器
	 * </p>
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @see SEvent
	 * @see com.sunny.game.engine.display.SIDisplayObject
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public class SDisplayEventDispatcher extends SEventDispatcher
	{
		private static var bubbleChains : Array = [];

		public function SDisplayEventDispatcher()
		{
			super();
		}

		override public function dispatchEvent(event : SEvent) : void
		{
			var bubbles : Boolean = event.bubbles;

			if (!bubbles && (_eventListeners == null || !(event.type in _eventListeners)))
				return;

			var previousTarget : SIEventDispatcher = event.target;
			event.setTarget(this);

			if (bubbles && this is SIDisplayObject)
				bubbleEvent(event);
			else
				invokeEvent(event);

			if (previousTarget)
				event.setTarget(previousTarget);
		}

		/** @private */
		internal function bubbleEvent(event : SEvent) : void
		{
		/*	var chain : Vector.<SIEventDispatcher>;
			var element : SIDisplayObject = this as SIDisplayObject;
			var length : int = 1;

			if (bubbleChains.length > 0)
			{
				chain = bubbleChains.pop();
				chain[0] = element;
			}
			else
				chain = new <SIEventDispatcher>[element];

			while ((element = element.parent) != null)
				chain[int(length++)] = element;

			for (var i : int = 0; i < length; ++i)
			{
				var stopPropagation : Boolean = chain[i].invokeEvent(event);
				if (stopPropagation)
					break;
			}

			chain.length = 0;
			bubbleChains.push(chain);*/
		}
	}
}