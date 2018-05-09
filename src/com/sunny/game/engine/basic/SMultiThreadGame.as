package com.sunny.game.engine.basic
{
	import com.sunny.game.engine.core.SMainThreadNotify;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.lang.thread.SMainThread;

	import flash.utils.ByteArray;

	/**
	 *
	 * <p>
	 * SunnyGame的一个2D多线程游戏基类
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
	public class SMultiThreadGame extends SMainThread
	{
		public function SMultiThreadGame(backBytes : ByteArray, notify : SMainThreadNotify = null)
		{
			super(notify);
			try
			{
				SShellVariables.isMultiThread = true;
				initWorker(backBytes);
			}
			catch (e : Error)
			{
				SShellVariables.isMultiThread = false;
				throw new Error("主线程启动出错!" + e.getStackTrace());
			}
		}
	}
}