package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.display.SIData;
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	import flash.utils.Timer;

	/**
	 *
	 * <p>
	 * SunnyGame的计时器
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
	public class STimer extends Timer implements SIData, SIDestroy
	{
		/**
		 * 可以在使用过程中传递数据
		 */
		protected var _data : *;
		protected var _isDisposed : Boolean;

		public function STimer(delay : Number, repeatCount : int = 0)
		{
			_isDisposed = false;
			super(delay, repeatCount);
		}

		public function get data() : *
		{
			return _data;
		}

		public function set data(value : *) : void
		{
			if (_data == null && value == null)
				return;
			_data = value;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			_data = null;
			stop();
			_isDisposed = true;
		}
	}
}