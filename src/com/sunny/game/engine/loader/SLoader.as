package com.sunny.game.engine.loader
{
	import flash.display.Loader;

	/**
	 *
	 * <p>
	 * SunnyGame的一个Loader
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
	public class SLoader extends Loader
	{
		/**
		 * 自定义数据的传递
		 */
		private var _data : *;

		public function SLoader()
		{
			super();
		}

		/**
		 * 挂载在Loader内部的自定义数据
		 */
		public function set data(value : *) : void
		{
			_data = value;
		}

		/**
		 * 挂载在Loader内部的自定义数据
		 */
		public function get data() : *
		{
			return _data;
		}

		public function destroy() : void
		{
			data = null;
			this.unloadAndStop();
		}
	}
}