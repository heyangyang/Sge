package com.sunny.game.engine.utils.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	/**
	 *
	 * <p>
	 * 一些用于图形的公用静态方法
	 * SunnyGame的一个为显示对象工作的实用方法。该方法包括支持平移，旋转，和缩放对象，生成缩略图，图像列表，遍历子对象，并加入舞台侦听。
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
	public final class SDisplayUtil
	{
		/**
		 * Constructor, throws an error if called, as this is an abstract class.
		 */
		public function SDisplayUtil()
		{
			throw new Error("This is an abstract class.");
		}

		/**
		 * 检测对象是否在屏幕中
		 * @param displayObj	显示对象
		 *
		 */
		public static function inScreen(displayObj : DisplayObject) : Boolean
		{
			if (displayObj.stage == null)
				return false;

			var screen : Rectangle = SGeometryUtil.getRect(displayObj.stage);
			return screen.containsRect(displayObj.getBounds(displayObj.stage));
		}

		/**
		 * 添加到对象之后，会挡住对象
		 * @param container
		 * @param child
		 * @param target
		 *
		 */
		public static function addChildAfter(child : DisplayObject, target : DisplayObject) : void
		{
			target.parent.addChildAt(child, target.parent.getChildIndex(target) + 1);
		}

		/**
		 * 添加到对象之前，会被对象挡住
		 * @param container
		 * @param child
		 * @param target
		 *
		 */
		public static function addChildBefore(child : DisplayObject, target : DisplayObject) : void
		{
			target.parent.addChildAt(child, target.parent.getChildIndex(target));
		}

		/**
		 * 获得子对象数组
		 * @param container
		 *
		 */
		public static function getChildren(container : DisplayObjectContainer) : Array
		{
			var result : Array = [];
			for (var i : int = 0; i < container.numChildren; i++)
				result.push(container.getChildAt(i));

			return result;
		}

		/**
		 * 移除所有子对象
		 * @param container	目标
		 *
		 */
		public static function removeAllChildren(container : DisplayObjectContainer) : void
		{
			while (container.numChildren)
				container.removeChildAt(0);
		}

		/**
		 * 批量增加子对象
		 *
		 */
		public static function addAllChildren(container : DisplayObjectContainer, children : Array) : void
		{
			for (var i : int = 0; i < children.length; i++)
			{
				if (children[i] is Array)
					addAllChildren(container, children[i] as Array);
				else
					container.addChild(children[i])
			}
		}

		/**
		 * 将显示对象移至顶端
		 * @param displayObj	目标
		 *
		 */
		public static function moveToHigh(displayObj : DisplayObject) : void
		{
			var parent : DisplayObjectContainer = displayObj.parent;
			if (parent)
			{
				var lastIndex : int = parent.numChildren - 1;
				if (parent.getChildIndex(displayObj) < lastIndex)
					parent.setChildIndex(displayObj, lastIndex);
			}
		}

		/**
		 * 同时设置mouseEnabled以及mouseChildren。
		 *
		 */
		public static function setMouseEnabled(displayObj : DisplayObjectContainer, v : Boolean) : void
		{
			displayObj.mouseChildren = displayObj.mouseEnabled = v;
		}

		/**
		 * 复制显示对象
		 * @param v
		 *
		 */
		public static function cloneDisplayObject(v : DisplayObject) : DisplayObject
		{
			var result : DisplayObject = v["constructor"]();
			result.filters = result.filters;
			result.transform.colorTransform = v.transform.colorTransform;
			result.transform.matrix = v.transform.matrix;
			if (result is Bitmap)
				(result as Bitmap).bitmapData = (v as Bitmap).bitmapData;
			return result;
		}

		/**
		 * 获取舞台Rotation
		 *
		 * @param displayObj	显示对象
		 * @return
		 *
		 */
		public static function getStageRotation(displayObj : DisplayObject) : Number
		{
			var currentTarget : DisplayObject = displayObj;
			var r : Number = 0.0;

			while (currentTarget && currentTarget.parent != currentTarget)
			{
				r += currentTarget.rotation;
				currentTarget = currentTarget.parent;
			}
			return r;
		}

		/**
		 * 获取舞台缩放比
		 *
		 * @param displayObj
		 * @return
		 *
		 */
		public static function getStageScale(displayObj : DisplayObject) : Point
		{
			var currentTarget : DisplayObject = displayObj;
			var scale : Point = new Point(1.0, 1.0);

			while (currentTarget && currentTarget.parent != currentTarget)
			{
				scale.x *= currentTarget.scaleX;
				scale.y *= currentTarget.scaleY;
				currentTarget = currentTarget.parent;
			}
			return scale;
		}

		/**
		 * 获取舞台Visible
		 *
		 * @param displayObj	显示对象
		 * @return
		 *
		 */
		public static function getStageVisible(displayObj : DisplayObject) : Boolean
		{
			var currentTarget : DisplayObject = displayObj;
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				if (currentTarget.visible == false)
					return false;
				currentTarget = currentTarget.parent;
			}
			return true;
		}

		/**
		 * 判断对象是否在某个容器中
		 * @param displayObj
		 * @param container
		 * @return
		 *
		 */
		public static function isInContainer(displayObj : DisplayObject, container : DisplayObjectContainer) : Boolean
		{
			var currentTarget : DisplayObject = displayObj;
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				if (currentTarget == container)
					return true;
				currentTarget = currentTarget.parent;
			}
			return false;
		}

		/**
		 * 替换一个元件并放置在原来的位置
		 * @param target
		 *
		 */
		public static function replaceTarget(source : DisplayObject, target : DisplayObject) : void
		{
			if (target && target.parent)
			{
				source.transform.colorTransform = target.transform.colorTransform;
				source.transform.matrix = target.transform.matrix;
				source.filters = target.filters;
				source.blendMode = target.blendMode;
				source.visible = target.visible;
				source.name = target.name;
				source.scrollRect = target.scrollRect;
				source.scale9Grid = target.scale9Grid;

				var oldIndex : int = target.parent.getChildIndex(target);
				var oldParent : DisplayObjectContainer = target.parent;

				oldParent.removeChild(target);
				oldParent.addChildAt(source, oldIndex);
			}
		}

		/**
		 * 将皮肤的属性转移到对象本身
		 *
		 */
		public static function moveProperty(source : DisplayObject, target : DisplayObject) : void
		{
			if (!target)
				return;

			source.transform.matrix = target.transform.matrix;
			source.transform.colorTransform = target.transform.colorTransform;
			source.scrollRect = target.scrollRect;
			source.blendMode = target.blendMode;
			source.filters = target.filters;

			target.transform.matrix = new Matrix();
			target.transform.colorTransform = new ColorTransform();
			target.scrollRect = null;
			target.blendMode = BlendMode.NORMAL;
			target.filters = null;
		}

		/**
		 * 将content替换成Bitmap,增加性能
		 *
		 */
		public static function asBitmap(content : DisplayObject, value : Boolean, bitmap : Bitmap = null) : Bitmap
		{
			if (!content)
				return null;

			if (value)
			{
				content.visible = false;
				bitmap = reRenderBitmap(content, bitmap);
			}
			else
			{
				content.visible = true;
				if (bitmap)
				{
					if (bitmap.bitmapData)
						bitmap.bitmapData.dispose();
					if (bitmap.parent)
						bitmap.parent.removeChild(bitmap);
					bitmap = null;
				}
			}
			return bitmap;
		}

		/**
		 * 更新缓存位图
		 *
		 */
		public static function reRenderBitmap(content : DisplayObject, bitmap : Bitmap) : Bitmap
		{
			if (!bitmap.parent)
				return null;
			var oldRect : Rectangle = bitmap ? bitmap.getBounds(bitmap.parent) : null;
			var rect : Rectangle = content.getBounds(bitmap.parent);
			if (!oldRect || !rect.equals(oldRect))
			{
				if (bitmap)
				{
					if (bitmap.parent)
						bitmap.parent.removeChild(bitmap);
					if (bitmap.bitmapData)
						bitmap.bitmapData.dispose();
				}
				bitmap = new Bitmap(new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0));
				bitmap.x = rect.x;
				bitmap.y = rect.y;
				content.parent.addChild(bitmap);
			}
			var m : Matrix = new Matrix();
			m.translate(-rect.x, -rect.y);
			bitmap.bitmapData.draw(content, m);
			return bitmap;
		}
	}
}