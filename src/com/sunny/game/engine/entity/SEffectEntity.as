package com.sunny.game.engine.entity
{
	import com.sunny.game.engine.enum.SEntityType;
	import com.sunny.game.engine.render.SBaseRenderManager;

	/**
	 *
	 * <p>
	 * SunnyGame的特效实体对象
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
	public class SEffectEntity extends SGroundEntity
	{
		public function SEffectEntity(id : int, name : String, render : SBaseRenderManager = null)
		{
			super(id, name, SEntityType.TYPE_EFFECT, render);
			isStatic = true;
		}
	}
}