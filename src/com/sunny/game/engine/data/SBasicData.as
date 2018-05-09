package com.sunny.game.engine.data
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.lang.clone.SCloneUtil;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.utils.SByteArray;
	
	import flash.utils.describeType;
	
	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个基础数据
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
	public class SBasicData extends SObject implements SIDestroy
	{
		protected var _id : int = 0;

		/**
		 * 名称
		 */
		public var name : String = "";

		protected var _isDisposed : Boolean;

		public function SBasicData()
		{
			super();
			_id = 0;
			name = "";
			_isDisposed = false;
			//registerClassAlias('SBasicData', SBasicData);
		}

		public function init() : void
		{
		}

		public function readFrom(byteArray : SByteArray) : void
		{
			var xml : XML = describeType(this);
			for each (var variable : * in xml.variable)
			{
				var property : String = String(variable.@name);
				var value : * = this[property];
				if (this[property] is int)
					this[property] = byteArray.readInt();
				else if (this[property] is Number)
					this[property] = byteArray.readLong();
				else if (this[property] is Boolean)
					this[property] = byteArray.readBoolean();
				else
					this[property] = byteArray.readUTF();
			}
		}

		public function writeTo(byteArray : SByteArray) : void
		{
			var xml : XML = describeType(this);
			for each (var variable : * in xml.variable)
			{
				var property : String = String(variable.@name);
				var value : * = this[property];
				if (this[property] is int)
					byteArray.writeInt(int(value));
				else if (this[property] is Number)
					byteArray.writeLong(Number(value));
				else if (this[property] is Boolean)
					byteArray.writeBoolean(Boolean(value));
				else
					byteArray.writeUTF(String(value));
			}
		}

		public function readProperty(property : String, value : *) : void
		{
			if (property == "")
				return;
			var clientField : String = "client_";
			var clientFieldIndex : int = property.indexOf(clientField);
			if (clientFieldIndex != -1)
				property = property.substring(clientField.length);
			if (this.hasOwnProperty(property))
			{
				if (this[property] is int)
					this[property] = int(value);
				else if (this[property] is Number)
					this[property] = Number(value);
				else if (this[property] is Boolean)
					this[property] = Boolean(int(value));
				else if (this[property] is Vector.<int>)
					(this[property] as Vector.<int>).push(int(value));
				else if (this[property] is Vector.<String>)
					(this[property] as Vector.<String>).push(String(value));
				else if (this[property] is Array)
					(this[property] as Array).push(String(value));
				else
					this[property] = String(value);
			}
		}

		/**
		 * 混淆后会出问题，尽量用cloneTo()
		 * @return
		 *
		 */
		public function clone() : SBasicData
		{
			return SCloneUtil.cloneProperties(this) as SBasicData;
		}

		/**
		 * 克隆到类型数据
		 * @param cls 当前对象的类型或父类类型
		 * @return
		 *
		 */
		public function cloneTo(targer : *) : SBasicData
		{
			var obj : SBasicData;
			if (targer is Class)
				obj = new targer();
			else
				obj = targer;
			var xml : XML = describeType(this);
			var key : String;
			for each (var variable : * in xml.variable)
			{
				key = String(variable.@name);
				if (obj.hasOwnProperty(key))
					obj[key] = this[key];
			}
			for each (var accessor : * in xml.accessor)
			{
				if (accessor.@access == "readonly" || accessor.@access == "writeonly")
					continue;
				key = String(accessor.@name);
				if (obj.hasOwnProperty(key))
					obj[key] = this[key];
			}
			return obj;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			_isDisposed = true;
		}

		public function get id() : int
		{
			return _id;
		}

		public function set id(value : int) : void
		{
			_id = value;
		}

		/**
		 * 将两个SBasicData运算得出新的SBasicData
		 * @param operation addition="+",subduction="-"
		 * @param values
		 * @return 运算后的SBasicData
		 *
		 */
		public static function arithmetic(operation : String, ... values) : SBasicData
		{
			if (values && values.length > 0)
			{
				var value : SBasicData = null;
				for each (value in values)
				{
					if (value)
						break;
				}
				if (value)
				{
					var propertyXml : XML = describeType(value);
					var cls : Class = value.getClass();
					var temp : SBasicData = new cls();
					var key : String;
					for each (var variable : * in propertyXml.variable)
					{
						key = String(variable.@name);
						if (temp[key] is int || temp[key] is Number)
						{
							if (operation == "+")
							{
								temp[key] = 0;
								for each (value in values)
								{
									if (value)
										temp[key] += value[key];
								}
							}
							else if (operation == "-")
							{
								temp[key] = value[key];
								for each (value in values)
								{
									if (value)
										temp[key] -= value[key];
								}
							}
						}
					}
					for each (var accessor : * in propertyXml.accessor)
					{
						if (accessor.@access == "readonly" || accessor.@access == "writeonly")
							continue;
						key = String(accessor.@name);
						if (temp[key] is int || temp[key] is Number)
						{
							if (operation == "+")
							{
								temp[key] = 0;
								for each (value in values)
								{
									if (value)
										temp[key] += value[key];
								}
							}
							else if (operation == "-")
							{
								temp[key] = value[key];
								for each (value in values)
								{
									if (value)
										temp[key] -= value[key];
								}
							}
						}
					}
					return temp;
				}
			}
			return null;
		}
	}
}