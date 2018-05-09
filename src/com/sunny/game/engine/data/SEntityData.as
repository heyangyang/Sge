package com.sunny.game.engine.data
{
	import com.sunny.game.engine.utils.SByteArray;

	/**
	 *
	 * <p>
	 * SunnyGame的一个实体数据
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
	public class SEntityData extends SBasicData
	{
		protected var _gridX : int;
		protected var _gridY : int;

		protected var _offsetX : int;
		protected var _offsetY : int;

		public function SEntityData()
		{
			_offsetX = 0;
			_offsetY = 0;
		}

		override public function readFrom(byteArray : SByteArray) : void
		{
			super.readFrom(byteArray);
			_gridX = byteArray.readUnsignedShort();
			_gridY = byteArray.readUnsignedShort();
		}

		override public function writeTo(byteArray : SByteArray) : void
		{
			super.writeTo(byteArray);
			byteArray.writeShort(_gridX);
			byteArray.writeShort(_gridY);
		}

		public function get gridX() : int
		{
			return _gridX;
		}

		public function set gridX(value : int) : void
		{
			_gridX = value;
		}

		public function get gridY() : int
		{
			return _gridY;
		}

		public function set gridY(value : int) : void
		{
			_gridY = value;
		}

		public function get offsetX() : int
		{
			return _offsetX;
		}

		public function set offsetX(value : int) : void
		{
			_offsetX = value;
		}

		public function get offsetY() : int
		{
			return _offsetY;
		}

		public function set offsetY(value : int) : void
		{
			_offsetY = value;
		}
	}
}