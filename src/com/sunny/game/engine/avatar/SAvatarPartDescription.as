package com.sunny.game.engine.avatar
{
	import com.sunny.game.engine.animation.SAnimationCollectionDescription;

	/**
	 *
	 * <p>
	 * SunnyGame的纸娃娃部件描述
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
	public class SAvatarPartDescription extends SAnimationCollectionDescription
	{
		/**
		 * 部件的类型，对应SAvatarPartType
		 */
		public var type : uint;
		public var kind : uint;

		public function SAvatarPartDescription()
		{
			super();
		}
	}
}