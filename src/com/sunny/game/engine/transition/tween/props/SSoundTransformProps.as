package com.sunny.game.engine.transition.tween.props
{
	import flash.utils.flash_proxy;

	use namespace flash_proxy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个声音变换属性
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
	public class SSoundTransformProps extends STweenProps
	{
		/**
		 * 对soundTransform（MovieClip/SoundChannel/NetStream 等）对
		 象中的volume属性（音量大小）进行缓动
		 */
		private var _volume : Number;
		private var _pan : Number;

		public function SSoundTransformProps(vars : Object = null)
		{
			super(vars);
		}

		public function get volume() : Number
		{
			return _volume;
		}

		public function set volume(value : Number) : void
		{
			_volume = value;
			setProperty("volume", value);
		}

		public function get pan() : Number
		{
			return _pan;
		}

		public function set pan(value : Number) : void
		{
			_pan = value;
			setProperty("pan", value);
		}
	}
}