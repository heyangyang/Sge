package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.utils.text.SNumberUtil;

	/**
	 * 日期类
	 *
	 */
	public final class SDateUtil
	{
		/**
		 * 获得当前月的天数
		 * @param d
		 *
		 */
		static public function getDayInMonth(d : Date) : int
		{
			const days : Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			var day : int = days[d.month];
			if (isLeapYear(d.fullYear))
				day++;

			return day;
		}

		/**
		 * 是否是闰年
		 * @param year
		 * @return
		 *
		 */
		static public function isLeapYear(year : int) : Boolean
		{
			if (year % 4 == 0)
				if (year % 400 == 0)
					if (year % 3200 == 0)
						if (year % 86400 == 0)
							return false;
						else
							return true;
					else
						return false;
				else
					return true;
			else
				return false;
		}

		/**
		 * 根据字符串创建日期
		 * (yy-mm-dd)
		 * @param v
		 *
		 */
		static public function createDateFromString(v : String, timezone : Number = NaN) : Date
		{
			v = v.replace(/-/g, "/");
			if (!isNaN(timezone))
			{
				var str : String = Math.abs(timezone).toString();
				if (str.length == 1)
					str = "0" + str;

				v = v + " GMT" + (timezone >= 0 ? "+" : "-") + str + "00";
			}
			return new Date(v);
		}

		/**
		 * 创建时间
		 * @param v
		 *
		 */
		public static function createDate(v : *) : Date
		{
			if (isNaN(Number(v)))
				v = v.replace(/-/g, "/");

			return new Date(v);
		}

		/**
		 * 将日期转换为字符串
		 *
		 * @param date 日期
		 * @param format 日期格式（yyyy-mm-dd,yyyy-m-d,yyyy年m月d日,Y年M月D日,mm月dd日）
		 * @return 转换完毕的字符串
		 *
		 */
		public static function toDateString(date : Date, format : String = "yyyy-mm-dd", utc : Boolean = false) : String
		{
			var y : int = utc ? date.fullYearUTC : date.fullYear;
			var m : int = utc ? date.monthUTC : date.month;
			var d : int = utc ? date.dateUTC : date.date;

			switch (format)
			{
				case "mm-dd":
					return SNumberUtil.fillZeros((m + 1).toString(), 2) + "-" + SNumberUtil.fillZeros(d.toString(), 2);
					break;
				case "mm月dd日":
					return SNumberUtil.fillZeros((m + 1).toString(), 2) + "月" + SNumberUtil.fillZeros(d.toString(), 2)+"日";
					break;
				case "yyyy-mm-dd":
					return y + "-" + SNumberUtil.fillZeros((m + 1).toString(), 2) + "-" + SNumberUtil.fillZeros(d.toString(), 2);
					break;
				case "yyyy-m-d":
					return y + "-" + (m + 1).toString() + "-" + d;
					break;
				case "yyyy年m月d日":
					return y + "年" + (m + 1).toString() + "月" + d + "日";
					break;
				case "Y年M月D日":
					return SNumberUtil.toChineseNumber(y) + "年" + SNumberUtil.toChineseNumber(m + 1) + "月" + SNumberUtil.toChineseNumber(d) + "日";
					break;
			}
			return date.toString();
		}

		/**
		 * 将时间转换为字符串
		 *
		 * @param date 日期
		 * @param format 时间格式（hh:mm:ss，h:m:s，hh:mm:ss:ss.s，h:m:s:ss.s，h点m分s秒，H点M分S秒）
		 * @return 转换完毕的字符串
		 *
		 */
		public static function toTimeString(date : Date, format : String = "hh:mm:ss", utc : Boolean = false) : String
		{
			var h : int = utc ? date.hoursUTC : date.hours;
			var m : int = utc ? date.minutesUTC : date.minutes;
			var s : int = utc ? date.secondsUTC : date.seconds;
			var ms : Number = (utc ? date.millisecondsUTC : date.milliseconds) / 10;

			switch (format)
			{
				case "hh:mm":
					return SNumberUtil.fillZeros(h.toString(), 2) + ":" + SNumberUtil.fillZeros(m.toString(), 2);
					break;
				case "h:m":
					return h + ":" + m;
					break;
				case "hh:mm:ss":
					return SNumberUtil.fillZeros(h.toString(), 2) + ":" + SNumberUtil.fillZeros(m.toString(), 2) + ":" + SNumberUtil.fillZeros(s.toString(), 2);
					break;
				case "h:m:s":
					return h + ":" + m + ":" + s;
					break;
				case "hh:mm:ss:ss.s":
					return SNumberUtil.fillZeros(h.toString(), 2) + ":" + SNumberUtil.fillZeros(m.toString(), 2) + ":" + SNumberUtil.fillZeros(s.toString(), 2) + ":" + ms.toFixed(1);
					break;
				case "h:m:s:ss.s":
					return h + ":" + m + ":" + s + ":" + ms.toFixed(1);
					break;
				case "h点m分s秒":
					return (h ? (h + "点") : "") + (m ? (m + "分") : "") + s + "秒";
					break;
				case "H点M分S秒":
					return (h ? (SNumberUtil.toChineseNumber(h) + "点") : "") + (m ? (SNumberUtil.toChineseNumber(m) + "分") : "") + SNumberUtil.toChineseNumber(s) + "秒";
					break;
			}
			return date.toString();
		}

		/**
		 * 将时间长度转换为字符串
		 *
		 * @param date 日期
		 * @param format 时间格式（hh:mm:ss，h:m:s，hh:mm:ss:ss.s，h:m:s:ss.s，h小时m分钟s秒，H小时M分钟S秒）
		 * @return 转换完毕的字符串
		 *
		 */
		public static function toDurTimeString(time : Number, format : String = "hh:mm:ss") : String
		{
			var ms : Number = (time % 1000) / 10;
			time /= 1000;
			var s : int = time % 60;
			time /= 60;
			var m : int = time % 60;
			time /= 60;
			var h : int = time;

			switch (format)
			{
				case "hh:mm:ss":
					return SNumberUtil.fillZeros(h.toString(), 2) + ":" + SNumberUtil.fillZeros(m.toString(), 2) + ":" + SNumberUtil.fillZeros(s.toString(), 2);
					break;
				case "h:m:s":
					return h + ":" + m + ":" + s;
					break;
				case "hh:mm:ss:ss.s":
					return SNumberUtil.fillZeros(h.toString(), 2) + ":" + SNumberUtil.fillZeros(m.toString(), 2) + ":" + SNumberUtil.fillZeros(s.toString(), 2) + ":" + ms.toFixed(1);
					break;
				case "h:m:s:ss.s":
					return h + ":" + m + ":" + s + ":" + ms.toFixed(1);
					break;
				case "h小时m分钟s秒":
					return (h ? (h + "小时") : "") + (m ? (m + "分钟") : "") + (s || (!h && !m) ? s + "秒" : "");
					break;
				case "h时m分s秒":
					return (h ? (h + "时") : "") + (m ? (m + "分") : "") + (s || (!h && !m) ? s + "秒" : "");
					break;
				case "H小时M分钟S秒":
					return (h ? (SNumberUtil.toChineseNumber(h) + "小时") : "") + (m ? (SNumberUtil.toChineseNumber(m) + "分钟") : "") + (s ? SNumberUtil.toChineseNumber(s) + "秒" : "");
					break;
			}
			return time.toString();
		}
	}
}