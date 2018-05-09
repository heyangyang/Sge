package com.sunny.game.engine.utils.core
{
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个事件处理对象
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
	dynamic public class SEventHandler extends Proxy
	{
		/**
		 * 事件列表 
		 */
		public var handlers:Object;
		
		/**
		 * 是否弱引用 
		 */
		public var useWeakReference:Boolean = false;
		
		public function SEventHandler(obj:Object = null,useWeakReference:Boolean = false)
		{
			handlers = {};
			
			this.useWeakReference = useWeakReference;
			
			if (obj)
			{
				for (var key:String in obj)
					this[key] = obj[key];
			}
		}
		
		/**
		 * 增加一个事件 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */
		public function add(type:String,listener:Function,useCapture:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			if (this.useWeakReference)
				useWeakReference = true;
			
			var h:HandlerItem = new HandlerItem();
			h.type = type;
			h.listener = listener;
			h.useCapture = useCapture;
			h.priority = priority;
			h.useWeakReference = useWeakReference;
			
			this.handlers[type] = h;
		}
		
		/**
		 * 向一个目标添加事件 
		 * @param target
		 * 
		 */
		public function parse(...regs):void
		{
			for (var i:int = 0;i < regs.length;i++)
			{
				var target:IEventDispatcher = regs[i] as IEventDispatcher;
				for each (var handler:HandlerItem in handlers)
					target.addEventListener(handler.type,handler.listener,handler.useCapture,handler.priority,handler.useWeakReference);
			}
		}
		
		/**
		 * 取消目标的事件 
		 * @param target
		 * 
		 */
		public function unparse(...regs):void
		{
			for (var i:int = 0;i < regs.length;i++)
			{
				var target:IEventDispatcher = regs[i] as IEventDispatcher;
				for each (var handler:HandlerItem in handlers)
					target.removeEventListener(handler.type,handler.listener);
			}
		}
		
		/**
		 * 复制 
		 * @return 
		 * 
		 */
		public function clone():SEventHandler
		{
			var e:SEventHandler = new SEventHandler();
			if (this.handlers)
			{
				for (var key:String in this.handlers)
					e.handlers[key] = this.handlers[key];
			}
			e.useWeakReference = this.useWeakReference;
			return e;
		}
		
		flash_proxy override function setProperty(property:*,value:*):void 
		{
			add(property,value);
		}
		
		flash_proxy override function getProperty(property:*):* 
		{
			return (handlers[property] as HandlerItem).listener as Object;
		}
	}
}

class HandlerItem
{
	public var type:String;
	public var listener:Function;
	public var useCapture:Boolean = false;
	public var priority:int = 0;
	public var useWeakReference:Boolean = false;
}