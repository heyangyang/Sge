package com.sunny.game.engine.resource
{

	/**
	 *
	 * <p>
	 * SunnyGame的进度信息数据
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
	public class SProgressInfo
	{
		internal static const PROGRESS : SProgressInfo = new SProgressInfo();

		public var bytesLoaded : int;
		/**
		 * 所有需要下载文件的字节大小
		 */
		private var _bytesTotal : int;

		/**
		* 当前能统计到的所有需要下载文件的字节大小
		*/
		public var bytesTotalCurrent : int;
		/**
		 *  当前所有已经加载的
		 */
		public var bytesTotalLoaded : int;

		public var itemsLoaded : int;
		public var itemsTotal : int;

		public var weightPercent : Number;

		public var url : String;

		public var name : String;

		public var loadingRate : int;

		public function SProgressInfo()
		{
			loadingRate = 0;
		}

		public function get bytesTotal() : int
		{
			return _bytesTotal;
		}

		public function set bytesTotal(value : int) : void
		{
			_bytesTotal = value;
		}
	}
}