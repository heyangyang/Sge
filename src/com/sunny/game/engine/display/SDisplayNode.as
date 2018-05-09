package com.sunny.game.engine.display
{
	import com.sunny.game.engine.core.SINode;
	import com.sunny.game.engine.core.SNode;
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	import com.sunny.game.engine.ns.sunny_ui;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	use namespace sunny_ui;

	/**
	 *
	 * <p>
	 * SunnyGame的一个用户界面节点
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
	public class SDisplayNode extends SNode implements SIDisplayNode
	{
		sunny_ui var _container : SSprite;
		sunny_ui var _mask : SIDisplayNode;

		public function SDisplayNode()
		{
			super();
			_container = new SSprite();
			_container.focusRect = null;
			_mask = null;
		}

		override public function addToParent(parent : SINode, index : int = -1) : void
		{
			if (!(parent is SIDisplayNode))
			{
				throw new SunnyGameEngineError("父节点必须实现SIDisplayNode接口！");
				return;
			}
			var point : Point = new Point(x, y);
			var global : Point = null;
			if (_parent && _parent is SIDisplayNode)
				global = (_parent as SIDisplayNode).localToGlobal(point);
			super.addToParent(parent, index);
			if (global)
			{
				point = (_parent as SIDisplayNode).globalToLocal(global);
				x = point.x;
				y = point.y;
			}
		}

		override public function addChildAt(child : SINode, index : int) : SINode
		{
			if (!(child is SIDisplayNode))
			{
				throw new SunnyGameEngineError("子节点必须实现SIDisplayNode接口！");
				return null;
			}
			var childIndex : int = -1;
			if (numChildren > 0 && index < numChildren && child is SDisplayNode)
			{
				var oldChild : SINode = getChildAt(index);
				if ((oldChild is SIDisplayNode) && (oldChild as SDisplayNode).container)
					childIndex = _container.getChildIndex((oldChild as SDisplayNode).container);
			}
			child = super.addChildAt(child, index);
			if (child is SDisplayNode)
			{
				if ((child as SDisplayNode).container)
				{
					if (childIndex == -1)
						_container.addChild((child as SDisplayNode).container);
					else
						_container.addChildAt((child as SDisplayNode).container, childIndex);
				}
			}
			return child;
		}

		override public function removeChildAt(index : int) : SINode
		{
			var child : SINode = super.removeChildAt(index);
			if (child is SDisplayNode)
			{
				if ((child as SDisplayNode).container)
				{
					if (_container.contains((child as SDisplayNode).container))
					{
						_container.removeChild((child as SDisplayNode).container);
					}
				}
			}
			return child;
		}

		override public function setChildIndex(child : SINode, index : int) : void
		{
			var childIndex : int = -1;
			if (numChildren > 0 && index < numChildren && child is SDisplayNode)
			{
				var oldChild : SINode = getChildAt(index);
				if ((oldChild is SDisplayNode) && (oldChild as SDisplayNode).container)
					childIndex = _container.getChildIndex((oldChild as SDisplayNode).container);
			}
			super.setChildIndex(child, index);
			if (child is SDisplayNode)
			{
				if ((child as SDisplayNode).container)
				{
					if (_container.contains((child as SDisplayNode).container))
					{
						if (childIndex == -1)
							_container.setChildIndex((child as SDisplayNode).container, (child as SDisplayNode).container.numChildren);
						else
							_container.setChildIndex((child as SDisplayNode).container, childIndex);
					}
				}
			}
		}

		public function get x() : Number
		{
			return _container.x;
		}

		public function set x(value : Number) : void
		{
			if (_container.x == value)
				return;
			_container.x = value;
		}

		public function get y() : Number
		{
			return _container.y;
		}

		public function set y(value : Number) : void
		{
			if (_container.y == value)
				return;
			_container.y = value;
		}

		public function get width() : Number
		{
			return _container.width;
		}

		public function set width(value : Number) : void
		{
			if (_container.width == value)
				return;
			_container.width = value;
		}

		public function get height() : Number
		{
			return _container.height;
		}

		public function set height(value : Number) : void
		{
			if (_container.height == value)
				return;
			_container.height = value;
		}

		public function get mouseX() : Number
		{
			return _container.mouseX;
		}

		public function get mouseY() : Number
		{
			return _container.mouseY;
		}

		public function set alpha(value : Number) : void
		{
			if (_container.alpha == value)
				return;
			_container.alpha = value;
		}

		public function get alpha() : Number
		{
			return _container.alpha;
		}

		public function set filters(value : Array) : void
		{
			_container.filters = value;
		}

		public function get filters() : Array
		{
			return _container.filters;
		}

		public function set transform(value : Transform) : void
		{
			_container.transform = value;
		}

		public function get transform() : Transform
		{
			return _container.transform;
		}

		public function localToGlobal(point : Point) : Point
		{
			return _container.localToGlobal(point);
		}

		public function globalToLocal(point : Point) : Point
		{
			return _container.globalToLocal(point);
		}

		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void
		{
			_container.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void
		{
			_container.removeEventListener(type, listener, useCapture);
		}

		public function dispatchEvent(event : Event) : Boolean
		{
			return _container.dispatchEvent(event);
		}

		public function set mouseChildren(value : Boolean) : void
		{
			_container.mouseChildren = value;
		}

		public function get mouseChildren() : Boolean
		{
			return _container.mouseChildren;
		}

		public function set mouseEnabled(value : Boolean) : void
		{
			_container.mouseEnabled = value;
		}

		public function get mouseEnabled() : Boolean
		{
			return _container.mouseEnabled;
		}

		public function set buttonMode(value : Boolean) : void
		{
			_container.buttonMode = value;
		}

		public function set tabEnabled(value : Boolean) : void
		{
			_container.tabEnabled = value;
		}

		public function set blendMode(value : String) : void
		{
			_container.blendMode = value;
		}

		public function get blendMode() : String
		{
			return _container.blendMode;
		}

		public function getRect(targetCoordinateSpace : SIDisplayNode) : Rectangle
		{
			return _container.getRect((targetCoordinateSpace as SDisplayNode).container);
		}

		public function set cacheAsBitmap(value : Boolean) : void
		{
			_container.cacheAsBitmap = value;
		}

		public function set mask(value : SIDisplayNode) : void
		{
			_mask = value;
			_container.mask = _mask ? (_mask as SDisplayNode).container : null;
		}

		public function get mask() : SIDisplayNode
		{
			return _mask;
		}

		public function get stage() : Stage
		{
			return _container.stage;
		}

		public function set visible(value : Boolean) : void
		{
			_container.visible = value;
		}

		public function get visible() : Boolean
		{
			return _container.visible;
		}

		public function set scaleX(value : Number) : void
		{
			if (_container.scaleX == value)
				return;
			_container.scaleX = value;
		}

		public function get scaleX() : Number
		{
			return _container.scaleX;
		}

		public function set scaleY(value : Number) : void
		{
			if (_container.scaleY == value)
				return;
			_container.scaleY = value;
		}

		public function get scaleY() : Number
		{
			return _container.scaleY;
		}

		public function set scaleZ(value : Number) : void
		{
			if (_container.scaleZ == value)
				return;
			_container.scaleZ = value;
		}

		public function get scaleZ() : Number
		{
			return _container.scaleZ;
		}

		public function set rotation(value : Number) : void
		{
			if (_container.rotation == value)
				return;
			_container.rotation = value;
		}

		public function get rotation() : Number
		{
			return _container.rotation;
		}

		public function set rotationX(value : Number) : void
		{
			if (_container.rotationX == value)
				return;
			_container.rotationX = value;
		}

		public function get rotationX() : Number
		{
			return _container.rotationX;
		}

		public function set rotationY(value : Number) : void
		{
			if (_container.rotationY == value)
				return;
			_container.rotationY = value;
		}

		public function get rotationY() : Number
		{
			return _container.rotationY;
		}

		public function set rotationZ(value : Number) : void
		{
			if (_container.rotationZ == value)
				return;
			_container.rotationZ = value;
		}

		public function get rotationZ() : Number
		{
			return _container.rotationZ;
		}

		public function startDrag(lockCenter : Boolean = false, bounds : Rectangle = null) : void
		{
			_container.startDrag(lockCenter, bounds);
		}

		public function stopDrag() : void
		{
			_container.stopDrag();
		}

		public function set focusRect(value : Object) : void
		{
			_container.focusRect = value;
		}

		public function set tabChildren(value : Boolean) : void
		{
			_container.tabChildren = value;
		}

		sunny_ui function get container() : SSprite
		{
			return _container;
		}

		override public function equals(value : Object) : Boolean
		{
			return (value == this) || (value == _container);
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_container)
			{
				_container.destroy();
				_container = null;
			}
			_mask = null;
			super.destroy();
		}
	}
}