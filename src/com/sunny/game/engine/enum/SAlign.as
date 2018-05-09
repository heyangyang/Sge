package com.sunny.game.engine.enum
{
	import com.sunny.game.engine.lang.errors.SAbstractClassError;

	/**
	 *
	 * <p>
	 * SunnyGame的一个水平对齐方式HAlign
	 * A class that provides constant values for horizontal alignment of objects.
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
	public final class SAlign
	{
		public static const NONE : String = "none";
		/** Left alignment. */
		public static const LEFT : String = "left";
		/** Centered alignement. */
		public static const CENTER : String = "center";
		/** Right alignment. */
		public static const RIGHT : String = "right";

		/** @private */
		public function SAlign()
		{
			throw new SAbstractClassError();
		}

		/** Indicates whether the given alignment string is valid. */
		public static function isValid(hAlign : String) : Boolean
		{
			return hAlign == NONE || hAlign == LEFT || hAlign == CENTER || hAlign == RIGHT;
		}
	}
}