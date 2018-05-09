package com.sunny.game.engine.avatar
{
	import com.sunny.game.engine.animation.SAnimationManager;

	/**
	 *
	 * <p>
	 * SunnyGame的纸娃娃解析器
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
	public class SAvatarParser
	{
		public function SAvatarParser()
		{
		}

		/**
		 * 解析Parser 人物信息
		 * @param xml
		 * @return
		 *
		 */
		public function parseAvatarDescription(xml : XML, version : String = null) : SAvatarDescription
		{
			if (!xml)
				return null;

			var avatarDesc : SAvatarDescription = new SAvatarDescription();
			avatarDesc.name = String(xml.@name).toLowerCase();
			avatarDesc.version = String(xml.@version);
			avatarDesc.partOrder = [];

			var partOrder : Array = String(xml.@partOrder).split(',');
			for each (var partType : String in partOrder)
			{
				avatarDesc.partOrder.push(int(partType));
			}

			avatarDesc.width = int(xml.@width);
			avatarDesc.height = int(xml.@height);
			avatarDesc.leftBorder = int(xml.@leftBorder);
			avatarDesc.topBorder = int(xml.@topBorder);
			avatarDesc.rightBorder = int(xml.@rightBorder);
			avatarDesc.bottomBorder = int(xml.@bottomBorder);
			avatarDesc.setDirections(String(xml.@directions));

			var xmlList : XMLList = xml.action;
			var len : int = xmlList.length();
			var actionXML : XML;
			for (var i : int = 0; i < len; i++)
			{
				actionXML = xmlList[i];
				avatarDesc.addActionDesc(actionXML);
			}

			var animations : XML = <animations></animations>;
			var animationList : XMLList = xml.action.part.animation;
			animations.appendChild(animationList);
			//添加动画描述
			SAnimationManager.getInstance().addBatchAnimationDescription(animations, avatarDesc.width, avatarDesc.height, version);
			return avatarDesc;
		}
	}
}