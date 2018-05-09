package com.sunny.game.engine.ui.drag
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.display.SIDisplayObject;
	import com.sunny.game.engine.events.SDragEvent;
	import com.sunny.game.engine.events.STickEvent;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.utils.STickUtil;
	import com.sunny.game.engine.utils.display.SBitmapUtil;
	import com.sunny.game.engine.utils.display.SGeometryUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 *
	 * <p>
	 * SunnyGame的一个拖拽器
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
	public class SDrager extends SObject implements SIDestroy
	{
		/**
		 * 直接拖动
		 */
		public static const DIRECT : String = "direct";
		/**
		 * 复制一个图标并拖动
		 */
		public static const CLONE : String = "clone";

		private var _dragInitiator : SIDragInitiator;
		private var _dragTarget : DisplayObject;
		private var _dragParent : DisplayObject;
		private var _bounds : Rectangle;
		private var _type : String;
		private var _lockCenter : Boolean;
		private var _upWhenLeave : Boolean;
		private var _collideByRect : Boolean;
		private var _moveHandler : Function;
		private var _startHandler : Function;
		private var _stopHandler : Function;
		private var _dragMousePos : Point;
		private var _dragPos : Point;
		private var _dropable : SIDropable;
		private var _dragImage : Bitmap;

		protected var _isDisposed : Boolean;

		public function SDrager(dragInitiator : SIDragInitiator, dragTarget : DisplayObject, dragParent : DisplayObject = null, bounds : Rectangle = null, type : String = DIRECT, lockCenter : Boolean = false, upWhenLeave : Boolean = false, //
			collideByRect : Boolean = false, startHandler : Function = null, stopHandler : Function = null, moveHandler : Function = null)
		{
			_isDisposed = false;
			_dragInitiator = dragInitiator;
			_dragTarget = dragTarget;
			_dragParent = dragParent;
			_bounds = bounds;
			_type = type;
			_lockCenter = lockCenter;
			_upWhenLeave = upWhenLeave;
			_collideByRect = collideByRect;
			_startHandler = startHandler;
			_stopHandler = stopHandler;
			_moveHandler = moveHandler;
			super();
		}

		public function startDrag() : void
		{
			if (!_dragTarget.stage)
				return;
			if (_startHandler != null)
				_dragInitiator.addEventListener(SDragEvent.DRAG_START, _startHandler);

			var e : SDragEvent = new SDragEvent(SDragEvent.DRAG_START, false, true);
			e.dragInitiator = _dragInitiator;
			_dragInitiator.dispatchEvent(e);
			e.destroy();

			if (e.isDefaultPrevented())
				return;

			if (_lockCenter)
				_dragMousePos = SGeometryUtil.center(_dragTarget);
			else
				_dragMousePos = SGeometryUtil.localToContent(new Point(_dragTarget.mouseX, _dragTarget.mouseY), _dragTarget as DisplayObject, _dragTarget.parent);

			_dragPos = new Point(_dragTarget.x, _dragTarget.y);

			STickUtil.instance.addEventListener(STickEvent.TICK, enterFrameHandler);
			_dragInitiator.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_dragInitiator.stage.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_dragInitiator.stage.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			if (_stopHandler != null)
				_dragInitiator.addEventListener(SDragEvent.DRAG_STOP, _stopHandler);
			if (_moveHandler != null)
				_dragInitiator.addEventListener(SDragEvent.DRAG_MOVE, _moveHandler);

			if (_type == CLONE)
			{
				_dragImage = SBitmapUtil.replaceWithBitmap(_dragTarget as DisplayObject);
				if (_dragImage)
				{
					_dragMousePos.x -= _dragImage.x - _dragTarget.x;
					_dragMousePos.y -= _dragImage.y - _dragTarget.y;
					_dragMousePos = SGeometryUtil.localToContent(_dragMousePos, _dragParent || _dragTarget.stage, _dragTarget.parent);

					((_dragParent || _dragTarget.stage) as DisplayObjectContainer).addChild(_dragImage);

//					if (_type == ALPHA_CLONE)
//						new SAlphaShapeParse(_dragImage).parse(_dragImage.bitmapData);
				}
			}
			else
			{
				if (_dragParent)
					(_dragParent as DisplayObjectContainer).addChild(_dragTarget);
			}
		}

		public function stopDrag() : void
		{
			var e : SDragEvent = new SDragEvent(SDragEvent.DRAG_STOP, false, true);
			e.dragInitiator = _dragInitiator;
			_dragInitiator.dispatchEvent(e);
			e.destroy();

			if (e.isDefaultPrevented())
				return;

			STickUtil.instance.removeEventListener(STickEvent.TICK, enterFrameHandler);
			if (_dragInitiator.stage)
			{
				_dragInitiator.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				_dragInitiator.stage.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				_dragInitiator.stage.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			}
			if (_startHandler != null)
				_dragInitiator.removeEventListener(SDragEvent.DRAG_START, _startHandler);
			if (_stopHandler != null)
				_dragInitiator.removeEventListener(SDragEvent.DRAG_STOP, _stopHandler);
			if (_moveHandler != null)
				_dragInitiator.removeEventListener(SDragEvent.DRAG_MOVE, _moveHandler);

			if (_dragImage)
			{
				if (_dragImage.bitmapData)
					_dragImage.bitmapData.dispose();
				if (_dragImage.parent)
					_dragImage.parent.removeChild(_dragImage);
				_dragImage = null;
			}
		}

		private function enterFrameHandler(event : STickEvent) : void
		{
			var parentOffest : Point = SGeometryUtil.localToContent(new Point(_dragTarget.mouseX, _dragTarget.mouseY), _dragTarget as DisplayObject, _dragTarget.parent).subtract(_dragMousePos);

			var out : Boolean = false;
			if (_type == CLONE)
			{
				if (_dragImage)
				{
					_dragImage.x = _dragPos.x + parentOffest.x;
					_dragImage.y = _dragPos.y + parentOffest.y;
				}
			}
			else
			{
				_dragTarget.x = _dragPos.x + parentOffest.x;
				_dragTarget.y = _dragPos.y + parentOffest.y;
			}

			if (_bounds)
			{
				if (_collideByRect)
					out = SGeometryUtil.forceRectInside(_dragImage || _dragTarget, _bounds);
				else
					out = SGeometryUtil.forcePointInside(_dragImage || _dragTarget, _bounds);
			}

			var e : SDragEvent = new SDragEvent(SDragEvent.DRAG_MOVE, false, false);
			e.dragInitiator = _dragInitiator;
			_dragInitiator.dispatchEvent(e);
			e.destroy();

			if (out && _upWhenLeave)
			{
				stopDrag();
			}
		}

		private function mouseUpHandler(event : MouseEvent) : void
		{
			stopDrag();

			if (_dropable)
			{
				var e : SDragEvent;
				var interrupted : Boolean = _dropable.interruptDrop(_dragInitiator);
				_dragInitiator.dropResponse(_dropable, interrupted);
				if (interrupted)
				{
					if (_dropable.hasEventListener(SDragEvent.DROP_INTERRUPTTED))
						e = new SDragEvent(SDragEvent.DROP_INTERRUPTTED, true, false);
				}
				else
				{
					if (_dropable.hasEventListener(SDragEvent.DRAG_DROP))
						e = new SDragEvent(SDragEvent.DRAG_DROP, true, false);
				}
				if (e)
				{
					e.dragInitiator = _dragInitiator;
					e.dropTarget = _dropable;
					_dropable.dispatchEvent(e);
					e.destroy();
				}
				_dropable = null;
			}

			e = new SDragEvent(SDragEvent.DRAG_COMPLETE, false, false);
			e.dragInitiator = _dragInitiator;
			_dragInitiator.dispatchEvent(e);
			e.destroy();
		}

		private function mouseOverHandler(event : MouseEvent) : void
		{
			_dropable = event.target as SIDropable;
			_dropable = getDropTargetUnderMouse(_dropable, SIDropable) as SIDropable;
			if (_dropable)
			{
				var e : SDragEvent = new SDragEvent(SDragEvent.DRAG_OVER, true, false);
				e.dragInitiator = _dragInitiator;
				e.dropTarget = _dropable;
				_dropable.dispatchEvent(e);
				e.destroy();
			}
		}

		private function mouseOutHandler(event : MouseEvent) : void
		{
			var target : DisplayObject = event.target as DisplayObject;
			var e : SDragEvent = new SDragEvent(SDragEvent.DRAG_OUT, true, false);
			e.dragInitiator = _dragInitiator;
			target.dispatchEvent(e);
			e.destroy();
		}

		private function getDropTargetUnderMouse(target : SIDisplayObject, definition : Class) : SIDisplayObject
		{
			while (true)
			{
				if (target == null || target == _dragInitiator)
				{
					target = null;
					break;
				}
				else
				{
					if (target is definition)
					{
						if ((target as SIDropable).dropEnabled)
						{
							break;
						}
						else if (target.parent == null)
						{
							target = null;
							break;
						}
						else
						{
							target = target.parent as SIDisplayObject;
						}
					}
					else
					{
						if (target.parent == null)
						{
							target = null;
							break;
						}
						else
						{
							target = target.parent as SIDisplayObject;
						}
					}
				}
			}
			return target;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			stopDrag();
			_bounds = null;
			_type = null;
			_moveHandler = null;
			_startHandler = null;
			_stopHandler = null;
			_dragMousePos = null;
			_dragPos = null;
			_dragInitiator = null;
			_dragTarget = null;
			_dragParent = null;
			_dropable = null;
			_isDisposed = true;
		}
	}
}