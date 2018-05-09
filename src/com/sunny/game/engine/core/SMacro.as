package com.sunny.game.engine.core
{
	import com.sunny.game.engine.ns.sunny_engine;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个宏类
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
	dynamic public class SMacro extends Proxy
	{
		private var _dictionary : Dictionary;

		public function SMacro()
		{
			super();
			_dictionary = new Dictionary(true);
		}

		flash_proxy override function callProperty(methodName : *, ... args) : *
		{
			var metrod : * = _dictionary[methodName];
			(metrod as Function).apply(null, args);
		}

		flash_proxy override function getProperty(property : *) : *
		{
			return _dictionary[property];
		}

		flash_proxy override function setProperty(property : *, value : *) : void
		{
			_dictionary[property] = value;
		}

		flash_proxy override function deleteProperty(property : *) : Boolean
		{
			return delete(_dictionary[property]);
		}

		public function readFrom(bytes : ByteArray) : void
		{
			while (bytes.bytesAvailable > 0)
			{
				var key : String = bytes.readUTF();
				var valueType : int = bytes.readByte();
				if (valueType == 1)
				{
					this[key] = bytes.readInt();
				}
				else if (valueType == 2)
				{
					this[key] = bytes.readBoolean();
				}
				else if (valueType == 3)
				{
					this[key] = bytes.readUTF();
				}
				else if (valueType == 4)
				{
					this[key] = bytes.readDouble();
				}
				else if (valueType == 5)
				{
					var rb : ByteArray = new ByteArray();
					bytes.readBytes(rb);
					this[key] = rb;
				}
			}
		}

		public function writeTo(bytes : ByteArray) : void
		{
			for (var key : String in _dictionary)
			{
				var value : Object = _dictionary[key];
				if (value is int)
				{
					bytes.writeUTF(key);
					bytes.writeByte(1);
					bytes.writeInt(value as int);
				}
				else if (value is Boolean)
				{
					bytes.writeUTF(key);
					bytes.writeByte(2);
					bytes.writeBoolean(value as Boolean);
				}
				else if (value is String)
				{
					bytes.writeUTF(key);
					bytes.writeByte(3);
					bytes.writeUTF(value as String);
				}
				else if (value is Number)
				{
					bytes.writeUTF(key);
					bytes.writeByte(4);
					bytes.writeDouble(value as Number);
				}
				else if (value is ByteArray)
				{
					bytes.writeUTF(key);
					bytes.writeByte(5);
					bytes.writeBytes(value as ByteArray);
				}
			}
		}

		public function setMacro(property : String, value : Object) : void
		{
			this[property] = value;
			if (value == null)
				delete this[property];
		}

		public function getMacro(property : String) : Object
		{
			return this[property];
		}

		sunny_engine function get dictionary() : Dictionary
		{
			return _dictionary;
		}
	}
}