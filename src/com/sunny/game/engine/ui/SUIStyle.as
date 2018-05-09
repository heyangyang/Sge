package com.sunny.game.engine.ui
{
	import com.sunny.game.engine.ui.controls.SLabel;
	
	import flash.text.TextFormat;

	/**
	 *
	 * <p>
	 * SunnyGame的一个UI样式
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
	public final class SUIStyle
	{
		public static var FONT_KaiTi : String = "KaiTi_GB2312,KaiTi,Microsoft YaHei,SimSun";

		public static var TEXT_COLOR : uint = 0xffffff;
		public static var TEXT_SIZE : int = 13;
		public static var TEXT_BOLD : Boolean = false;
		public static var TEXT_FONT : String = "SimSun";//"Microsoft YaHei,SimSun,Arial,Verdana,Consolas"; //"SimSun";
		public static var TEXT_LEADING : int = 2;

		public static var STYLE_BORDER_COLOR : uint = 0xcccccc;
		public static var STYLE_BORDER_ALPHA : Number = 0.5;

		public static var defaultTextFormat : TextFormat = new TextFormat(SUIStyle.TEXT_FONT, 12, 0xffffff, null, null, null, null, null, "left");
		public static var blackFilters:Array;
		
		public static function setLightFilter(achiTitle:SLabel, param1:Number, param2:int):void
		{
			// TODO Auto Generated method stub
			
		}
	}
}