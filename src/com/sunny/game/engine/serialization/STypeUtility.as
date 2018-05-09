package com.sunny.game.engine.serialization
{
	import com.sunny.game.engine.debug.SDebug;

	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * <p>
	 * SunnyGame的一个序列化类型辅助类处理类型introspection and reflection.
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
	public class STypeUtility
	{
		/**
		 * 注册一个函数将被调用时需要指定类型实例化。该函数返回指定类型的实例。
		 *
		 * @param typeName 指定的函数处理名字
		 * @param instantiator 实例化函数指定类型
		 */
		public static function registerInstantiator(typeName : String, instantiator : Function) : void
		{
			if (_instantiators[typeName])
			{
				SDebug.warningPrint(typeName, "类型" + typeName + "已经被注册，当前操作将替换旧的处理方法！");
			}
			_instantiators[typeName] = instantiator;
		}

		/**
		 * 返回类型的完全限定名
		 *
		 * @param object 对象的类型是被检索(retrieved)的对象。
		 * @return 指定的对象类型的名称。
		 */
		public static function getObjectClassName(object : *) : String
		{
			return flash.utils.getQualifiedClassName(object);
		}

		/**
		 * 返回给定类名称的类的对象。
		 * @param className 类的完全限定名称
		 * @return 指定类的类的对象，null则不存在。
		 */
		public static function getClassFromName(className : String) : Class
		{
			return getDefinitionByName(className) as Class;
		}

		public static function getClass(item : *) : Class
		{
			if (item is Class || item == null)
				return item;

			return Object(item).constructor;
		}

		/**
		 * 根据名字创建类型实例
		 * @param className 实例化的类名字
		 * @return 返回该类的一个实例，如果实例失败则为null。
		 */
		public static function instantiate(className : String, suppressError : Boolean = false) : *
		{
			// Deal with strings explicitly as they are a primitive.
			if (className == "String")
				return "";

			// Class is also a primitive type.
			if (className == "Class")
				return Class;

			// Check for overrides.
			if (_instantiators[className])
				return _instantiators[className]();

			// Give it a shot!
			try
			{

				return new (getDefinitionByName(className));
			}
			catch (e : Error)
			{
				if (!suppressError)
				{
					// if we can not get the definition, it might reside in another swf
					// so lets see if we can get the class from the _classes dictionary.
					var thisClass : Class = _classes[className];
					if (thisClass != null)
						return new thisClass();

//                    Logger.warn(null, "Instantiate", "Failed to instantiate " + className + " due to " + e.toString());
//                    Logger.warn(null, "Instantiate", "Is " + className + " included in your SWF? Make sure you call PBE.registerType(" + className + "); somewhere in your project.");				 
				}
			}

			// If we get here, couldn't new it.
			return null;
		}

		/**
		 * Gets the type of a field as a string for a specific field on an object.
		 *
		 * @param object The object on which the field exists.
		 * @param field The name of the field whose type is being looked up.
		 *
		 * @return The fully qualified name of the type of the specified field, or
		 * null if the field wasn't found.
		 */
		public static function getFieldType(object : *, field : String) : String
		{
			var typeXML : XML = getTypeDescription(object);

			// Look for a matching accessor.
			for each (var property : XML in typeXML.child("accessor"))
			{
				if (property.attribute("name") == field)
					return property.attribute("type");
			}

			// Look for a matching variable.
			for each (var variable : XML in typeXML.child("variable"))
			{
				if (variable.attribute("name") == field)
					return variable.attribute("type");
			}

			return null;
		}

		/**
		 * Determines if an object is an instance of a dynamic class.
		 *
		 * @param object The object to check.
		 *
		 * @return True if the object is dynamic, false otherwise.
		 */
		public static function isDynamic(object : *) : Boolean
		{
			if (object is Class)
			{
				//Logger.error(object, "isDynamic", "The object is a Class type, which is always dynamic");
				return true;
			}

			var typeXml : XML = getTypeDescription(object);
			return typeXml.@isDynamic == "true";
		}

		/**
		 * Get the xml for the metadata of the field.
		 * Determine the type, specified by metadata, for a container class like an Array.
		 */
		public static function getMetadata(object : *, field : String, metadataName : String) : String
		{
			var description : XML = getTypeDescription(object);
			if (!description)
				return null;

			for each (var variable : XML in description.*)
			{
				// Skip if it's not the field we want.
				if (variable.@name != field)
					continue;

				// Only check variables/accessors.
				if (variable.name() != "variable" && variable.name() != "accessor")
					continue;

				// Scan for TypeHint metadata.
				for each (var metadataXML : XML in variable.*)
				{
					if (metadataXML.@name == metadataName)
					{
						var value : String = metadataXML.arg.@value.toString();

						return value;
						/*
						if (value == "dynamic")
						{
							if (!isNaN(object[field]))
							{
								// Is a number...
								return getQualifiedClassName(1.0);
							}
							else
							{
								return getQualifiedClassName(object[field]);
							}
						}
						else
						{
							return value;
						}
						*/
					}
				}
			}
			return null;
		}

		/**
		 * Get the xml for the metadata of the field.
		 */
		public static function getMetadataXML(object : *, field : String, metadataName : String) : XML
		{
			var description : XML = getTypeDescription(object);
			if (!description)
				return null;

			for each (var variable : XML in description.*)
			{
				// Skip if it's not the field we want.
				if (variable.@name != field)
					continue;

				// Only check variables/accessors.
				if (variable.name() != "variable" && variable.name() != "accessor")
					continue;

				// Scan for EditorData metadata.
				for each (var metadataXML : XML in variable.*)
				{
					if (metadataXML.@name == metadataName)
						return metadataXML;
				}
			}
			return null;
		}

		/**
		 * Gets the xml description of an object's type through a call to the
		 * flash.utils.describeType method. Results are cached, so only the first
		 * call will impact performance.
		 *
		 * @param object The object to describe.
		 *
		 * @return The xml description of the object.
		 */
		public static function getTypeDescription(object : *) : XML
		{
			var className : String = getObjectClassName(object);
			if (!_typeDescriptions[className])
				_typeDescriptions[className] = describeType(object);

			return _typeDescriptions[className];
		}

		/**
		 * Gets the xml description of a class through a call to the
		 * flash.utils.describeType method. Results are cached, so only the first
		 * call will impact performance.
		 *
		 * @param className The name of the class to describe.
		 *
		 * @return The xml description of the class.
		 */
		public static function getClassDescription(className : String) : XML
		{
			if (!_typeDescriptions[className])
			{
				try
				{
					_typeDescriptions[className] = describeType(getDefinitionByName(className));
				}
				catch (error : Error)
				{
					return null;
				}
			}

			return _typeDescriptions[className];
		}

		public static function addClass(className : String, classObject : Class) : void
		{
			_classes[className] = classObject;
		}

		private static var _classes : Dictionary = new Dictionary();
		private static var _typeDescriptions : Dictionary = new Dictionary();
		private static var _instantiators : Dictionary = new Dictionary();
	}
}
