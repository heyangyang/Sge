package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.utils.swffit.SSwfFit;

	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;

	/**
	 *
	 * <p>
	 * SunnyGame的网页工具
	 * 统一资源定位符 (Uniform Resource Locator, URL) 完整的URL由这几个部分构成：
	 * scheme://host:port/path?query#fragment
	 * PS：所有获取失败时返回null或""
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
	public class SWebUtil
	{
		public static const EVENT_DATA_TO_DESKTOP_COMPLETE : String = "EVENT_DATA_TO_DESKTOP_COMPLETE";

		private static var regWebkit : RegExp = new RegExp("(webkit)[ \\/]([\\w.]+)", "i");

		/**
		 * 整个URl字符串 EX.：返回值：http://www.test.com:80/view.html?id=123#start
		 */
		public static function get url() : String
		{
			return getUrlParams("url");
		}

		/**
		 * 整个URl字符串 EX.：返回值：http://www.test.com:80/view.html?id=123#start
		 */
		public static function get href() : String
		{
			return getUrlParams("href");
		}

		/**
		 * 获取URL中的锚点（信息片断） EX.：返回值：#start
		 */
		public static function get hash() : String
		{
			return getUrlParams("hash");
		}

		/**
		 * URL 的端口部分。如果采用默认的80端口(PS:即使手动添加了:80)，那么返回值并不是默认的80而是空字符。
		 */
		public static function get port() : String
		{
			return (getUrlParams("port") ? getUrlParams("port") : "80");
		}

		/**
		 * URL 的路径部分(就是文件地址) EX.：返回值：/view.html
		 */
		public static function get pathAndName() : String
		{
			return getUrlParams("PathAndName");
		}

		/**
		 * URL 的路径部分(就是文件地址) EX.：返回值：/view.html
		 */
		public static function get Pathname() : String
		{
			return getUrlParams("pathname");
		}

		/**
		 * 查询(参数)部分。除了给动态语言赋值以外的参数 EX.：返回值：?id=123
		 */
		public static function get Search() : String
		{
			return getUrlParams("search");
		}

		/**
		 * 查询(参数)部分。除了给动态语言赋值以外的参数 EX.：返回值：?id=123
		 */
		public static function get QueryString() : String
		{
			return getUrlParams("query");
		}

		/**
		 * URL 的协议部分 EX.：返回值：http:、https:、ftp:、maito:等
		 */
		public static function get Protocol() : String
		{
			return getUrlParams("protocol");
		}

		/**
		 * URL 的主机部分，EX.：返回值：www.test.com
		 */
		public static function get host() : String
		{
			return getUrlParams("host");
		}

		public static function Request(param : String) : String
		{
			var returnValue : String;
			try
			{
				var query : String = QueryString.substr(1);
				var urlv : URLVariables = new URLVariables();
				urlv.decode(query);
				returnValue = urlv[param];
			}
			catch (error : Object)
			{
			}
			if (returnValue == null)
			{
				returnValue = "";
			}
			return returnValue;
		}

		private static function getUrlParams(param : String) : String
		{
			var returnValue : String;
			if (ExternalInterface.available)
			{
				switch (param)
				{
					case "PathAndName":
						returnValue = ExternalInterface.call("function getUrlParams(){return window.location.pathname;}");
						break;
					case "query":
						returnValue = ExternalInterface.call("function getUrlParams(){return window.location.search;}");
						break;
					case "url":
						returnValue = ExternalInterface.call("function getUrlParams(){return window.location.href;}");
						break;
					default:
						returnValue = ExternalInterface.call("function getUrlParams(){return window.location." + param + ";}");
						break;
				}
			}
			return (returnValue ? UrlDecode(returnValue) : "");
		}

		/**
		 * 获取浏览器信息
		 */
		public static function get BrowserAgent() : String
		{
			var returnValue : String;
			if (ExternalInterface.available)
				returnValue = ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
			return (returnValue ? returnValue : "");
		}

		/**
		 * 返回导航到当前网页的超链接所在网页的URL
		 */
		public static function get referrer() : String
		{
			var returnValue : String;
			if (ExternalInterface.available)
				returnValue = ExternalInterface.call("function referrer(){return document.referrer;}");
			return (returnValue ? returnValue : "");
		}

		/**
		 * 是否IE浏览器
		 */
		public static function get IsIE() : Boolean
		{
			return (BrowserMatch().browser.toLowerCase() == "msie");
		}

		/**
		 * 是否FireFox浏览器
		 */
		public static function get IsMozilla() : Boolean
		{
			return (BrowserMatch().browser.toLowerCase() == "mozilla");
		}

		/**
		 * 是否Safari浏览器
		 */
		public static function get IsSafari() : Boolean
		{
			return regWebkit.test(BrowserAgent);
		}

		/**
		 * 是否Opera浏览器
		 */
		public static function get IsOpera() : Boolean
		{
			return (BrowserMatch().browser.toLowerCase() == "opera");
		}

		/**
		 * 获取浏览器类型及对应的版本信息 EX.：BrowserMatch().browser  BrowserMatch().version
		 */
		public static function BrowserMatch() : Object
		{
			var ua : String = BrowserAgent;
			var ropera : RegExp = new RegExp("(opera)(?:.*version)?[ \\/]([\\w.]+)", "i");
			var rmsie : RegExp = new RegExp("(msie) ([\\w.]+)", "i");
			var rmozilla : RegExp = new RegExp("(mozilla)(?:.*? rv:([\\w.]+))?", "i");

			var match : Object = regWebkit.exec(ua) || ropera.exec(ua) || rmsie.exec(ua) || ua.indexOf("compatible") < 0 && rmozilla.exec(ua) || [];

			return {browser: match[1] || "", version: match[2] || "0"};
		}

		/**
		 * 获取页面编码方式，EX.：返回值：GB2312、UTF-8等;
		 */
		public static function get PageEncoding() : String
		{
			var returnValue : String;
			if (ExternalInterface.available)
				returnValue = ExternalInterface.call("function PageEncoding(){return window.document.charset;}"); //IE
			if (returnValue == null)
			{
				if (ExternalInterface.available)
					returnValue = ExternalInterface.call("function PageEncoding(){return window.document.characterSet;}");
			} //FF
			//获取成功
			if (returnValue != null)
			{
				returnValue = returnValue.toUpperCase();
			}
			return (returnValue ? returnValue : "");
		}

		/**
		 * 通过js弹出浏览器提示alert，EX.：Alert("Test");
		 */
		public static function Alert(msg : String) : void
		{
			navigateToURL(new URLRequest("javascript:alert('" + msg + "');"), "_self");
		}

		/**
		 * 通过js的open新窗口打开,（PS：多标签浏览器则新建一个标签打开）
		 */
		public static function Open(url : String) : void
		{
			eval("javascript:window.open('" + url + "','newwindow')");
		}

		/**
		 * URL重定向，使用replace函数，（PS：取消浏览器的前进后退,防止刷新回发数据）
		 */
		public static function Redirect(url : String) : void
		{
			eval("window.location.replace('" + url + "')");
		}

		/**
		 * URL重定向，使用内部navigateToURL函数，（PS：简化了不用每次都new URLRequest的操作）
		 */
		public static function NavigateToURL(url : String, target : String = "_self") : void
		{
			navigateToURL(new URLRequest(url), target);
		}

		/**
		 * 运行js语句，eval
		 */
		public static function eval(code : String) : Object
		{
			var rtn : Object;
			if (ExternalInterface.available)
				rtn = ExternalInterface.call("eval", code + ";void(0);");
			return rtn;
		}

		/**
		 * 1，reload 方法，该方法强迫浏览器刷新当前页面。
		 * 语法：location.reload([bForceGet])
		 * 参数： bForceGet， 可选参数， 默认为 false，从客户端缓存里取当前页。true, 则以 GET 方式，从服务端取最新的页面, 相当于客户端点击 F5("刷新")
		 * @param forceGet
		 *
		 */
		public static function reload(forceGet : Boolean = false) : void
		{
			if (ExternalInterface.available)
			{
				//document.location=document.referrer;window.location=document.referrer;
				//var ret : * = ExternalInterface.call("reload");
				var ret : * = ExternalInterface.call("function reload(){window.location.reload(true);return " + (forceGet ? "true" : "false") + ";}"); //alert('刷新');
				trace(ret);
			}
		}

		public static function dataToDesktop(data : *, defaultFileName : String = null) : void
		{
			var file : FileReference = new FileReference();
			file.addEventListener(Event.COMPLETE, onDataToDesktopComplete);
			file.save(data, defaultFileName);
		}

		private static function onDataToDesktopComplete(e : Event) : void
		{
			var file : FileReference = e.target as FileReference;
			file.removeEventListener(Event.COMPLETE, onDataToDesktopComplete);
			SEvent.dispatchEvent(EVENT_DATA_TO_DESKTOP_COMPLETE);
		}

		/**
		 * URL编码，encoding为空时应用统一的UTF-8编码处理，可设"GB2312"、"UTF-8"等，（兼容性处理，对应JS中的escape）
		 */
		public static function UrlEncode(str : String, encoding : String = "") : String
		{
			if (str == null || str == "")
			{
				return "";
			}
			if (encoding == null || encoding == "")
			{
				return encodeURI(str);
			}
			var returnValue : String = "";
			var byte : ByteArray = new ByteArray();
			byte.writeMultiByte(str, encoding);
			for (var i : int; i < byte.length; i++)
			{
				returnValue += escape(String.fromCharCode(byte[i]));
			}
			return returnValue;
		}

		/**
		 * URL解码，encoding为空时应用统一的UTF-8编码处理，可设"GB2312"、"UTF-8"等，（兼容性处理，对应JS中的unescape）
		 */
		public static function UrlDecode(str : String, encoding : String = "") : String
		{
			if (str == null || str == "")
			{
				return "";
			}
			if (encoding == null || encoding == "")
			{
				return decodeURI(str);
			}
			var returnValue : String = "";
			var byte : ByteArray = new ByteArray();
			byte.writeMultiByte(str, encoding);
			for (var i : int; i < byte.length; i++)
			{
				returnValue += unescape(String.fromCharCode(byte[i]));
			}
			return returnValue;
		}

		public static function getShortcutLink(url : String, icon : String) : ByteArray
		{
			var data : String = "[InternetShortcut]";
			data += "\r\n";
			data += "URL=" + url;
			data += "\r\n";
			data += "IconFile=" + icon;
			data += "\r\n";
			data += "IconIndex=1";
			var bytes : ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
			bytes.position = 0;
			return bytes;
		}

		public static function resizeSwf(sizeInfo : String) : void
		{
			var retJs : *;
			if (sizeInfo == 'autoSize')
			{
				if (ExternalInterface.available)
				{
					retJs = ExternalInterface.call('resizeSwf', '100%', '100%');
				}
			}
			else
			{
				var temp : Array = sizeInfo.split('*');
				var width : int = int(temp[0]);
				var height : int = int(temp[1]);
				if (ExternalInterface.available)
				{
					retJs = ExternalInterface.call('resizeSwf', width + 'px', height + 'px');
				}
			}
		}

		public static function log(content : String) : void
		{
			if (ExternalInterface.available)
				var ret : * = ExternalInterface.call("log", content);
		}

		public static function addOnUnloadListener(listener : Function) : void
		{
			eval("window.onunload =function(){var ret=\"\";try{ret=document.getElementById(\"" + SSwfFit.target + "\").forceDisconnectSocket();}catch(e){} return ret;}");
			addCallback("forceDisconnectSocket", listener);
		}

		public static function addOnBeforeUnloadListener(listener : Function) : void
		{
			eval("window.onbeforeunload =function(){var ret=\"\";try{ret=document.getElementById(\"" + SSwfFit.target + "\").onApplicationClose();}catch(e){} return ret;}");
			addCallback("onApplicationClose", listener);
		}

		public static function addOnresizeListener(listener : Function) : void
		{
			//第一种情况 // for IE6 IE7 
			//其实就是利用各浏览器对转义字符"\v"的理解在ie浏览器中，"\v"没有转义，得到的结果为"v"而在其他浏览器中"\v"表示一个垂直制表符（一定程度上相当于空格）所以ie解析的"\v1" 为 "v1"而其他浏览器解析到 "\v1" 为 "1"在前面加上一个"+"是为了把后面的字符串转变成数字由于ie认为"\v1"为"v1"，所以前面的加上加号无法转变成数字，为NaN其他浏览器均能变成 1再因为js与c语言类似，进行逻辑判断时可使用数字，并且 0 为 false，其他数字则为true所以 !1 = false ，于是其他浏览器均返回falsejs在遇到如下几个值会返回false：undefined、null、NaN，所以ie中 !NaN = true
			eval("window.onload = function(){if(!+\"\/v1\" && !document.querySelector) {document.body.onresize = resize;}else{window.onresize = resize;}try{document.getElementById(\"" + SSwfFit.target + "\").onResize();}catch(e){};}");
//			function resize()
//			{
//				//var w = document.body.clientWidth;//document.getElementById("flashContainer").clientWidth;
//				//var h = document.body.clientHeight;//document.getElementById("flashContainer").clientHeight;
//				//if(w < 1000)w=1000;
//				//if(w > 1920)w=1920;
//                //if(h < 600)h=600;
//				//if(h > 1080)h=1080;
//				//alert('大小变化：' + w + 'px,' + h +'px');
//				//resizeSwf(w + 'px', h + 'px');
//			}
			addCallback("onResize", listener);
		}

		public static function browserPreventDefault() : void
		{
			eval("document.onkeydown=function(e){" + //
				"var isie = (document.all) ? true:false;" + //
				"var key;" + //
				"var ev;" + //
				"if(isie){" + //IE浏览器
				"key = window.event.keyCode;" + //
				"ev = window.event;" + //
				"}else{" + //火狐浏览器
				"key = e.which;" + //
				"ev = e;" + //
				"}" + //
				"if(key==9 || key==17 || key == 16 || key == 18 || key == 81 || key == 67){" + //IE浏览器
				"if(isie){" + //
				//"ev.keyCode=0;" + //
				"ev.returnValue=false;" + //
				"}else{" + //火狐浏览器
				"ev.which=0;" + //
				"ev.preventDefault();" + //
				"}" + //
				"}" + //
				"};" + //

				"document.onkeyup=function(e){" + //
				"var isie = (document.all) ? true:false;" + //
				"var key;" + //
				"var ev;" + //
				"if(isie){" + //IE浏览器
				"key = window.event.keyCode;" + //
				"ev = window.event;" + //
				"}else{" + //火狐浏览器
				"key = e.which;" + //
				"ev = e;" + //
				"}" + //
				"if(key==9 || key==17 || key == 16 || key == 18 || key == 81 || key == 67){" + //IE浏览器
				"if(isie){" + //
				//"ev.keyCode=0;" + //
				"ev.returnValue=false;" + //
				"}else{" + ////火狐浏览器
				"ev.which=0;" + //
				"ev.preventDefault();" + //
				"}" + //
				"}" + //
				"};");
		}

		public static function addCallback(functionName : String, closure : Function) : void
		{
			if (ExternalInterface.available)
				ExternalInterface.addCallback(functionName, closure);
		}
	}
}