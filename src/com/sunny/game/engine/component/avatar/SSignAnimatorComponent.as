package com.sunny.game.engine.component.avatar
{
	import com.sunny.game.engine.component.animation.SAnimatorComponent;
	import com.sunny.game.engine.data.SRoleData;
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.render.interfaces.SIRenderData;
	import com.sunny.game.rpg.component.render.SNameParser;

	import flash.text.TextField;

	/**
	 *
	 * <p>
	 * SunnyGame的一个带标记的带动画行为组件
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
	public class SSignAnimatorComponent extends SAnimatorComponent
	{
		private static var tf : TextField;
		public var alwaysShowName : Boolean = false;
		protected var _nameRender : SIRenderData;
		protected var _nameSource : SNameParser;
		protected var _nameTextColor : uint = 0xffffff;
		protected var _nameTextFontSize : int = 14;
		protected var _nameTextNeedFilter : Boolean = true;
		protected var _nameVisible : Boolean;

		public function SSignAnimatorComponent()
		{
			super();
		}

		protected function set nameSource(value : SNameParser) : void
		{
			if (_nameSource)
				_nameSource.release();
			_nameSource = value;
		}

		override public function update() : void
		{
			super.update();
			if (_entity && _entity.isInScreen)
			{
				updateNameRender(_entity.screenX, _entity.screenY);
			}
		}

		/**
		 * 如果名字已经显示，则更新名字渲染的属性
		 * @param elapsedTime
		 * @param bufferX
		 * @param bufferY
		 *
		 */
		protected function updateNameRender(bufferX : Number, bufferY : Number) : void
		{
			showName();
			_entity.displayHeight = _entity.height + _entity.mapZ;
			if (_nameVisible && _nameRender && _nameSource)
			{
				_nameRender.x = bufferX - _nameSource.width * 0.5;
				_nameRender.y = bufferY - _entity.height - _nameSource.height - 4;
				if (_renderUseCenterY)
					_nameRender.y = _nameRender.y + _entity.centerOffsetY - _entity.centerOffsetZ;
				if (_renderUseMapZ)
					_nameRender.y = _nameRender.y - _entity.mapZ;
				_nameRender.depth = _entity.depth;
				_nameRender.layer = _entity.layer + 10;
				_entity.displayHeight = bufferY - _nameRender.y - _entity.mapZ;
			}
		}

		public function showName() : void
		{
			if (alwaysShowName)
			{
				if (_entity == null || !_entity.name)
					return;
				if (_nameVisible)
					return;
				if (_nameRender == null)
					_nameRender = new(_renderDataClass)();
				updateName();
				_nameRender.name = 'render_' + _entity.name;
				addRender(_nameRender);
				_nameVisible = true;
			}
		}

		public function updateName() : void
		{
			nameSource = getNameSource(_entity.name);
			if (_nameRender)
				_nameRender.bitmapData = _nameSource.bmd;
		}

		private function getNameSource(name : String) : SNameParser
		{
			var level : int;
			if (owner.data is SRoleData)
			{
				level = (owner.data as SRoleData).vipYellowLevel;
				if ((owner.data as SRoleData).isYellowYearVip)
					level = 10;
			}
			return SReferenceManager.getInstance().createRoleName(name, name, level, _nameTextFontSize, _nameTextColor);
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_nameRender)
			{
				removeRender(_nameRender);
				_nameRender.dispose();
				_nameRender = null;
			}
			nameSource = null;
			super.destroy();
		}
	}
}