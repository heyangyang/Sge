package com.sunny.game.engine.transition.tween.props
{
	import com.sunny.game.engine.transition.tween.SFilterProps;

	/**
	 *
	 * <p>
	 * SunnyGame的一个发光滤镜属性
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
	public class SGlowFilterProps extends SFilterProps
	{
		public var color : uint;
		public var alpha : Number;
		public var blurX : Number;
		public var blurY : Number;
		public var strength : Number;
		public var quality : int;
		public var inner : Boolean;
		public var knockout : Boolean;

		public function SGlowFilterProps(color : uint = 16711680, alpha : Number = 1.0, blurX : Number = 6.0, blurY : Number = 6.0, strength : Number = 2, quality : int = 1, inner : Boolean = false, knockout : Boolean = false)
		{
			this.color = color;
			this.alpha = alpha;
			this.blurX = blurX;
			this.blurY = blurY;
			this.strength = strength;
			this.quality = quality;
			this.inner = inner;
			this.knockout = knockout;
			super();
		}
	}
}