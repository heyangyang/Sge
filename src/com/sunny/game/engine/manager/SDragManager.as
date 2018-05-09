package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.ui.drag.SDrager;
	import com.sunny.game.engine.ui.drag.SIDragInitiator;
	import com.sunny.game.engine.utils.core.SHandler;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的一个拖拽管理器
	 * FLASH自带的拖动功能缺乏扩展性，因此必要时只能重新实现。
	 *
	 * 这个类可以实现对Bitmap,TextField的拖动，支持多物品拖动,
	 * 并且会自动向外发布DragOver,DragOut,DragDrop等事件。
	 *
	 * 这个类的DragStart和DragStop事件都是可中断的，若指定中断就可以中止原来的操作。
	 *
	 * 设定type可以选择拖动临时图标代替拖动本体
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
	public class SDragManager
	{
		private static var dragerList : Dictionary = new Dictionary(); //对应拖动器的临时字典
		private static var handlerList : Dictionary = new Dictionary(); //注册的执行器字典

		/**
		 * 开始拖动
		 *
		 * @param obj	要拖动的物品
		 * @param bounds	拖动的范围，坐标系为父对象
		 * @param startHandler	开始拖动时执行的事件
		 * @param stopHandler	停止拖动后执行的事件
		 * @param onHandler	拖动时每帧执行的事件
		 * @param type	拖动类型
		 * @param lockCenter	是否以物体中心点为拖动的点
		 * @param upWhenLeave	当移出拖动范围时，是否停止拖动
		 * @param collideByRect	判断范围是否以物品的边缘而不是注册点为标准
		 *
		 */
		public static function startDrag(dragInitiator : SIDragInitiator, dragTarget : DisplayObject, dragParent : DisplayObject = null, bounds : Rectangle = null, type : String = "direct", lockCenter : Boolean = false, upWhenLeave : Boolean = false, //
			collideByRect : Boolean = false, startHandler : Function = null, stopHandler : Function = null, moveHandler : Function = null) : void
		{
			var drager : SDrager = dragerList[dragInitiator] as SDrager;
			if (drager == null)
				drager = new SDrager(dragInitiator, dragTarget, dragParent, bounds, type, lockCenter, upWhenLeave, collideByRect, startHandler, stopHandler, moveHandler);
			drager.startDrag();
		}

		/**
		 * 停止拖动
		 * @param obj
		 *
		 */
		public static function stopDrag(dragInitiator : SIDragInitiator) : void
		{
			var drager : SDrager = dragerList[dragInitiator] as SDrager;
			if (drager)
				drager.stopDrag();
		}

		public static function registered(dragInitiator : SIDragInitiator) : Boolean
		{
			if (handlerList[dragInitiator])
				return true;
			return false;
		}

		/**
		 * 注册一个可拖动的对象
		 * @param dragInitiator 触发拖动的对象，拖动的源对象
		 * @param dragObject 被拖动的对象，显示拖动的图片，如果为null，则是源对象本身
		 * @param data 拖动传递的数据
		 * @param bounds
		 * @param type
		 * @param lockCenter
		 * @param upWhenLeave
		 * @param collideByRect
		 * @param startHandler
		 * @param stopHandler
		 * @param moveHandler
		 *
		 */
		public static function register(dragInitiator : SIDragInitiator, dragTarget : DisplayObject = null, dragParent : DisplayObject = null, bounds : Rectangle = null, type : String = "direct", lockCenter : Boolean = false, upWhenLeave : Boolean = false, //
			collideByRect : Boolean = false, startHandler : Function = null, stopHandler : Function = null, moveHandler : Function = null) : void
		{
			if (!registered(dragInitiator))
			{
				if (!dragTarget)
					dragTarget = dragInitiator as DisplayObject;

				if (!dragInitiator.dragEnabled)
					return;

				handlerList[dragInitiator] = new SHandler(SDragManager.startDrag, [dragInitiator, dragTarget, dragParent, bounds, type, lockCenter, upWhenLeave, collideByRect, startHandler, stopHandler, moveHandler]);
				dragInitiator.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
		}

		private static var mouseDownPoint : Point = new Point();
		private static var mouseMovePoint : Point = new Point();

		/**
		 * 鼠标移动，将开始处理拖动
		 * @param evt
		 */
		private static function mouseMoveHandler(e : MouseEvent) : void
		{
			var dragInitiator : SIDragInitiator = e.currentTarget as SIDragInitiator;
			mouseMovePoint.x = e.stageX;
			mouseMovePoint.y = e.stageY;
			var dx : int = mouseMovePoint.x - mouseDownPoint.x;
			var dy : int = mouseMovePoint.y - mouseDownPoint.y;
			if ((dx * dx + dy * dy) > 1)
			{
				var handler : SHandler = handlerList[dragInitiator];
				if (handler)
					handler.call();
				stopMoveHandler(e);
			}
		}

		private static function mouseDownHandler(event : MouseEvent) : void
		{
			var dragInitiator : SIDragInitiator = event.currentTarget as SIDragInitiator;
			mouseDownPoint.x = event.stageX;
			mouseDownPoint.y = event.stageY;
			dragInitiator.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			dragInitiator.addEventListener(MouseEvent.MOUSE_UP, stopMoveHandler);
			dragInitiator.addEventListener(MouseEvent.ROLL_OUT, stopMoveHandler);
		}

		/**
		 * 鼠标移出不能拖动
		 * @param evt
		 */
		private static function stopMoveHandler(e : MouseEvent) : void
		{
			var dragInitiator : SIDragInitiator = e.currentTarget as SIDragInitiator;
			dragInitiator.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			dragInitiator.removeEventListener(MouseEvent.ROLL_OUT, stopMoveHandler);
			dragInitiator.removeEventListener(MouseEvent.MOUSE_UP, stopMoveHandler);
		}

		/**
		 * 取消注册拖动，这样被拖动的物品才可以被回收
		 * @param obj
		 *
		 */
		public static function unregister(dragInitiator : SIDragInitiator) : void
		{
			if (registered(dragInitiator))
			{
				dragInitiator.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				dragInitiator.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				dragInitiator.removeEventListener(MouseEvent.MOUSE_UP, stopMoveHandler);
				dragInitiator.removeEventListener(MouseEvent.ROLL_OUT, stopMoveHandler);
				var handler : SHandler = handlerList[dragInitiator];
				if (handler)
					handler.destroy();
				handlerList[dragInitiator] = null;
				delete handlerList[dragInitiator];
				var drager : SDrager = dragerList[dragInitiator] as SDrager;
				if (drager)
					drager.destroy();
				dragerList[dragInitiator] = null;
				delete dragerList[dragInitiator];
			}
		}
	}
}
