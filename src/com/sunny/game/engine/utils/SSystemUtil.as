package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.lang.errors.SAbstractClassError;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;

	/**
	 *
	 * <p>
	 * SunnyGame的一个与当前平台和运行时的相关方法的实用类。
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
	public class SSystemUtil
	{
		private static var sInitialized : Boolean = false;
		private static var sApplicationActive : Boolean = true;
		private static var sWaitingCalls : Array = [];
		private static var sPlatform : String;
		private static var sAIR : Boolean;

		/** @private */
		public function SSystemUtil()
		{
			throw new SAbstractClassError();
		}

		/** Initializes the <code>ACTIVATE/DEACTIVATE</code> event handlers on the native
		 *  application. This method is automatically called by the Starling constructor. */
		public static function initialize() : void
		{
			if (sInitialized)
				return;

			sInitialized = true;
			sPlatform = Capabilities.version.substr(0, 3);

			try
			{
				var nativeAppClass : Object = getDefinitionByName("flash.desktop::NativeApplication");
				var nativeApp : EventDispatcher = nativeAppClass["nativeApplication"] as EventDispatcher;

				nativeApp.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);
				nativeApp.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);

				sAIR = true;
			}
			catch (e : Error)
			{
				sAIR = false;
			}
		}

		private static function onActivate(event : Object) : void
		{
			sApplicationActive = true;

			for each (var call : Array in sWaitingCalls)
				call[0].apply(null, call[1]);

			sWaitingCalls = [];
		}

		private static function onDeactivate(event : Object) : void
		{
			sApplicationActive = false;
		}

		/** Executes the given function with its arguments the next time the application is active.
		 *  (If it <em>is</em> active already, the call will be executed right away.) */
		public static function executeWhenApplicationIsActive(call : Function, ... args) : void
		{
			initialize();

			if (sApplicationActive)
				call.apply(null, args);
			else
				sWaitingCalls.push([call, args]);
		}

		/** Indicates if the application is currently active. On Desktop, this means that it has
		 *  the focus; on mobile, that it is in the foreground. In the Flash Plugin, always
		 *  returns true. */
		public static function get isApplicationActive() : Boolean
		{
			initialize();
			return sApplicationActive;
		}

		/** Indicates if the code is executed in an Adobe AIR runtime (true)
		 *  or Flash plugin/projector (false). */
		public static function get isAIR() : Boolean
		{
			initialize();
			return sAIR;
		}

		/** Indicates if the code is executed on a Desktop computer with Windows, OS X or Linux
		 *  operating system. If the method returns 'false', it's probably a mobile device
		 *  or a Smart TV. */
		public static function get isDesktop() : Boolean
		{
			initialize();
			return /(WIN|MAC|LNX)/.exec(sPlatform) != null;
		}

		/** Returns the three-letter platform string of the current system. These are
		 *  the most common platforms: <code>WIN, MAC, LNX, IOS, AND, QNX</code>. Except for the
		 *  last one, which indicates "Blackberry", all should be self-explanatory. */
		public static function get platform() : String
		{
			initialize();
			return sPlatform;
		}
	}
}