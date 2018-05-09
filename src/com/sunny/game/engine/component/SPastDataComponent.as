package com.sunny.game.engine.component
{
	import com.sunny.game.engine.data.SPastData;
	import com.sunny.game.engine.entity.SRenderableEntity;
	import com.sunny.game.engine.events.SEvent;

	/**
	 *
	 * <p>
	 * SunnyGame的一个过去数据组件
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
	public class SPastDataComponent extends SUpdatableComponent
	{
		public static const EVENT_ENTITY_POSITION_CHANGE : String = "EVENT_ENTITY_POSITION_CHANGE";

		private var _entity : SRenderableEntity;
		private var _pastData : SPastData;
		private var _needSync : Boolean;

		public function SPastDataComponent()
		{
			super(SPastDataComponent);
		}

		override public function notifyAdded() : void
		{
			super.notifyAdded();
			_pastData = new SPastData();
			_entity = owner as SRenderableEntity;
			_pastData.entity = _entity;
			_pastData.id = _entity.id;
			updateData();
		}

		private function updateData() : void
		{
			_pastData.dir = _entity.direction;
			_pastData.mapX = _entity.mapX;
			_pastData.mapY = _entity.mapY;
			_pastData.gridX = _entity.gridX;
			_pastData.gridY = _entity.gridY;
		}

		override public function update() : void
		{
			if (_entity == null)
				return;
			if (_needSync)
			{
				if (_pastData.gridX != _entity.gridX || _pastData.gridY != _entity.gridY)
					SEvent.dispatchEvent(EVENT_ENTITY_POSITION_CHANGE, _pastData);
			}
			updateData();
		}

		override public function destroy() : void
		{
			super.destroy();
			_entity = null;
			if (_pastData)
				_pastData.destroy();
			_pastData = null;
		}

		public function get pastData() : SPastData
		{
			return _pastData;
		}

		public function set needSync(value : Boolean) : void
		{
			_needSync = value;
		}
	}
}