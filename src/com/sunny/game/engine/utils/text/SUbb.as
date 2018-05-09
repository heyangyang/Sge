package com.sunny.game.engine.utils.text
{

	/**
	 * UBB

代码是

HTML

的一个变种

,

是

Ultimate Bulletin Board (

国外的一个

BBS

程序

)

采用的一

种特殊的

TAG

。

	 * 标记编辑

支持的标记

UBB支持的标记主要如下表格所示[1] ：




UltraBoard Code


说明




[url]www.atool.org[/url]


加入带有说明的超级链接。




[url=http://www.atool.org]www.atool.org[/url]







[url=http://www.atool.org]www.atool.org[/url]







[download=http://www.atool.org/2.zip]下载[/download]


下载地址和说明




[email]ubb@atool.org[/email]


加入带有说明的电子邮件地址。




[img]http://www.atool.org/res/logo.png[/img]


显示你的图像，但请记住，http://是必须的。




[b]粗体[/b]


粗体显示




[i]斜体[/i]


斜体显示




[u]下划线[/u]


带有下划线的显示




[1]字号一[/1]


字号一




[2]字号二[/2]


字号二




[3]字号三[/3]


字号三




[4]字号四[/4]


字号四




[sup]上标[/sup]


上标显示




[sub]下标[/sub]


下标显示




[center]居中[/center]


居中显示




[right]居右[/right]







[color=#0000FF]颜色[/color]


带有颜色的显示




[&]


显示符号 &




[*]条目


无序缩进和列表




[list]条目


条目




[quote]引用[/quote]


引用显示




[fly]滚动文本[/fly]


相当于html marquee tag,其中direction为right，behavior为scroll，scrollamount为10，scrolldelay为200




[font=宋体]字体[/font]


字体




[size=3]字体大小[/size]


字体大小




[#f7f7f7]彩色[/#]


同[color]标记




[w]http://www.atool.org[/w]或


在当前浏览其中显示一个浏览器窗口，相当于iframe，请注意url必须输入正确




[f w=200 h=300]http://www.atool.org/1.swf[/f] [f]http://www.atool.org/1.swf[/f]


flash,w为高度，h为宽度，使用第二种方式时缺省宽度和高度为500像素




[code]代码[/code]


代码显示

	 *
	 *
	 *  使用方法

[red]文字[/red]红色

[green]文字[/green] 绿色

[blue]文字[/blue] 蓝色

[white]文字[/white] 白色

[purple]文字[/purple] 紫色

[yellow]文字[/yellow] 黄色

[violet]文字[/violet] 紫罗兰色

[brown]文字[/brown] 褐色

[black]文字[/black] 黑色

[pink]文字[/pink] 粉红色

[orange]文字[/orange] 橙色

[gold]文字[/gold] 金色

[h1]文字[/h1] 标题1

[h2]文字[/h2] 标题2

[h3]文字[/h3] 标题3

[h4]文字[/h4] 标题4

[h5]文字[/h5] 标题5

[h6]文字[/h6] 标题6

[size=1]文字[/size=1] 1号字

[size=2]文字[/size=2] 2号字(偏小)

[size=3]文字[/size=3] 3号字(正常大小)

[size=4]文字[/size=4] 4号字(偏大)

[size=5]文字[/size=5] 5号字

[size=6]文字[/size=6] 6号字

[font=仿宋]文字[/font=仿宋] 仿宋体

[font=黑体]文字[/font=黑体] 黑体

[font=楷体]文字[/font=楷体] 楷体

[font=隶书]文字[/font=隶书] 隶书体

[font=宋体]文字[/font=宋体] 宋体

[font=幼圆]文字[/font=幼圆] 幼圆体

[b]文字[/b]加粗

[u]文字[/u] 下划线

[i]文字[/i]倾斜

[left]文字[/left]文字 左对齐

[center]文字[/center] 居中

[right]文字[/right] 右对齐

[url=链接地址]链接文字[/url] 超级链接

[code]文字[/code] 代码

[IMG]图片地址[/IMG] 贴图

[mail]文字[/mail] EMAIL地址

[quote]文字[/quote] 引用文字

[movl]文字[/movl] 文字左移

[movlr]文字[/movlr] 文字左右移

[movr]文字[/movr] 文字右移

[hide]文字[/hide] 隐藏回复可见内容，只能用于主题帖

[flash]文字[/flash] flash地址(swf)

[music]文字[/music] 音乐地址(mp3，wma，rm，mid)

[movie]文字[/movie] 电影地址(wmv，avi)

[media]文字[/media] 电影地址(wmv，avi)

[light]文字[/light] 彩字
	 * @author Administrator
	 *
	 */
	public class SUbb
	{
		public static function decode(v : String) : String
		{
			v = v.replace(/\[(b|i|u|p|br)\]/ig, "<$1>");
			v = v.replace(/\[\/(b|i|u|p)\]/ig, "</$1>");

			v = v.replace(/\[(color|size|face|align)=(.*?)]/ig, replFN);
			v = v.replace(/\[\/(color|size|face|align)\]/ig, "</font>");

			v = v.replace(/\[img\](.*?)\[\/img\]/ig, "<img src='$1'/>");
			v = v.replace(/\[url\](.*?)\[\/url\]/ig, "<a href='$1'/>$1</a>");
			v = v.replace(/\[url=(.*?)\](.*)?\[\/url\]/ig, "<a href='$1'/>$2</a>");
			v = v.replace(/\[email\](.*?)\[\/email\]/ig, "<a href='mailto:$1'>$1</a>");
			v = v.replace(/\[email=(.*?)\](.*)?\[\/email\]/ig, "<a href='mailto:$1'>$2</a>");

			return v;
		}

		private static const COLORS : Array = ["red", "blue", "green", "yellow", "fuchsia", "aqua", "black", "white", "gray","purple","orange"];
		private static const COLOR_REPS : Array = ["#FF0000", "#0000FF", "#00FF00", "#FFFF00", "#FF00FF", "#00FFFF", "#000000", "#FFFFFF", "#808080","#800080","#FFA500"];

		private static function replFN() : String
		{
			var s : String = arguments[2];
			var f : String = s.charAt(0);
			var e : String = s.charAt(s.length - 1);
			if (e == f && (e == "'" || e == "\""))
				s = s.slice(1, s.length - 1);

			if (arguments[1].toLowerCase() == "color")
			{
				var index : int = COLORS.indexOf(s.toLowerCase());
				if (index != -1)
					s = COLOR_REPS[index];
			}

			return "<font " + arguments[1] + "=\"" + s + "\">"
		}
	}
}