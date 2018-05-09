package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	import flash.utils.ByteArray;

	/**
	 *
	 * <p>
	 * SunnyGame的一个字符串工具，format方法提供了一个强大的机制来格式化和模板字符串。
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
	public class SStringUtil
	{
		/**
		 * Constructor, throws an error if called, as this is an abstract class.
		 */
		public function SStringUtil()
		{
			throw new SunnyGameEngineError("This is an abstract class.");
		}

		//忽略大小字母比较字符是否相等;   
		public static function equalsIgnoreCase(char1 : String, char2 : String) : Boolean
		{
			return char1.toLowerCase() == char2.toLowerCase();
		}

		//比较字符是否相等;   
		public static function equals(char1 : String, char2 : String) : Boolean
		{
			return char1 == char2;
		}

		//是否为Email地址;   
		public static function isEmail(char : String) : Boolean
		{
			if (char == null)
			{
				return false;
			}
			char = trim(char);
			var pattern : RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result : Object = pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		//是否是数值字符串;   
		public static function isNumber(char : String) : Boolean
		{
			if (char == null)
			{
				return false;
			}
			return !isNaN(Number(char));
		}

		//是否为Double型数据;   
		public static function isDouble(char : String) : Boolean
		{
			char = trim(char);
			var pattern : RegExp = /^[-\+]?\d+(\.\d+)?$/;
			var result : Object = pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		//Integer;   
		public static function isInteger(char : String) : Boolean
		{
			if (char == null)
			{
				return false;
			}
			char = trim(char);
			var pattern : RegExp = /^[-\+]?\d+$/;
			var result : Object = pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		//English;   
		public static function isEnglish(char : String) : Boolean
		{
			if (char == null)
			{
				return false;
			}
			char = trim(char);
			var pattern : RegExp = /^[A-Za-z]+$/;
			var result : Object = pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		//中文;   
		public static function isChinese(char : String) : Boolean
		{
			if (char == null)
			{
				return false;
			}
			char = trim(char);
			var pattern : RegExp = /^[\u0391-\uFFE5]+$/;
			var result : Object = pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		/**
		 * 获取字符的字节长度，英文字符为1字节，中文为2字节
		 * @param value
		 * @return
		 */
		public static function getStringByteLength(value : String) : int
		{
			if (value == null)
				return 0;
			var length : int = 0;
			var stringLength : int = value.length;
			var charCode : Number;
			for (var i : int = 0; i < stringLength; i++)
			{
				charCode = value.charCodeAt(i);
				if (charCode > 0x80)
				{
					length += 2;
				}
				else
				{
					length += 1;
				}
			}
			return length;
		}

		//双字节   
		public static function isDoubleChar(char : String) : Boolean
		{
			if (char == null)
			{
				return false;
			}
			char = trim(char);
			var pattern : RegExp = /^[^\x00-\xff]+$/;
			var result : Object = pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		//含有中文字符   
		public static function hasChineseChar(char : String) : Boolean
		{
			if (char == null)
			{
				return false;
			}
			char = trim(char);
			var pattern : RegExp = /[^\x00-\xff]/;
			var result : Object = pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		//注册字符;   
		public static function hasAccountChar(char : String, len : uint = 15) : Boolean
		{
			if (char == null)
			{
				return false;
			}
			if (len < 10)
			{
				len = 15;
			}
			char = trim(char);
			var pattern : RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + len + "}$", "");
			var result : Object = pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		//URL地址;   
		public static function isURL(char : String) : Boolean
		{
			if (char == null)
			{
				return false;
			}
			char = trim(char).toLowerCase();
			var pattern : RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
			var result : Object = pattern.exec(char);
			if (result == null)
			{
				return false;
			}
			return true;
		}

		// 是否为空白;          
		public static function isWhitespace(char : String) : Boolean
		{
			switch (char)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
				default:
					return false;
			}
		}

		//去左右空格;   
		public static function trim(char : String) : String
		{
			if (char == null)
			{
				return null;
			}
			return rtrim(ltrim(char));
		}

		//去左空格;    
		public static function ltrim(char : String) : String
		{
			if (char == null)
			{
				return null;
			}
			var pattern : RegExp = /^\s*/;
			return char.replace(pattern, "");
		}

		//去右空格;   
		public static function rtrim(char : String) : String
		{
			if (char == null)
			{
				return null;
			}
			var pattern : RegExp = /\s*$/;
			return char.replace(pattern, "");
		}

		//是否为前缀字符串;   
		public static function beginsWith(char : String, prefix : String) : Boolean
		{
			return (prefix == char.substring(0, prefix.length));
		}

		//是否为后缀字符串;   
		public static function endsWith(char : String, suffix : String) : Boolean
		{
			return (suffix == char.substring(char.length - suffix.length));
		}

		//去除指定字符串;   
		public static function remove(char : String, remove : String) : String
		{
			return replace(char, remove, "");
		}

		//字符串替换;   
		public static function replace(char : String, replace : String, replaceWith : String) : String
		{
			return char.split(replace).join(replaceWith);
		}

		//utf16转utf8编码;   
		public static function utf16to8(char : String) : String
		{
			var out : Array = new Array();
			var len : uint = char.length;
			for (var i : uint = 0; i < len; i++)
			{
				var c : int = char.charCodeAt(i);
				if (c >= 0x0001 && c <= 0x007F)
				{
					out[i] = char.charAt(i);
				}
				else if (c > 0x07FF)
				{
					out[i] = String.fromCharCode(0xE0 | ((c >> 12) & 0x0F), 0x80 | ((c >> 6) & 0x3F), 0x80 | ((c >> 0) & 0x3F));
				}
				else
				{
					out[i] = String.fromCharCode(0xC0 | ((c >> 6) & 0x1F), 0x80 | ((c >> 0) & 0x3F));
				}
			}
			return out.join('');
		}

		//utf8转utf16编码;   
		public static function utf8to16(char : String) : String
		{
			var out : Array = new Array();
			var len : uint = char.length;
			var i : uint = 0;
			var char2 : int, char3 : int;
			while (i < len)
			{
				var c : int = char.charCodeAt(i++);
				switch (c >> 4)
				{
					case 0:
					case 1:
					case 2:
					case 3:
					case 4:
					case 5:
					case 6:
					case 7:
						// 0xxxxxxx   
						out[out.length] = char.charAt(i - 1);
						break;
					case 12:
					case 13:
						// 110x xxxx   10xx xxxx   
						char2 = char.charCodeAt(i++);
						out[out.length] = String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
						break;
					case 14:
						// 1110 xxxx  10xx xxxx  10xx xxxx   
						char2 = char.charCodeAt(i++);
						char3 = char.charCodeAt(i++);
						out[out.length] = String.fromCharCode(((c & 0x0F) << 12) | ((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));
						break;
				}
			}
			return out.join('');
		}

		//转换字符编码;   
		public static function encodeCharset(char : String, charset : String) : String
		{
			var bytes : ByteArray = new ByteArray();
			bytes.writeUTFBytes(char);
			bytes.position = 0;
			return bytes.readMultiByte(bytes.length, charset);
		}

		//添加新字符到指定位置;          
		public static function addAt(char : String, value : String, position : int) : String
		{
			if (position > char.length)
			{
				position = char.length;
			}
			var firstPart : String = char.substring(0, position);
			var secondPart : String = char.substring(position, char.length);
			return (firstPart + value + secondPart);
		}

		//替换指定位置字符;   
		public static function replaceAt(char : String, value : String, beginIndex : int, endIndex : int) : String
		{
			beginIndex = Math.max(beginIndex, 0);
			endIndex = Math.min(endIndex, char.length);
			var firstPart : String = char.substr(0, beginIndex);
			var secondPart : String = char.substr(endIndex, char.length);
			return (firstPart + value + secondPart);
		}

		//删除指定位置字符;   
		public static function removeAt(char : String, beginIndex : int, endIndex : int) : String
		{
			return replaceAt(char, "", beginIndex, endIndex);
		}

		//修复双换行符;   
		public static function fixNewlines(char : String) : String
		{
			return char.replace(/\r\n/gm, "\n");
		}

		/**
		 * 根据一个毫秒数转换成当前日期时间
		 * @return
		 *
		 */
		public static function swapTime(time : Number) : String
		{
			var date : Date = new Date();
			date.setTime(time);
			var minutes : String = String(date.minutes);
			if (date.minutes < 10)
				minutes = "0" + String(date.minutes);
			return date.fullYear + "/" + (date.month + 1) + "/" + date.date + " " + date.hours + ":" + minutes;
		}

		/**
		 * 将毫秒数转换成时分秒的倒计时
		 * @return
		 */
		public static function swapTimeCount(time : Number) : String
		{
			var d : int = int(time / 86400000);
			var h : int = (time / 3600000) % 24;
			var m : int = (time / 60000) % 60;
			var s : int = (time / 1000) % 60;

			var hStr : String = h.toString();
			var mStr : String = m.toString();
			var sStr : String = s.toString();

			if (hStr.length < 2)
				hStr = "0" + hStr;
			if (mStr.length < 2)
				mStr = "0" + mStr;
			if (sStr.length < 2)
				sStr = "0" + sStr;
			if (d > 0)
				return d + "天" + hStr + "时" + mStr + "分" + sStr + "秒";
			else
				return hStr + ":" + mStr + ":" + sStr;
		}

		/**
		 *
		 * @param time 秒
		 * @return
		 *
		 */
		public static function swapTimeMin(time : Number) : String
		{
			var h : int = Math.floor(time / 3600);
			var m : int = time / 60 % 60;

			var day : String = "";
			if (h > 0)
				day += h + "小时";
			if (m > 0)
				day += m + "分";
			return day;
		}

		/**
		 * 将数字转成指定长度的字符串，不足的用0补
		 * @param value
		 * @param length
		 * @return
		 *
		 */
		public static function numberToString(value : uint, length : int) : String
		{
			var valueString : String = value.toString();
			var valueLength : int = valueString.length;
			if (valueLength > length)
				return valueString.substring(valueLength - length, valueLength);
			else if (valueLength == length)
				return valueString;
			else
			{
				var cha : int = length - valueLength;
				while (cha)
				{
					valueString = "0" + valueString;
					cha--;
				}
				return valueString;
			}
			return valueString;
		}

		public static function fontColor(str : String, color : String, size : int = 12) : String
		{
			return "<font color='" + color + "' size='" + size + "'>" + str + "</font>";
		}

		/**
		 * 数值分区
		 * @param value
		 * @return
		 *
		 */
		public static function numberPartition(value : int) : String
		{
			var tmp : String = "";
			var numText : String = value.toString();
			var len : int = numText.length;
			for (var i : int = len; i >= 0; i -= 3)
			{
				var min : int = i - 3;
				if (min <= 0)
				{
					min = 0;
					tmp = numText.substring(min, i) + tmp;
					break;
				}
				else
				{
					tmp = "," + numText.substring(min, i) + tmp;
				}
			}
			return tmp;
		}

		/**
		 * html转大写,主要是防止写错,如果格式不对将返回空字符串
		 * @param str
		 * @return
		 */
		public static function htmlToUpperCase(str : String) : String
		{
			var outStr : String = "";
			var inBracket : Boolean = false; //在括号里的状态
			var inBracketCount : int = 0; //括号进入次数
			var propertyFlgCount : int = 0; //属性值的标志数量
			var propertyFlg : String = null; //属性值的标志

			var subString : String;
			for (var j : int = 0; j < str.length; j++)
			{
				//判断是否进入括号
				subString = str.charAt(j);
				if (subString == "<")
				{
					if (inBracketCount == 0)
						inBracket = true;
					++inBracketCount;
				}
				else if (subString == ">")
				{
					--inBracketCount;
					if (inBracketCount == 0)
						inBracket = false;
				}
				//如果进入括号，对字符进行转换
				if (inBracket)
				{
					//属性值的开始,必定有两个符号数
					if (subString == "=")
						propertyFlgCount = 2;
					//属性值的转单引号，属性值开始和结束的时候都转一下单引号
					if (subString == "'" || subString == "\"")
					{
						if (propertyFlg == null)
						{
							propertyFlg = subString;
							outStr += "\"";
							propertyFlgCount--;
							continue;
						}
						else if (propertyFlg == subString)
						{
							propertyFlg = null;
							outStr += "\"";
							propertyFlgCount--;
							continue;
						}
						outStr += subString;
						continue;
					}
					//转大写
					if (inBracketCount > 0 && propertyFlg == null)
					{
						if (subString >= 'a' && subString <= 'z')
							outStr += String.fromCharCode(subString.charCodeAt() - 32); //小写：cByte += 32  大写: cByte -= 32;
						else
							outStr += subString;
						continue;
					}
				}

				outStr += subString;
			}
			//格式错误的就直接给空字符串
			if (inBracketCount != 0 || propertyFlgCount != 0 || propertyFlg != null)
			{
				outStr = "";
			}
			return outStr;
		}

		/**
		 * Creates a new string by repeating an input string.
		 * @param s the string to repeat
		 * @param reps the number of times to repeat the string
		 * @return a new String containing the repeated input
		 */
		public static function repeat(s : String, reps : int) : String
		{
			if (reps == 1)
				return s;

			var b : ByteArray = new ByteArray();
			for (var i : uint = 0; i < reps; ++i)
				b.writeUTFBytes(s);
			b.position = 0;
			return b.readUTFBytes(b.length);
		}

		/**
		 * Aligns a string by inserting padding space characters as needed.
		 * @param s the string to align
		 * @param align an integer indicating both the desired length of
		 *  the string (the absolute value of the input) and the alignment
		 *  style (negative for left alignment, positive for right alignment)
		 * @return the aligned string, padded or truncated as necessary
		 */
		public static function align(s : String, align : int) : String
		{
			var left : Boolean = align < 0;
			var len : int = left ? -align : align, slen : int = s.length;
			if (slen > len)
			{
				return left ? s.substr(0, len) : s.substr(slen - len, len);
			}
			else
			{
				var pad : String = repeat(' ', len - slen);
				return left ? s + pad : pad + s;
			}
		}

		/**
		 * Pads a number with a specified number of "0" digits on
		 * the left-hand-side of the number.
		 * @param x an input number
		 * @param digits the number of "0" digits to pad by
		 * @return a padded string representation of the input number
		 */
		public static function pad(x : Number, digits : int) : String
		{
			var neg : Boolean = (x < 0);
			x = Math.abs(x);
			var e : int = 1 + int(Math.log(x) / Math.LN10);
			var s : String = String(x);
			for (; e < digits; e++)
			{
				s = '0' + s;
			}
			return neg ? "-" + s : s;
		}

		/**
		 * Pads a string with zeroes up to given length.
		 * @param s the string to pad
		 * @param n the target length of the padded string
		 * @return the padded string. If the input string is already equal or
		 *  longer than n characters it is returned unaltered. Otherwise, it
		 *  is left-padded with zeroes up to form an n-character string.
		 */
		public static function padString(s : String, n : int) : String
		{
			return (s.length < n ? repeat("0", n - s.length) + s : s);
		}

		// --------------------------------------------------------------------

		/** Default formatting string for numbers. */
		public static const DEFAULT_NUMBER : String = "0.########";

		private static const _BACKSLASH : Number = '\\'.charCodeAt(0);
		private static const _LBRACE : Number = '{'.charCodeAt(0);
		private static const _RBRACE : Number = '}'.charCodeAt(0);
		private static const _QUOTE : Number = '"'.charCodeAt(0);
		private static const _APOSTROPHE : Number = '\''.charCodeAt(0);

		private static function count(s : String, c : Number, i : int) : int
		{
			var n : int = 0;
			for (n = 0; i < s.length && s.charCodeAt(i) == c; ++i)
			{
				++n;
			}
			return n;
		}

		// -- Date Formatting -------------------------------------------------

		/** Array of full names for days of the week. */
		public static var DAY_NAMES : Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		/** Array of abbreviated names for days of the week. */
		public static var DAY_ABBREVS : Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		/** Array of full names for months of the year. */
		public static var MONTH_NAMES : Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		/** Array of abbreviated names for months of the year. */
		public static var MONTH_ABBREVS : Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		/** Abbreviated string indicating "PM" time. */
		public static var PM1 : String = "P";
		/** Full string indicating "PM" time. */
		public static var PM2 : String = "PM";
		/** Abbreviated string indicating "AM" time. */
		public static var AM1 : String = "A";
		/** Full string indicating "AM" time. */
		public static var AM2 : String = "AM";
		/** String indicating "AD" time. */
		public static var AD : String = "AD";
		/** String indicating "BC" time. */
		public static var BC : String = "BC";

		private static const _DATE : Number = 'd'.charCodeAt(0);
		private static const _FRAC : Number = 'f'.charCodeAt(0);
		private static const _FRAZ : Number = 'F'.charCodeAt(0);
		private static const _ERA : Number = 'g'.charCodeAt(0);
		private static const _HOUR : Number = 'h'.charCodeAt(0);
		private static const _HR24 : Number = 'H'.charCodeAt(0);
		private static const _MINS : Number = 'm'.charCodeAt(0);
		private static const _MOS : Number = 'M'.charCodeAt(0);
		private static const _SECS : Number = 's'.charCodeAt(0);
		private static const _AMPM : Number = 't'.charCodeAt(0);
		private static const _YEAR : Number = 'y'.charCodeAt(0);
		private static const _ZONE : Number = 'z'.charCodeAt(0);

		/**
		 * Hashtable of standard formatting flags and their formatting patterns
		 */
		private static const _STD_DATE : Object = {d: "MM/dd/yyyy", D: "dddd, dd MMMM yyyy", f: "dddd, dd MMMM yyyy HH:mm", F: "dddd, dd MMMM yyyy HH:mm:ss", g: "MM/dd/yyyy HH:mm", G: "MM/dd/yyyy HH:mm:ss", M: "MMMM dd", m: "MMMM dd", R: "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'", r: "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'", s: "yyyy-MM-ddTHH:mm:ss", t: "HH:mm", T: "HH:mm:ss", u: "yyyy-MM-dd HH:mm:ssZ", U: "yyyy-MM-dd HH:mm:ssZ", // must convert to UTC!
				Y: "yyyy MMMM", y: "yyyy MMMM"};

		// -- Number Formatting -----------------------------------------------

		private static const GROUPING : String = ';';
		private static const _ZERO : Number = '0'.charCodeAt(0);
		private static const _HASH : Number = '#'.charCodeAt(0);
		private static const _PERC : Number = '%'.charCodeAt(0);
		private static const _DECP : Number = '.'.charCodeAt(0);
		private static const _SEPR : Number = ','.charCodeAt(0);
		private static const _PLUS : Number = '+'.charCodeAt(0);
		private static const _MINUS : Number = '-'.charCodeAt(0);
		private static const _e : Number = 'e'.charCodeAt(0);
		private static const _E : Number = 'E'.charCodeAt(0);

		/** Separator for decimal (fractional) values. */
		public static var DECIMAL_SEPARATOR : String = '.';
		/** Separator for thousands values. */
		public static var THOUSAND_SEPARATOR : String = ',';
		/** String representing Not-a-Number (NaN). */
		public static var NaN : String = 'NaN';
		/** String representing positive infinity. */
		public static var POSITIVE_INFINITY : String = "+Inf";
		/** String representing negative infinity. */
		public static var NEGATIVE_INFINITY : String = "-Inf";

		private static const _STD_NUM : Object = {c: "$#,0.", // currency
				d: "0", // integers
				e: "0.00e+0", // scientific
				f: 0, // fixed-point
				g: 0, // general
				n: "#,##0.", // number
				p: "%", // percent
				//r: 0, // round-trip
				x: 0 // hexadecimal
			};

		private static function numberPattern(b : ByteArray, p : String, x : Number) : void
		{
			var idx0 : int, idx1 : int, s : String = p.charAt(0).toLowerCase();
			var upper : Boolean = s.charCodeAt(0) != p.charCodeAt(0);

			if (isNaN(x))
			{
				// handle NaN
				b.writeUTFBytes(SStringUtil.NaN);
			}
			else if (!isFinite(x))
			{
				// handle infinite values
				b.writeUTFBytes(x < 0 ? NEGATIVE_INFINITY : POSITIVE_INFINITY);
			}
			else if (p.length <= 3 && _STD_NUM[s] != null)
			{
				// handle standard formatting string
				var digits : Number = p.length == 1 ? 2 : int(p.substring(1));

				if (s == 'c')
				{
					digits = p.length == 1 ? 2 : digits;
					if (digits == 0)
					{
						numberPattern(b, _STD_NUM[s], x);
					}
					else
					{
						numberPattern(b, _STD_NUM[s] + "." + repeat("0", digits), x);
					}
				}
				else if (s == 'd')
				{
					b.writeUTFBytes(pad(Math.round(x), digits));
				}
				else if (s == 'e')
				{
					s = x.toExponential(digits);
					s = upper ? s.toUpperCase() : s.toLowerCase();
					b.writeUTFBytes(s);
				}
				else if (s == 'f')
				{
					b.writeUTFBytes(x.toFixed(digits));
				}
				else if (s == 'g')
				{
					var exp : Number = Math.log(Math.abs(x)) / Math.LN10;
					exp = (exp >= 0 ? int(exp) : int(exp - 1));
					digits = (p.length == 1 ? 15 : digits);
					if (exp < -4 || exp > digits)
					{
						s = upper ? 'E' : 'e';
						numberPattern(b, "0." + repeat("#", digits) + s + "+0", x);
					}
					else
					{
						numberPattern(b, "0." + repeat("#", digits), x);
					}
				}
				else if (s == 'n')
				{
					numberPattern(b, _STD_NUM[s] + repeat("0", digits), x);
				}
				else if (s == 'p')
				{
					numberPattern(b, _STD_NUM[s], x);
				}
				else if (s == 'x')
				{
					s = padString(x.toString(16), digits);
					s = upper ? s.toUpperCase() : s.toLowerCase();
					b.writeUTFBytes(s);
				}
				else
				{
					throw new ArgumentError("Illegal standard format: " + p);
				}
			}
			else
			{
				// handle custom formatting string
				// TODO: GROUPING designator is escaped or in string literal
				// TODO: Error handling?
				if ((idx0 = p.indexOf(GROUPING)) >= 0)
				{
					if (x > 0)
					{
						p = p.substring(0, idx0);
					}
					else if (x < 0)
					{
						idx1 = p.indexOf(GROUPING, ++idx0);
						if (idx1 < 0)
							idx1 = p.length;
						p = p.substring(idx0, idx1);
						x = -x;
					}
					else
					{
						idx1 = 1 + p.indexOf(GROUPING, ++idx0);
						p = p.substring(idx1);
					}
				}
				formatNumber(b, p, x);
			}
		}

		/**
		 * 0: Zero placeholder
		 * #: Digit placeholder
		 * .: Decimal point (any duplicates are ignored)
		 * ,: Thosand separator + scaling
		 * %: Percentage placeholder
		 * e/E: Scientific notation
		 *
		 * if has comma before dec point, use grouping
		 * if grouping right before dp, divide by 1000
		 * if percent and no e, multiply by 100
		 */
		private static function formatNumber(b : ByteArray, p : String, x : Number) : void
		{
			var i : int, j : int, c : Number, n : int = 1, digit : int = 0;
			var pp : int = -1, dp : int = -1, ep : int = -1, ep2 : int = -1, sp : int = -1;
			var nd : int = 0, nf : int = 0, ne : int = 0, max : int = p.length - 1;
			var xd : Number, xf : Number, xe : int = 0, zd : int = 0, zf : int = 0;
			var sd : String, sf : String, se : String;
			var hash : Boolean = false;

			// ----------------------------------------------------------------
			// first pass: extract info from the formatting pattern

			for (i = 0; i < p.length; ++i)
			{
				c = p.charCodeAt(i);
				if (c == _ZERO || c == _HASH)
				{
					if (dp == -1)
					{
						if (nd == 0)
							hash = true;
						nd++;
					}
					else
						nf++;
				}
				else if (c == _DECP)
				{
					if (dp == -1)
						dp = i;
				}
				else if (c == _SEPR)
				{
					if (sp == -1)
						sp = i;
				}
				else if (c == _PERC)
				{
					if (pp == -1)
						pp = i;
				}
				else if (c == _e || c == _E)
				{
					if (ep >= 0)
						continue;
					ep = i;
					if (i < max && (c = p.charCodeAt(i + 1)) == _PLUS || c == _MINUS)
						++i;
					for (; i < max && p.charCodeAt(i + 1) == _ZERO; ++i)
					{
						++ne;
					}
					ep2 = i;
					if (p.charCodeAt(ep2) != _ZERO)
					{
						ep = ep2 = -1;
						ne = 0;
					}
				}
				else if (c == _BACKSLASH)
				{
					++i;
				}
				else if (c == _APOSTROPHE)
				{
					// skip string literal
					for (i = i + 1; i < p.length && (c == _BACKSLASH || (c = p.charCodeAt(i)) != _APOSTROPHE); ++i)
					{
					}
				}
				else if (c == _QUOTE)
				{
					// skip string literal
					for (i = i + 1; i < p.length && (c == _BACKSLASH || (c = p.charCodeAt(i)) != _QUOTE); ++i)
					{
					}
				}
			}


			// ----------------------------------------------------------------
			// extract information for second pass

			// process grouping separators and thousands scaling
			var group : Boolean = false, adj : Boolean = true;
			if (sp >= 0)
			{
				if (dp >= 0)
				{
					i = dp;
				}
				else
				{
					i = p.length;
					while (i > sp)
					{
						c = p.charCodeAt(i - 1);
						if (c == _ZERO || c == _HASH || c == _SEPR)
							break;
						--i;
					}
				}
				for (; --i >= sp; )
				{
					if (p.charCodeAt(i) == _SEPR)
					{
						if (adj)
						{
							x /= 1000;
						}
						else
						{
							group = true;
							break;
						}
					}
					else
					{
						adj = false;
					}
				}
			}
			// process percentage
			if (pp >= 0)
			{
				x *= 100;
			}
			// process negative number
			if (x < 0)
			{
				b.writeUTFBytes('-');
				x = Math.abs(x);
			}
			// process power of ten for scientific format
			if (ep >= 0)
			{
				c = Math.log(x) / Math.LN10;
				xe = (c >= 0 ? int(c) : int(c - 1)) - (nd - 1);
				x = x / Math.pow(10, xe);
			}
			// round the number as needed
			c = Math.pow(10, nf);
			x = Math.round(c * x) / c;
			// separate number into component parts
			xd = nf > 0 ? Math.floor(x) : Math.round(x);
			xf = x - xd;
			// create strings for integral and fractional parts
			sd = pad(xd, nd);
			sf = (xf + 1).toFixed(nf).substring(2); // add 1 to avoid AS3 bug
			if (hash)
				for (; zd < sd.length && sd.charCodeAt(zd) == _ZERO; ++zd)
				{
				}
			for (zf = sf.length; --zf >= 0 && sf.charCodeAt(zf) == _ZERO; )
			{
			}


			// ----------------------------------------------------------------
			// second pass: format the number

			var inFraction : Boolean = false;
			for (i = 0, n = 0; i < p.length; ++i)
			{
				c = p.charCodeAt(i);
				if (i == dp)
				{
					if (zf >= 0 || p.charCodeAt(i + 1) != _HASH)
						b.writeUTFBytes(DECIMAL_SEPARATOR);
					inFraction = true;
					n = 0;
				}
				else if (i == ep)
				{
					b.writeUTFBytes(p.charAt(i));
					if ((c = p.charCodeAt(i + 1)) == _PLUS && xe > 0)
						b.writeUTFBytes('+');
					b.writeUTFBytes(pad(xe, ne));
					i = ep2;
				}
				else if (!inFraction && n == 0 && (c == _HASH || c == _ZERO) && sd.length - zd > nd)
				{
					if (group)
					{
						for (n = zd; n <= sd.length - nd; ++n)
						{
							b.writeUTFBytes(sd.charAt(n));
							if ((j = (sd.length - n - 1)) > 0 && j % 3 == 0)
								b.writeUTFBytes(THOUSAND_SEPARATOR);
						}
					}
					else
					{
						n = sd.length - nd + 1;
						b.writeUTFBytes(sd.substr(zd, n - zd));
					}
				}
				else if (c == _HASH)
				{
					if (inFraction)
					{
						if (n <= zf)
							b.writeUTFBytes(sf.charAt(n));
					}
					else if (n >= zd)
					{
						b.writeUTFBytes(sd.charAt(n));
						if (group && (j = (sd.length - n - 1)) > 0 && j % 3 == 0)
							b.writeUTFBytes(THOUSAND_SEPARATOR);
					}
					++n;
				}
				else if (c == _ZERO)
				{
					if (inFraction)
					{
						b.writeUTFBytes(n >= sf.length ? '0' : sf.charAt(n));
					}
					else
					{
						b.writeUTFBytes(sd.charAt(n));
						if (group && (j = (sd.length - n - 1)) > 0 && j % 3 == 0)
							b.writeUTFBytes(THOUSAND_SEPARATOR);
					}
					++n;
				}
				else if (c == _BACKSLASH)
				{
					b.writeUTFBytes(p.charAt(++i));
				}
				else if (c == _APOSTROPHE)
				{
					for (j = i + 1; j < p.length && (c == _BACKSLASH || (c = p.charCodeAt(j)) != _APOSTROPHE); ++j)
					{
					}
					if (j - i > 1)
						b.writeUTFBytes(p.substring(i + 1, j));
					i = j;
				}
				else if (c == _QUOTE)
				{
					for (j = i + 1; j < p.length && (c == _BACKSLASH || (c = p.charCodeAt(j)) != _QUOTE); ++j)
					{
					}
					if (j - i > 1)
						b.writeUTFBytes(p.substring(i + 1, j));
					i = j;
				}
				else
				{
					if (c != _DECP && c != _SEPR)
						b.writeUTFBytes(p.charAt(i));
				}
			}
		}

		/**取正则匹配值*/
		public static function regOf(str : String, reg : RegExp) : String
		{
			var m : Array = String(str || "").match(reg);
			return !m ? "" : m[1];
		}
	}
}
