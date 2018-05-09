package com.sunny.game.engine.utils.text
{
	import com.sunny.game.engine.utils.display.SColorUtil;

	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *
	 * <p>
	 * SunnyGame的一个HTML代码辅助类
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
	public class SHtmlUtil
	{
		/**
		 * 加颜色
		 * @return
		 *
		 */
		public static function applyColor(v : String, c : uint) : String
		{
			return "<font color='" + SColorUtil.getColorString(c) + "'>" + v + "</font>";
		}

		/**
		 * 加字号
		 * @param v
		 * @param s
		 * @return
		 *
		 */
		public static function applySize(v : String, s : int) : String
		{
			if (s)
				return "<font size='" + s.toString() + "'>" + v + "</font>";
			else
				return v;
		}

		/**
		 * 根据TextFormat附加HTML文本
		 * @param v
		 * @param format
		 *
		 */
		public static function applyTextFormat(v : String, format : TextFormat) : String
		{
			var t : TextField = new TextField();
			t.defaultTextFormat = format;
			t.text = v;
			return t.htmlText;
		}

		/**
		 *
		 * @param st
		 * @param _color
		 * @param size
		 * @param align center left right
		 * @param cssName
		 * @param style 样式  u 下划线  b 粗体 i 斜体
		 * @return
		 *
		 */
		public static function converToHtml(st : String, color : uint = 0, size : int = 12, align : String = "center", cssName : String = "", style : String = "") : String
		{
			var t : String = '<font color="#' + color.toString(16) + '" ' + 'size="' + size + '"' + '>' + st + '</font>';
			if (cssName)
				t = '<p align ="' + align + '">' + t + '</p>';
			else
				t = '<p ' + 'class ="' + cssName + '" ' + 'align ="' + align + '">' + t + '</p>';
			switch (style)
			{
				case "i":
					t = '<i>' + t + '</i>';
					break;
				case "u":
					t = '<u>' + t + '</u>';
					break;
				case "b":
					t = '<b>' + t + '</b>';
					break;

			}
			return t;
		}

		/**
		 *
		 * @param txt
		 * //	/(?<=<).*?(?=>)/g)
		 */
		public static function getStyleObjectByTextField(txt : TextField) : Object
		{
			var ob : Object = new Object();
			var st : String = txt.htmlText;

			var params : Array = ["color", "size", "face", "class", "align", "letterspacing"];
			var len : int = params.length;
			var arr : Array;
			var i : int;
			for (i = 0; i < len; i++)
			{
				var reg : RegExp = new RegExp('(?<=' + params[i] + '=").*?(?=")', "ig");
				arr = st.match(reg);
				if (arr.length != 0)
				{
					ob[params[i]] = arr[0];
				}
			}
			arr = st.match(/(?<=<).*?(?=>)/g);

			len = arr.length;
			for (i = 0; i < len; i++)
			{
				switch (arr[i])
				{
					case "i":
						ob.style = arr[i];
						break;
					case "u":
						ob.style = arr[i];
						break;
					case "b":
						ob.style = arr[i];
						break;

					case "I":
						ob.style = arr[i];
						break;
					case "U":
						ob.style = arr[i];
						break;
					case "B":
						ob.style = arr[i];
						break;
				}
			}
			return ob;

		}

		/**
		 * 将字符串装成html格式字符串
		 * @param st
		 * @param ob
		 * @return
		 */
		public static function converWordStyle(st : String, ob : Object) : String
		{

			var t : String = '<font ';
			if (ob.color != null)
			{
				t = t + 'color="' + ob.color + '" ';
			}
			if (ob.size != null)
			{
				t = t + 'size="' + ob.size + '" ';
			}

			if (ob.face != null)
			{
				t = t + 'face="' + ob.face + '" ';
			}
			if (ob.letterspacing != null)
			{
				t = t + 'letterspacing="' + ob.letterspacing + '" ';
			}

			if (ob.size != null || ob.color != null || ob.font != null || ob.letterspacing != null)
			{

				st = t + '>' + st + '</font>';

			}
			if (ob.style != null)
			{
				switch (ob.style)
				{
					case "i":
						st = '<i>' + st + '</i>';
						break;
					case "u":
						st = '<u>' + st + '</u>';
						break;
					case "b":
						st = '<b>' + st + '</b>';
						break;

				}
			}

			return st;
		}

		public static function cloneStyleObject(ob : Object) : Object
		{
			var newOb : Object = {};
			for (var pname : String in ob)
			{
				newOb[pname] = ob[pname];
			}
			return newOb;
		}

		public static function changeStyle(txt : TextField, ob : Object) : void
		{
			var st : String = txt.text;
			var t : String = '<font ';
			if (ob.color != null)
				t = t + 'color="' + ob.color + '" ';
			if (ob.size != null)
				t = t + 'size="' + ob.size + '" ';

			if (ob.face != null)
				t = t + 'face="' + ob.face + '" ';
			if (ob.letterspacing != null)
				t = t + 'letterspacing="' + ob.letterspacing + '" ';

			if (ob.size != null || ob.color != null || ob.font != null || ob.letterspacing != null)
				st = t + '>' + st + '</font>';

			t = "<p ";
			if (ob.cssName != null)
				t = t + 'class="' + ob.cssName + '" ';

			if (ob.align != null)
				t = t + 'align="' + ob.align + '" ';
			t = t + '>';

			if (ob.cssName != null || ob.align != null)
				st = t + st + '</p>';

			switch (ob.style)
			{
				case "i":
					st = '<i>' + st + '</i>';
					break;
				case "u":
					st = '<u>' + st + '</u>';
					break;
				case "b":
					st = '<b>' + st + '</b>';
					break;
			}
			txt.htmlText = st;
		}

		/**
		 * 自定义样式对象
		 * @param color 颜色
		 * @param size  大小
		 * @param align 排版   center left right
		 * @param letter 字体间距
		 * @param cssName
		 * @param style 样式  u 下划线  b 粗体 i 斜体
		 * @return
		 *
		 */
		public static function maskStyleObject(color : uint = 0, size : int = 12, font : Array = null, letter : int = 0, align : String = "center", cssName : String = "", style : String = "") : Object
		{
			var ob : Object = new Object();
			var _font : String = "";
			if (font != null)
			{
				var len : int = font.length;
				for (var i : int = 0; i < len; i++)
				{
					var st : String = font[i] as String;
					_font = _font + st + ",";
				}
				_font = _font.slice(0, _font.length - 1);
				ob.face = _font;

			}
			ob.letterspacing = letter.toString();
			ob.color = "#" + color.toString(16);
			ob.size = size.toString();
			ob.align = align;
			if (cssName != "")
				ob.cssName = cssName;
			if (style != "")
				ob.style = style;
			return ob;
		}
	}
}