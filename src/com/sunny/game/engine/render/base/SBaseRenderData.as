package com.sunny.game.engine.render.base
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.render.interfaces.SIBitmap;
	import com.sunny.game.engine.render.interfaces.SIBitmapData;
	import com.sunny.game.engine.render.interfaces.SIRenderData;
	import com.sunny.game.engine.utils.SCommonUtil;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;

	public class SBaseRenderData implements SIRenderData
	{
		public static function get renderClass() : Class
		{
			if (SShellVariables.supportDirectX)
				return SDirectRenderData;
			return SNormalRenderData;
		}
		protected static var renderInstance : int = 0;
		private var _isRendering : Boolean = false;
		private var _rendable : Boolean;
		private var _depth : int;
		private var _layer : int;
		private var _order : int;

		private var _rotatePointX : Number = 0;
		private var _rotatePointY : Number = 0;
		private var _x : int;
		private var _y : int;
		private var _alphaMultiplier : Number = 1;

		internal var _bitmap : SIBitmap;
		private var _children : Vector.<SIRenderData>;
		private var _parent : SIRenderData;

		private var _isDisposed : Boolean;

		public var isLockColorTransform : Boolean = false;

		private static var _rotateMatrix : Matrix = new Matrix();
		private var _rotate : Number = 0;

		public function SBaseRenderData()
		{
			init();
		}

		protected function init() : void
		{
			_isDisposed = false;
			_children = new Vector.<SIRenderData>();
		}

		public function dispose(clearMemory : Boolean = false) : void
		{
			for each (var child : SIRenderData in _children)
				child.dispose(clearMemory);
			_children.length = 0;
			if (_parent)
				_parent.removeChild(this);
			_parent = null;
			if (_bitmap)
			{
				_bitmap.removeChild(clearMemory);
				_bitmap.filters = null;
				if (clearMemory)
				{
					_bitmap.destroy();
					_bitmap = null;
				}
			}
			colorTransform = null;
			_filters = null;
			_isDisposed = true;
		}

		public function recycle() : void
		{
			bitmapData = null;
			_depth = _rotatePointX = _rotatePointY = _x = _y = _rotate = 0;
			scaleX = scaleY = _alphaMultiplier = 1;
			isLockColorTransform = false;
			_rendable = false;
			_isRendering = false;
			_isDisposed = false;
		}

		public function notifyAddedToRender() : void
		{
			_isRendering = true;
		}

		public function notifyRemovedFromRender() : void
		{
			_isRendering = false;
		}

		public function addChild(child : SIRenderData) : SIRenderData
		{
			return addChildAt(child, numChildren);
		}

		public function addChildAt(child : SIRenderData, index : int) : SIRenderData
		{
			if (index < 0)
				return null;
			if (child.parent)
				child.parent.removeChild(child);
			_children.splice(index, 0, child);
			child.parent = this;
			return child;
		}

		public function removeChild(child : SIRenderData) : SIRenderData
		{
			var index : int = _children.indexOf(child);
			return removeChildAt(index);
		}

		public function removeChildAt(index : int) : SIRenderData
		{
			if (index < 0 || index >= numChildren)
				return null;
			var child : SIRenderData = _children[index];
			child.parent = null;
			_children.splice(index, 1);
			return child;
		}

		public function getChildAt(index : int) : SIRenderData
		{
			if (index < 0 || index >= numChildren)
				return null;
			return _children[index];
		}

		public function getChildIndex(child : SIRenderData) : int
		{
			return _children.indexOf(child);
		}

		public function getChildByName(name : String) : SIRenderData
		{
			var child : SIRenderData;
			for (var i : int = numChildren - 1; i >= 0; i--)
			{
				child = getChildAt(i);
				if (child.name == name)
					return child;
			}
			return null;
		}

		public function removeAllChildren() : void
		{
			var child : SIRenderData;
			for (var i : int = numChildren - 1; i >= 0; i--)
			{
				child = getChildAt(i);
				child.dispose();
			}
			_children.length = 0;
		}

		public function get children() : Vector.<SIRenderData>
		{
			return _children;
		}

		public function get numChildren() : int
		{
			return _children ? _children.length : 0;
		}

		public function get parent() : SIRenderData
		{
			return _parent;
		}

		public function set render(value : SIBitmap) : void
		{
			if (_bitmap && value)
			{
				value.visible = _bitmap.visible;
				value.alpha = _bitmap.alpha;
				value.colorTransform = _bitmap.colorTransform;
				value.filters = _bitmap.filters;
				value.x = _bitmap.x;
				value.y = _bitmap.y;
				value.scaleX = _bitmap.scaleX;
				value.scaleY = _bitmap.scaleY;
			}
			_bitmap = value as SIBitmap;
		}

		public function set parent(value : SIRenderData) : void
		{
			_parent = value;
			if (parent)
			{
				alpha = parent.alpha;
				visible = parent.visible;
				scaleX = parent.scaleX;
				scaleY = parent.scaleY;
				blendMode = parent.blendMode;
				colorTransform = parent.colorTransform;
			}
		}

		public function get render() : SIBitmap
		{
			return _bitmap;
		}

		public function get rendable() : Boolean
		{
			return _rendable;
		}

		public function get isRendering() : Boolean
		{
			return _isRendering;
		}

		/**
		 * 通过弧度旋转
		 * @param rotate 相对于原矩阵要旋转的弧度值
		 * @param pointX 旋转基点
		 * @param pointY 旋转基点
		 */
		public function rotate(rotate : Number, pointX : Number = 0, pointY : Number = 0) : void
		{
			if (!_bitmap)
				return;
			var angle : int = SCommonUtil.getAngleByRotate(rotate);
			_rotateMatrix.identity();
			_rotateMatrix.translate(-pointX, -pointY);
			_rotateMatrix.rotate(rotate);
			_rotateMatrix.translate(pointX, pointY);
			_bitmap.rotation = angle;
			x += _rotateMatrix.tx;
			y += _rotateMatrix.ty;
			_rotate = rotate;
			_rotatePointX = pointX;
			_rotatePointY = pointY;
		}

		public function set x(value : Number) : void
		{
			if (!_bitmap || _bitmap.x == value)
				return;
			_bitmap.x = value;
		}

		public function get x() : Number
		{
			if (_bitmap)
				return _bitmap.x;
			return 0;
		}

		public function set y(value : Number) : void
		{
			if (!_bitmap || _bitmap.y == value)
				return;
			_bitmap.y = value;
		}

		public function get y() : Number
		{
			if (_bitmap)
				return _bitmap.y;
			return 0;
		}

		public function set width(value : Number) : void
		{
			if (!_bitmap || _bitmap.width == value)
				return;
			_bitmap.width = value;
		}

		public function get width() : Number
		{
			return _bitmap.width;
		}

		public function set height(value : Number) : void
		{
			if (!_bitmap || _bitmap.height == value)
				return;
			_bitmap.height = value;
		}

		public function get height() : Number
		{
			if (_bitmap)
				return _bitmap.height;
			return 0;
		}

		public function get scaleX() : Number
		{
			if (_bitmap)
				return _bitmap.scaleX;
			return 0;
		}

		public function set scaleX(value : Number) : void
		{
			if (_bitmap)
			{
				if (_bitmap.scaleX == value)
					return;
				_bitmap.scaleX = value;
			}

			updateChildField("scaleX", value);
		}

		public function get scaleY() : Number
		{
			if (_bitmap)
				return _bitmap.scaleY;
			return 0;
		}

		public function set scaleY(value : Number) : void
		{
			if (!_bitmap)
				return;
			if (_bitmap.scaleY == value)
				return;
			_bitmap.scaleY = value;

			updateChildField("scaleY", value);
		}

		public function set alpha(value : Number) : void
		{
			if (!_bitmap)
				return;
			if (_bitmap.alpha == value)
				return;
			if (_bitmap.colorTransform)
			{ //将
				_bitmap.colorTransform.alphaMultiplier = 1;
			}
			_bitmap.alpha = value;
			updateChildField("alpha", value);
		}

		public function get alpha() : Number
		{
			if (_bitmap)
				return _bitmap.alpha;
			return 0;
		}

		private var _filters : Array;
		private var _colorTransform : ColorTransform;

		public function set filters(value : Array) : void
		{
			if (_filters == value)
				return;
			_filters = value;
			if (_bitmap)
				_bitmap.filters = value;
		}

		public function get filters() : Array
		{
			if (_filters)
				return _filters;
			if (_bitmap)
			{
				_filters = _bitmap.filters;
				return _bitmap.filters;
			}
			return null;
		}

		public function get rotation() : Number
		{
			if (_bitmap)
				return _bitmap.rotation;
			return 0;
		}

		public function set rotation(value : Number) : void
		{
			if (_bitmap.rotation == value)
				return;
			_bitmap.rotation = value;
			updateChildField("rotation", value);
		}

		public function get rotatePointX() : Number
		{
			return _rotatePointX;
		}

		public function set rotatePointX(value : Number) : void
		{
			_rotatePointX = value;
		}

		public function get rotatePointY() : Number
		{
			return _rotatePointY;
		}

		public function set rotatePointY(value : Number) : void
		{
			_rotatePointY = value;
		}

		public function get blendMode() : String
		{
			if (_bitmap)
				return _bitmap.blendMode;
			return "";
		}

		public function set blendMode(value : String) : void
		{
			if (!_bitmap)
				return;
			value = value ? value : BlendMode.NORMAL;
			if (_bitmap.blendMode != value)
			{
				_bitmap.blendMode = value;
				updateChildField("blendMode", value);
			}
		}

		public function get colorTransform() : ColorTransform
		{
			if (_colorTransform)
				return _colorTransform;
			if (_bitmap)
			{
				_colorTransform = _bitmap.colorTransform;
				return _bitmap.colorTransform;
			}
			return null;
		}

		public function set colorTransform(value : ColorTransform) : void
		{
			if (isLockColorTransform || value == null)
				return;
			if (_colorTransform == value)
				return;
			_colorTransform = value;
			value.alphaMultiplier = alpha;
			if (_bitmap)
				_bitmap.colorTransform = value;
		}

		public function set normal_bitmapData(value : BitmapData) : void
		{
			if (_bitmap.normal_bitmapData == value)
				return;
			_bitmap.normal_bitmapData = value;
		}

		public function get normal_bitmapData() : BitmapData
		{
			if (_bitmap)
				return _bitmap.normal_bitmapData;
			return null;
		}

		public function set bitmapData(value : SIBitmapData) : void
		{
			if (_bitmap.data == value)
				return;
			_bitmap.data = value;
		}

		public function get bitmapData() : SIBitmapData
		{
			if (_bitmap)
				return _bitmap.data;
			return null;
		}

		public function get depth() : int
		{
			return _depth;
		}

		public function set depth(value : int) : void
		{
			_depth = value;
		}

		public function get layer() : int
		{
			return _layer;
		}

		/**
		 * 重叠y的时候可以采用这个进行身高等排序
		 * @param value
		 *
		 */
		public function set layer(value : int) : void
		{
			_layer = value;
		}

		public function get order() : int
		{
			return _order;
		}

		public function set order(value : int) : void
		{
			_order = value;
		}

		public function get visible() : Boolean
		{
			return _bitmap.visible;
		}

		public function set visible(value : Boolean) : void
		{
			if (!_bitmap)
				return;
			if (_bitmap.visible == value)
				return;
			_bitmap.visible = value;
			updateChildField("visible", value);
		}

		protected function updateChildField(key : String, value : *) : void
		{
			var child : SIRenderData;
			for (var i : int = _children.length - 1; i >= 0; i--)
			{
				child = _children[i];
				child[key] = value;
			}
		}

		public function get name() : String
		{
			if (_bitmap)
				return _bitmap.name;
			return "";
		}

		public function set name(value : String) : void
		{
			if (_bitmap)
				_bitmap.name = value;
		}

		public function set alphaMultiplier(value : Number) : void
		{
			_alphaMultiplier = value;
			alpha = _alphaMultiplier;
		}

		public function get alphaMultiplier() : Number
		{
			return _alphaMultiplier;
		}

		public function destroy() : void
		{
			dispose(true);
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function set nullRender(value : Boolean) : void
		{
			_rendable = value;
		}
	}
}