package com.sunny.game.engine.enum
{
	import com.sunny.game.engine.lang.errors.SAbstractClassError;

	/**
	 *
	 * <p>
	 * SunnyGame的一个垂直对齐方式
	 * A class that provides constant values for vertical alignment of objects.
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
	public final class SValign
	{
		public static const NONE : String = "none";
		/** Top alignment. */
		public static const TOP : String = "top";
		/** Centered alignment. */
		public static const MIDDLE : String = "middle";
		/** Bottom alignment. */
		public static const BOTTOM : String = "bottom";

		/** @private */
		public function SValign()
		{
			throw new SAbstractClassError();
		}

		/** Indicates whether the given alignment string is valid. */
		public static function isValid(vAlign : String) : Boolean
		{
			return vAlign == NONE || vAlign == TOP || vAlign == MIDDLE || vAlign == BOTTOM;
		}
	}
}