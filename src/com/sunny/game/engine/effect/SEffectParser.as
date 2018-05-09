package com.sunny.game.engine.effect
{
	import com.sunny.game.engine.animation.SAnimationManager;

	/**
	 *
	 * <p>
	 * SunnyGame的特效解析器
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
	public class SEffectParser
	{
		public function SEffectParser()
		{
		}

		/**
		 * 解析Parser 特效信息
		 * @param xml
		 * @return
		 *
		 */
		public function parseEffectDescription(xml : XML, version : String = null) : SEffectDescription
		{
			if (!xml)
			{
				return null;
			}

			var effectDesc : SEffectDescription = new SEffectDescription();
			effectDesc.id = String(xml.@name).toLowerCase();
			effectDesc.version = String(xml.@version);

			effectDesc.width = int(xml.@width);
			effectDesc.height = int(xml.@height);
			effectDesc.leftBorder = int(xml.@leftBorder);
			effectDesc.topBorder = int(xml.@topBorder);
			effectDesc.rightBorder = int(xml.@rightBorder);
			effectDesc.bottomBorder = int(xml.@bottomBorder);
			effectDesc.setDirections(String(xml.@directions));

			var animations : XML = <animations></animations>;
			animations.appendChild(xml.animation);

			//添加动画描述
			SAnimationManager.getInstance().addBatchAnimationDescription(animations, effectDesc.width, effectDesc.height, version);

			return effectDesc;
		}
	}
}