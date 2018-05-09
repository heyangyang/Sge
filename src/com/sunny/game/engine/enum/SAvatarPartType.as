package com.sunny.game.engine.enum
{
	import com.sunny.game.engine.debug.SDebug;

	/**
	 *
	 * <p>
	 * SunnyGame的一个纸娃娃部件类型枚举
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
	public final class SAvatarPartType
	{
		/**
		 * 完整部件
		 */
		public static const WHOLE_PART : uint = 1;
		/**
		 * 身体部件
		 */
		public static const BODY_PART : uint = 2;
		/**
		 * 武器部件
		 */
		public static const WEAPON_PART : uint = 3;
		/**
		 * 翅膀部件
		 */
		public static const WING_PART : uint = 4;

		public static const PART_TYPE_MAP:Array=[WHOLE_PART,BODY_PART,WEAPON_PART,WING_PART];
		public static const PART_NAME_MAP:Array=["whole","body","weapon","wing"];
		public static const PART_CHINESE_NAME_MAP:Array=["全部","身体","武器","翅膀"];
		
		public static function getPartTypeByName(name : String) : uint
		{
			var index:int=PART_NAME_MAP.indexOf(name.toLowerCase());
			if(index != -1)
				return PART_TYPE_MAP[index];
			if (SDebug.OPEN_WARNING_TRACE)
				SDebug.warningPrint(name, "没有部件名称为%s的部件类型！", name);
			return 0;
		}

		public static function getPartNameByType(type : uint) : String
		{
			var index:int=PART_TYPE_MAP.indexOf(type);
			if(index != -1)
				return PART_NAME_MAP[index];
			if (SDebug.OPEN_WARNING_TRACE)
				SDebug.warningPrint(type, "没有部件类型为%s的部件名称！", type);
			return null;
		}
		
		public static function getPartChineseNameByType(type : uint) : String
		{
			var index:int=PART_TYPE_MAP.indexOf(type);
			if(index != -1)
				return PART_CHINESE_NAME_MAP[index];
			if (SDebug.OPEN_WARNING_TRACE)
				SDebug.warningPrint(type, "没有部件类型为%s的部件中文名称！", type);
			return null;
		}
		
		public static function getPartChineseNameByName(name : String) : String
		{
			var action : uint = getPartTypeByName(name);
			return getPartChineseNameByType(action);
		}
	}
}