package com.sunny.game.engine.transition.tween.props
{
	import flash.utils.flash_proxy;

	use namespace flash_proxy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个声音缓动属性
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
	dynamic public class SSoundTweenProps extends STweenProps
	{
		private var _soundTransform : SSoundTransformProps = null;

		public function SSoundTweenProps(vars : Object = null)
		{
			super(vars);
		}

		public function get soundTransform() : SSoundTransformProps
		{
			return _soundTransform;
		}

		public function set soundTransform(value : SSoundTransformProps) : void
		{
			_soundTransform = value;
			setProperty("soundTransform", value);
		}
	}
}