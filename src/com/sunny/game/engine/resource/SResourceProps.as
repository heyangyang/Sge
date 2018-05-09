package com.sunny.game.engine.resource
{
	import com.sunny.game.engine.core.SObject;

	/**
	 *
	 * <p>
	 * SunnyGame的BulkLoader相关设置
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
	internal dynamic class SResourceProps extends SObject
	{
		/**
		 * 下载统计的权重，详见BulkLoader的
		 */
		public var weight : int;

		/**
		 * 最大尝试下载次数
		 */
		public var maxTries : uint;

		/**
		 * 下载到的资源
		 */
		public var context : *;

		/**
		 * 资源下载优先级
		 */
		public var priority : int;

		/**
		 * 资源id
		 */
		public var id : String;

		/**
		 * 资源的类型
		 */
		public var type : String;
		
		public function SResourceProps()
		{
			super();
		}
	}
}