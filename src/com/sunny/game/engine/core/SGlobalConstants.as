package com.sunny.game.engine.core
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个全局常量类
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
	public class SGlobalConstants
	{
		/**
		 * 引擎（框架）的版本号
		 */
		public static const VERSION : String = 'V2.0.3';
		public static const VERSION_NUMBER : Number = 2.03;
		/**
		 * @private
		 * 如果在未来变化API/Framework，这个数字有助于确定兼容性
		 */
		public static const API : Number = 2.0;
		public static const COPYRIGHT : String = 'HXKJ';

		public static const SECOND_PER_FRAME : int = 25;
		public static const ENVIROMENT_RELEASE : String = 'release';
		public static const ENVIROMENT_DEBUG : String = 'debug';

	}
}