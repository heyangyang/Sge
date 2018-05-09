package com.sunny.game.engine.utils.text
{

	/**
	 * 处理文本与数字有关的部分
	 *
	 *
	 */
	public final class SNumberUtil
	{
		private static const chineseMapping : Array = ["", "一", "二", "三", "四", "五", "六", "七", "八", "九"];
		private static const chineseLevelMapping : Array = ["", "十", "百", "千"]
		private static const chineseLevel2Mapping : Array = ["", "万", "亿", "兆"]

		/**
		 * 转换为汉字数字
		 *
		 */
		public static function toChineseNumber(n : uint) : String
		{
			var result : String = "";
			var level : int = 0;
			while (n > 0)
			{
				var v : int = n % 10;
				if (level % 4 == 0)
					result = chineseLevel2Mapping[level / 4] + result;

				if (v > 0)
				{
					if (level % 4 == 1 && v == 1)
					{
						result = chineseLevelMapping[level % 4] + result;
					}
					else
					{
						result = chineseMapping[v] + chineseLevelMapping[level % 4] + result;
					}
				}
				else
				{
					result = chineseMapping[v] + result;
				}
				n = n / 10;
				level++;
			}

			return result;
		}

		private static const punctuationMapping : Array = [[",", ".", ":", ";", "?", "\\", "\/", "[", "]", "`"], ["，", "。", "：", "；", "？", "、", "、", "【", "】", "·"]]

		/**
		 * 转换中文标点
		 * @param v
		 * @param m1	是右单引号
		 * @param m2	是右双引号
		 * @return
		 *
		 */
		public static function toChinesePunctuation(v : String, m1 : Boolean = false, m2 : Boolean = false) : String
		{
			var result : String = "";
			for (var i : int = 0; i < v.length; i++)
			{
				var ch : String = v.charAt(i);
				if (ch == "'")
				{
					m1 = !m1;
					result += m1 ? "‘" : "’";
				}
				else if (ch == "\"")
				{
					m2 = !m2;
					result += m2 ? "“" : "”";
				}
				else
				{
					var index : int = (punctuationMapping[0] as Array).indexOf(v.charAt(i));
					if (index != -1)
						result += punctuationMapping[1][index];
					else
						result += v.charAt(i);
				}
			}
			return result;
		}

		/**
		 * 在数字中添加千位分隔符
		 *
		 */
		public static function addNumberSeparator(value : Number) : String
		{
			var result : String = "";
			while (value >= 1000)
			{
				var v : int = value % 1000;
				result = "," + fillZeros(v.toString(), 3) + result;
				value = Math.floor(value / 1000);
			}
			value = Math.floor(value);
			return result = String(value) + result;
		}

		/**
		 * 将数字用0补足长度
		 *
		 */
		public static function fillZeros(str : String, len : int, flag : String = "0") : String
		{
			if (!str)
				str = "";
			while (str.length < len)
			{
				str = flag + str;
			}
			return str;
		}
	}
}