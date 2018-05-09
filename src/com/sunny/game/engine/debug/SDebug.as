package com.sunny.game.engine.debug
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.ns.sunny_debug;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.ui.SUIStyle;

	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	use namespace sunny_engine;
	use namespace sunny_debug;

	/**
	 *
	 * <p>
	 * SunnyGame的一个调试器
	 * 辅助类，提供了调试相关的扩展。
	 * Debug.trace()即可使用新的trace。
	 *
	 * 这只是一个简单实现，复杂项目请使用专门的log框架。
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
	public final class SDebug
	{
		public static var OPEN_INFO_TRACE : Boolean = false;
		public static var OPEN_DEBUG_TRACE : Boolean = true;
		public static var OPEN_WARNING_TRACE : Boolean = true;
		public static var OPEN_ERROR_TRACE : Boolean = true;
		public static var OPEN_MEMORY_TRACE : Boolean = false;
		public static var OPEN_TIMER_TRACE : Boolean = true;
		public static var OPEN_THROW_ERROR : Boolean = true;
		sunny_debug static const DEBUG_TRACE_HEAD : String = "[Debug]";
		sunny_debug static const TRACE_INFO_HEAD : String = "[Info]";
		sunny_debug static const ERROR_TRACE_HEAD : String = "[Error]";
		sunny_debug static const WARNING_TRACE_HEAD : String = "[Warning]";

		public static var debugContainer : Sprite;
		public static var traceHandler : Function;

		public function SDebug()
		{
		}

		public static function createDebugContainer() : void
		{
			if (!debugContainer)
			{
				debugContainer = new Sprite();
				debugContainer.mouseChildren = false;
				debugContainer.mouseEnabled = false;
				SShellVariables.nativeStage.addChild(debugContainer);
			}
		}

		public static function infoPrint(object : Object, message : String, ... parameters) : void
		{
			if (SDebug.OPEN_INFO_TRACE)
			{
				var strArr : Array = message.split("%s");
				var msg : String = "";
				msg += SDebug.TRACE_INFO_HEAD + " ";
				for (var i : int = 0; i < strArr.length; i++)
				{
					if (parameters && parameters.length > i)
						msg += strArr[i] + parameters[i];
					else
						msg += strArr[i] + " ";
				}
				msg += " ";
				if (SDebug.OPEN_MEMORY_TRACE)
					msg += (System.totalMemory / 1e6).toFixed(3) + "mb" + " ";
				if (SDebug.OPEN_TIMER_TRACE)
					msg += getTimer() + "ms";
				trace(msg);
			}
		}

		public static function errorPrint(object : Object, message : String, ... parameters) : void
		{
			if (SDebug.OPEN_ERROR_TRACE)
			{
				var strArr : Array = message.split("%s");
				var msg : String = "";
				msg += SDebug.ERROR_TRACE_HEAD + " ";
				if (object)
					msg += String(object) + " ";
				for (var i : int = 0; i < strArr.length; i++)
				{
					if (parameters && parameters.length > i)
						msg += strArr[i] + parameters[i];
					else
						msg += strArr[i] + " ";
				}

				traceHandler && traceHandler(msg, "#FF5B5B");
				msg += " ";
				if (SDebug.OPEN_MEMORY_TRACE)
					msg += (System.totalMemory / 1e6).toFixed(3) + "mb" + " ";
				if (SDebug.OPEN_TIMER_TRACE)
					msg += getTimer() + "ms";
				if (SDebug.OPEN_THROW_ERROR)
					throw new Error(msg);
			}
		}

		public static function debug(message : String) : void
		{
			traceHandler && traceHandler(message, "#00ff00");
		}

		public static function debugPrint(object : Object, message : String, ... parameters) : void
		{
			if (SDebug.OPEN_DEBUG_TRACE)
			{
				var strArr : Array = message.split("%s");
				var msg : String = "";
				msg += SDebug.DEBUG_TRACE_HEAD + " ";
				if (object)
					msg += String(object) + " ";
				for (var i : int = 0; i < strArr.length; i++)
				{
					if (parameters && parameters.length > i)
						msg += strArr[i] + parameters[i];
					else
						msg += strArr[i] + " ";
				}
				msg += " ";
				if (SDebug.OPEN_MEMORY_TRACE)
					msg += (System.totalMemory / 1e6).toFixed(3) + "mb" + " ";
				if (SDebug.OPEN_TIMER_TRACE)
					msg += getTimer() + "ms";
				trace(msg);
			}
		}

		public static function warningPrint(object : Object, message : String, ... parameters) : void
		{
			if (SDebug.OPEN_WARNING_TRACE)
			{
				var strArr : Array = message.split("%s");
				var msg : String = "";
				msg += SDebug.WARNING_TRACE_HEAD + " ";
				if (object)
					msg += String(object) + " ";
				for (var i : int = 0; i < strArr.length; i++)
				{
					if (parameters && parameters.length > i)
						msg += strArr[i] + parameters[i];
					else
						msg += strArr[i] + " ";
				}
				msg += " ";
				if (SDebug.OPEN_MEMORY_TRACE)
					msg += (System.totalMemory / 1e6).toFixed(3) + "mb" + " ";
				if (SDebug.OPEN_TIMER_TRACE)
					msg += getTimer() + "ms";
				trace(msg);
			}
		}

		private static var fatalErrorTextField : TextField;

		/**
		 * 致命错误
		 * @param message
		 *
		 */
		public static function showFatalError(message : String) : void
		{
			if (!fatalErrorTextField)
			{
				fatalErrorTextField = new TextField();
				var textFormat : TextFormat = new TextFormat(SUIStyle.TEXT_FONT, 12, 0xFFFFFF);
				textFormat.align = TextFormatAlign.CENTER;
				fatalErrorTextField.defaultTextFormat = textFormat;
				fatalErrorTextField.wordWrap = true;
				fatalErrorTextField.autoSize = TextFieldAutoSize.CENTER;
				fatalErrorTextField.background = true;
				fatalErrorTextField.backgroundColor = 0x440000;
				fatalErrorTextField.mouseEnabled = fatalErrorTextField.mouseWheelEnabled = fatalErrorTextField.selectable = false;
			}
			if (SShellVariables.nativeStage)
			{
				SShellVariables.nativeOverlay.clear();
				SShellVariables.nativeOverlay.addChild(fatalErrorTextField);
				fatalErrorTextField.width = SShellVariables.nativeStage.stageWidth * 0.75;
			}
			fatalErrorTextField.text = ERROR_TRACE_HEAD + " " + message;
			if (SShellVariables.nativeStage)
			{
				fatalErrorTextField.x = (SShellVariables.nativeStage.stageWidth - fatalErrorTextField.width) / 2;
				fatalErrorTextField.y = (SShellVariables.nativeStage.stageHeight - fatalErrorTextField.height) / 2;
			}
		}

		private static var screenDebugTextField : TextField;

		/**
		 * 屏幕调试信息
		 * @param message
		 *
		 */
		public static function showScreenDebugInfo(message : String) : void
		{
			if (!screenDebugTextField)
			{
				screenDebugTextField = new TextField();
				var textFormat : TextFormat = new TextFormat(SUIStyle.TEXT_FONT, 12, 0xFFFFFF);
				textFormat.align = TextFormatAlign.LEFT;
				screenDebugTextField.defaultTextFormat = textFormat;
				screenDebugTextField.wordWrap = true;
				screenDebugTextField.selectable = false;
				screenDebugTextField.mouseEnabled = false;
				screenDebugTextField.mouseWheelEnabled = false;
				screenDebugTextField.autoSize = TextFieldAutoSize.LEFT;
				screenDebugTextField.filters = [new GlowFilter(0x000000, 1, 2, 2, 4, 2)];
			}
			createDebugContainer();
			if (debugContainer)
			{
				debugContainer.addChild(screenDebugTextField);
				screenDebugTextField.width = SShellVariables.nativeStage.stageWidth;
				screenDebugTextField.height = SShellVariables.nativeStage.stageHeight;
			}
			screenDebugTextField.htmlText = message;
			screenDebugTextField.x = 0;
			screenDebugTextField.y = 0;
		}

		private var log : Array = [];

		private function appendLog(msg : Object) : String
		{
			if (msg is String)
			{
				log.push(msg);
			}
			if (msg is Array)
			{
				while (msg.length > 0)
				{
					log.push(msg.shift());
				}
			}
			return log.join("\n");
		}




		/**
		 * 显示的Debug过滤通道列表，设置为null表示全部可以显示。
		 * 这种方法可以避免铺天盖地的trace造成的困扰。
		 */
		public static var channels : Array;

		/**
		 * 是否处于DEBUG模式。系统可借助此属性来切换调试与非调试模式。
		 * 在非调试模式下，将禁用trace。因为自定义trace编译不会被自动删除，此属性对于提高效率是必须的。
		 */
		public static var DEBUG : Boolean = false;

		/**
		 * 是否处于本地模式
		 */
		public static var LOCAL : Boolean = false;

		/**
		 * 记录日志用。实际运行时，可在程序出错后将客户端日志信息发送出去，做为服务端日志的有效补充。
		 */
		public static var log : String = "";

		/**
		 * 是否激活日志记录
		 */
		public static var enabledLog : Boolean = false;

		/**
		 * 用来显示TRACE信息的TextField
		 */
		public static var debugTextField : TextField;

		/**
		 * 是否激活浏览器控制台trace，信息将会被同时输出到firebug或者Chrome的控制台内。
		 */
		public static var enabledBrowserConsole : Boolean = false;

		/**
		 * 是否显示时间
		 */
		public static var showTime : Boolean = false;

		/**
		 * 出错时，日志发送的地址
		 */
		public static var logUrl : String;

		/**
		 * 出错时，执行的方法
		 */
		public static var errorHandler : Function = defaultErrorHandler;

		/**
		 * 主方法
		 * @param channel	使用的通道，设置为null则表示任何时候都会显示
		 * @return
		 *
		 */
		public static function channelTrace(channel : *, ... rest) : void
		{
			var text : String = getHeader(channel) + (rest as Array).join(",");

			if (enabledLog)
				log += text + "\n";

			if (debugTextField)
				debugTextField.appendText(text + "\n");

			if (enabledBrowserConsole && ExternalInterface.available)
				ExternalInterface.call("console.log", text);

			if (DEBUG && (channels == null || channel == null || channels.indexOf(channel) != -1))
				traceExt(text);
		}

		public static function traceAll(... rest) : void
		{
			channelTrace(null, rest);
		}

		/**
		 * 显示一个对象的属性
		 *
		 * @param channel
		 * @param obj
		 *
		 */
		public static function traceObject(channel : *, obj : Object, ... filters) : void
		{
			channelTrace(channel, "[" + getObjectValues.apply(null, [obj].concat(filters)) + "]");
		}

		/**
		 * 获得对象的值
		 * @param obj
		 * @param filters
		 * @return
		 *
		 */
		public static function getObjectValues(obj : Object, ... filters) : String
		{
			var result : String = getQualifiedClassName(obj);
			var key : *;
			if (filters && filters.length > 0)
			{
				for each (key in filters)
					result += " " + key + "=" + obj[key];
			}
			else
			{
				for (key in obj)
					result += " " + key + "=" + obj[key];
			}
			return result;
		}

		private static function getHeader(channel : *) : String
		{
			var result : String = "";
			if (showTime)
			{
				var date : Date = new Date();
				result = "[" + date.hours + ":" + date.minutes + ":" + date.seconds + ":" + date.milliseconds + "]";
			}
			if (channel)
				result += "[" + channel + "]"

			return result;
		}

		/**
		 * 出错时调用，将会将日志发送至服务器
		 *
		 * @param text 错误信息
		 */
		public static function error(text : String = null) : void
		{
			if (DEBUG && enabledBrowserConsole && ExternalInterface.available)
				ExternalInterface.call("console.error", text);

			if (SDebug.OPEN_THROW_ERROR)
				traceHandler && traceHandler(text, "#FF5B5B");
			errorHandler(text);

			if (logUrl)
			{
				var values : URLVariables = new URLVariables();
				values.log = log;

				var req : URLRequest = new URLRequest(logUrl);
				req.data = values;

				sendToURL(req);

				log = "";
			}
		}

		private static function defaultErrorHandler(text : String) : void
		{
			if (text)
				throw new Error(text);
		}

		/**
		 * 判断是否在网络上
		 * @return
		 *
		 */
		public static function get isNetWork() : Boolean
		{
			return Security.sandboxType == Security.REMOTE;
		}

		/**
		 * 判断是否在浏览器上
		 * @return
		 *
		 */
		public static function get isBrower() : Boolean
		{
			return ExternalInterface.available;
		}

	}
}

function traceExt(... rest) : void
{
	trace(rest);
}