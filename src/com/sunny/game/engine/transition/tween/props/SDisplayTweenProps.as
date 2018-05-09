package com.sunny.game.engine.transition.tween.props
{
	import com.sunny.game.engine.ns.sunny_engine;

	import flash.utils.flash_proxy;

	use namespace sunny_engine;
	use namespace flash_proxy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个显示缓动属性
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
	dynamic public class SDisplayTweenProps extends STweenProps
	{
		/**
		 * 改变 MovieClip的 x 位置,把这个值设置成你希望的 MovieClip 的结束位置(如果你使用的是
			   TweenLite.from()这个值表示开始位置). ( y scaleX scaleY rotation等属性不重复说明）
		 */
		private var _x : Number = 0;
		private var _y : Number = 0;
		private var _width : Number = 0;
		private var _height : Number = 0;
		private var _scaleX : Number = 0;
		private var _scaleY : Number = 0;
		private var _rotation : Number = 0;
		/**
		 * 目标对象应该完成 (或开始，当使用 TweenLite.from()时)的透明度级别.如果
					target.alpha 是1，当缓动被执行的时候，你指定参数为 0.5，它将把透明度从 1 缓动
					到 0.5.
		 */
		private var _alpha : Number = 0;
		/**
		 * 用它来代替 alpha 属性，可以获得一些副加的效果，比如当 alpha
							值缓动到 0时，自动将 visible 属性改为 false。当缓动开始前，autoAlpha 大
							于0时，它将会把 visible 属性变成 true 。
		 */
		private var _autoAlpha : Number = 0;
		/**
		 * 在缓动结束时，想指定 DisplayObject 的 visible 属性，请使用这个参数
		 */
		private var _visible : Boolean = false;
		/**
		 * 改变 DisplayObject 的颜色，设置一个16进制颜色值之后，当缓动结束时，
				   目标对象将被变成这个颜色，（如果使用的是TweenLite.from()，这个值将表示目标对
				   象开始缓动时的颜色)。举个例子，颜色值可以设定为0xFF0000。
		 */
		private var _color : uint = 0;
		/**
		 * 要移除 DisplayObject 颜色，将这个参数设成 true 。
		 */
		private var _removeColor : Boolean = false;
		/**
		 * 将 MovieClip 缓动到指帧频。
		 */
		private var _frame : Number = 0;
		/**
		 * 如果你使用带有延迟缓动的 TweenFilterLite.from() ，并且阻
								  止缓动的渲染（rendering ）效果，直到缓动真正开始，将这个值设为 true.
								默认情况下该值为 false ，这会让渲染效果立即被执行，甚至是在延迟的时间
								  还没到之前。
		 */
		private var _renderOnStart : Boolean = false;

		private var _glowFilter : SGlowFilterProps = null;
		private var _bezier : SBezierProps = null;

		public function SDisplayTweenProps(vars : Object = null)
		{
			super(vars);
		}

		public function get x() : Number
		{
			return _x;
		}

		public function set x(value : Number) : void
		{
			_x = value;
			setProperty("x", value);
		}

		public function get y() : Number
		{
			return _y;
		}

		public function set y(value : Number) : void
		{
			_y = value;
			setProperty("y", value);
		}

		public function get width() : Number
		{
			return _width;
		}

		public function set width(value : Number) : void
		{
			_width = value;
			setProperty("width", value);
		}

		public function get height() : Number
		{
			return _height;
		}

		public function set height(value : Number) : void
		{
			_height = value;
			setProperty("height", value);
		}

		public function get scaleX() : Number
		{
			return _scaleX;
		}

		public function set scaleX(value : Number) : void
		{
			_scaleX = value;
			setProperty("scaleX", value);
		}

		public function get scaleY() : Number
		{
			return _scaleY;
		}

		public function set scaleY(value : Number) : void
		{
			_scaleY = value;
			setProperty("scaleY", value);
		}

		public function get rotation() : Number
		{
			return _rotation;
		}

		public function set rotation(value : Number) : void
		{
			_rotation = value;
			setProperty("rotation", value);
		}

		public function get alpha() : Number
		{
			return _alpha;
		}

		public function set alpha(value : Number) : void
		{
			_alpha = value;
			setProperty("alpha", value);
		}

		public function get autoAlpha() : Number
		{
			return _autoAlpha;
		}

		public function set autoAlpha(value : Number) : void
		{
			_autoAlpha = value;
			setProperty("autoAlpha", value);
		}

		public function get visible() : Boolean
		{
			return _visible;
		}

		public function set visible(value : Boolean) : void
		{
			_visible = value;
			setProperty("visible", value);
		}

		public function get glowFilter() : SGlowFilterProps
		{
			return _glowFilter;
		}

		public function set glowFilter(value : SGlowFilterProps) : void
		{
			_glowFilter = value;
			setProperty("glowFilter", value);
		}

		public function get bezier() : SBezierProps
		{
			return _bezier;
		}

		public function set bezier(value : SBezierProps) : void
		{
			_bezier = value;
			setProperty("bezier", value);
		}

		public function get color() : uint
		{
			return _color;
		}

		public function set color(value : uint) : void
		{
			_color = value;
			setProperty("color", value);
		}

		public function get removeColor() : Boolean
		{
			return _removeColor;
		}

		public function set removeColor(value : Boolean) : void
		{
			_removeColor = value;
			setProperty("removeColor", value);
		}

		public function get frame() : Number
		{
			return _frame;
		}

		public function set frame(value : Number) : void
		{
			_frame = value;
			setProperty("frame", value);
		}

		public function get renderOnStart() : Boolean
		{
			return _renderOnStart;
		}

		public function set renderOnStart(value : Boolean) : void
		{
			_renderOnStart = value;
			setProperty("renderOnStart", value);
		}
	}
}