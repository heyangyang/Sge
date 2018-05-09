package com.sunny.game.engine.core
{
	import com.sunny.game.engine.component.SIComponent;
	import com.sunny.game.engine.entity.SIEntity;

	/**
	 *
	 * <p>
	 * SunnyGame的一个组件基类
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
	public class SComponent extends SObject implements SIComponent
	{
		protected var _owner : SIEntity;
		protected var _type : *;
		protected var _enabled : Boolean;

		private var _additionIndex : int;

		protected var _isDisposed : Boolean;

		public function SComponent(type : *)
		{
			_type = type;
			_isDisposed = false;
			_enabled = true;
		}

		/**
		 * 当为false时将禁用对象的操作
		 */
		public function get enabled() : Boolean
		{
			return _enabled;
		}

		/**
		 * @private
		 */
		public function set enabled(value : Boolean) : void
		{
			_enabled = value;
		}

		public function notifyAdded() : void
		{
		}

		public function notifyRemoved() : void
		{
		}

		public function notifyReset() : void
		{
		}

		public function get owner() : SIEntity
		{
			return _owner;
		}

		public function get type() : *
		{
			return _type;
		}

		public function set owner(value : SIEntity) : void
		{
			_owner = value;
		}

		public function get additionIndex() : int
		{
			return _additionIndex;
		}

		public function set additionIndex(value : int) : void
		{
			_additionIndex = value;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_owner)
				_owner.removeComponent(this);
			_owner = null;
			_type = null;
			_isDisposed = true;
			_enabled = false;
		}
	}
}
