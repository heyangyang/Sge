package com.sunny.game.engine.core
{
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个可更新接口
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
	public interface SIUpdatable extends SIDestroy
	{
		function update() : void;

		/**
		 * 帧频 ，设定该值将修改frameTimes值
		 * @param value
		 */
		function set frameRate(value : Number) : void;
		function get frameRate() : Number;
		/**
		 * 每帧帧间隔 ,设定改值不会修改frameRate值，但frameRate值 将失效
		 * @param value
		 */
		function set frameTimes(value : int) : void;
		function get frameTimes() : int;

		/**
		 * 优先级
		 * @return
		 */
		function get priority() : int;
		function set priority(value : int) : void;

		function notifyRegistered() : void;
		function notifyUnregistered() : void;
		/**
		 * 是否已经在主驱动器中注册
		 * @return
		 */
		function get isRegistered() : Boolean;

		function checkUpdatable() : Boolean;
		function get numUpdatable() : uint;
		function unregister() : void;
		/**
		 * 是否暂停
		 * @param v
		 *
		 */
		function set paused(value : Boolean) : void
		function get paused() : Boolean;
		function get enabled() : Boolean;
		function set enabled(value : Boolean) : void;
	}
}