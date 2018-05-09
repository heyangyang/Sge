package com.sunny.game.engine.enum
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个文本模式
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
	public class STextMode
	{
		/**
		 * text handling modes
		 *
		 */
		public final function STextMode()
		{
		}

		// 
		/**
		 * Constant indicating that text should be rendered using a TextField
		 * instance using device fonts.
		 */
		public static const DEVICE : uint = 0;
		/**
		 * Constant indicating that text should be rendered using a TextField
		 * instance using embedded fonts. For this mode to work, the fonts
		 * used must be embedded in your application SWF file.
		 */
		public static const EMBED : uint = 1;
		/**
		 * Constant indicating that text should be rendered into a Bitmap
		 * instance.
		 */
		public static const BITMAP : uint = 2;
	}
}