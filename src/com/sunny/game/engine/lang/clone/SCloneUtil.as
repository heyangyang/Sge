package com.sunny.game.engine.lang.clone
{
	import com.sunny.game.engine.utils.core.SClassFactory;

	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * 克隆对象助手。
	 */
	public class SCloneUtil
	{
		/**
		 * 把srcObj的动态属性赋给dstObj。
		 *
		 * @param	srcObj
		 * @param	dstObj
		 *
		 * @return 返回dstObj。如果如参有一个是null，则返回null
		 */
		public static function copyDynamicObject(srcObj : Object, dstObj : Object) : *
		{
			if (srcObj == null || dstObj == null)
			{
				return null;
			}
			else
			{
				for (var pName : Object in srcObj)
				{
					dstObj[pName] = srcObj[pName];
				}

				return dstObj;
			}
		}

		/**
		 * 浅克隆一个对象。
		 * 如果对象中存储的不是简单数据类型，将直接复制引用。
		 * 如果传入的对象实现了ICloneabl接口，将直接返回ICloneable的clone方法的返回值
		 *
		 * @param srcObj 要进行克隆的对象
		 *
		 * @return 返回结果对象。如果入参是null，则返回null。
		 */
		public static function shallowClone(srcObj : Object) : *
		{
			if (srcObj == null)
			{
				return null;
			}
			else
			{
				if (srcObj is SICloneable)
				{
					return SICloneable(srcObj).clone();
				}
				else
				{
					var object : Object = new Object();

					for (var pName : Object in srcObj)
					{
						if (srcObj[pName] is SICloneable)
						{
							object[pName] = SICloneable(srcObj[pName]).clone();
						}
						else
						{
							object[pName] = srcObj[pName];
						}
					}

					return object;
				}
			}
		}

		/**
		 * 深克隆一个对象，将对传入的对象使用ByteArray做一个完全一样的拷贝，并且对结果对象的操作不会影响到原对象。
		 * 如果传入的对象实现了ICloneabl接口，将直接返回ICloneable的clone方法的返回值。
		 *
		 * @param srcObj 要进行克隆的对象
		 *
		 * @return 返回结果对象。如果入参是null，则返回null。
		 */
		public static function deepClone(srcObj : Object) : *
		{
			if (srcObj == null)
			{
				return null;
			}
			else
			{
				if (srcObj is SICloneable)
				{
					return SICloneable(srcObj).clone();
				}
				else
				{
					var byteArray : ByteArray = new ByteArray();
					byteArray.writeObject(srcObj);
					byteArray.position = 0;
					return byteArray.readObject();
				}
			}
		}

		static public function cloneProperties(source : Object, target : Object = null) : Object
		{
			if (!source)
				return null;
			if (!target)
			{
				var generator : Class = source["constructor"] as Class; //var claseName : String = getQualifiedClassName(this);var cls : Class = getDefinitionByName(claseName) as Class;
				target = new generator();
			}
			var xml : XML = describeType(source);
			var key : String;
			for each (var variable : * in xml.variable)
			{
				key = String(variable.@name);
				if (target.hasOwnProperty(key))
					target[key] = source[key];
			}
			var targetDesc : XML = describeType(target);
			for each (var accessor : * in xml.accessor)
			{
				if (accessor.@access == "writeonly")
					continue;
				key = String(accessor.@name);
				if (target.hasOwnProperty(key))
				{
					if (targetDesc.accessor.(@name == key).@access == "readonly")
						continue;
					target[key] = source[key];
				}
			}
			return target;
		}

		public static function getProperties(source : Object, access : String = "rw") : Dictionary
		{
			var properties : Dictionary = new Dictionary();
			var xml : XML = describeType(source);
			var key : String;
			for each (var variable : * in xml.variable)
			{
				key = String(variable.@name);
				properties[key] = source[key];
			}
			for each (var accessor : * in xml.accessor)
			{
				if (access == "rw")
				{
					if (accessor.@access == "writeonly" || accessor.@access == "readonly")
						continue;
				}
				else if (access == "r")
				{
					if (accessor.@access == "writeonly")
						continue;
				}
				else if (access == "w")
				{
					if (accessor.@access == "readonly")
						continue;
				}
				key = String(accessor.@name);
				properties[key] = source[key];
			}
			return properties;
		}

		/**
		 * 复制显示对象    要复制的对象必须导出链接名才能复制全部子部件
		 * @param   target:DisplayObject   需要复制的显示对象的引用
		 * 			autoAdd:Boolean			是否要在父级显示
		 * @return 	DisplayObject			复制后的可显示对象
		 **/
		public static function duplicateDisplayObject(target : DisplayObject, needTransform : Boolean = false, autoAdd : Boolean = false) : DisplayObject
		{
			if (target == null)
				return null;
			// create duplicate (constructor in quotes to bypass strict mode)
			var targetClass : Class = target["constructor"];
			//			var className : String = String(targetClass) //.toString();
			//			if (className.indexOf("UI") < 0)
			//			{
			//				throw new Error("要复制的对象链接名错误,请为:" + target.name + " 对象添加链接名UI" + target.name);
			//			}

			var duplicate : DisplayObject = new targetClass();

			// duplicate properties
			needTransform && (duplicate.transform = target.transform);
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			duplicate.width = target.width;
			duplicate.height = target.height;

			if (target.scale9Grid)
			{
				var rect : Rectangle = target.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				//			rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}

			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd && target.parent)
			{
				target.parent.addChild(duplicate);
			}

			//duplicate.name = "pp";
			//trace("duplicate.name: " + duplicate.name)

			//不需要复制源对象的坐标属性 
			duplicate.x = 0;
			duplicate.y = 0;
			return duplicate;
		}

		/**
		 * 复制该对象
		 * 当资源为NULL时会返回自身对象
		 * @return ComponentSkin
		 */
		public static function cloneObject(object : Object, params : Array = null) : Object
		{
			if (object == null)
			{
				trace('ui_warning: the duplicating skin is null, the close operator will return it self!');
				return object;
			}
			var generator : Class = object["constructor"] as Class;

			var instance : Object = SClassFactory.apply(generator, params);

			var xml : XML = describeType(object);
			var property : String;
			for each (var variable : * in xml.variable)
			{
				property = String(variable.@name);
				if (object[property] is SICloneable)
					instance[property] = (object[property] as SICloneable).clone();
				else
					instance[property] = object[property];
			}
			//动态属性 
			for (property in object)
			{
				instance[property] = object[property];
			}
			return instance;
		}

		//		public function clone():*
		//		{
		//			var clase : Class = this['constructor'] as Class;
		//			var claseName : String = getQualifiedClassName(this);
		//			registerClassAlias(claseName , clase);
		//			var byteArray : ByteArray = new ByteArray();
		//			byteArray.writeObject(this);
		//			
		//			byteArray.position = 0;
		//			var componetSkin : ComponentSkin = byteArray.readObject();
		//			return componetSkin;
		//		}

		/**
		 * 克隆一个数据对象
		 */
		public static function clone(data : Object) : Object
		{
			if (!data)
				return null;
			var bytes : ByteArray = new ByteArray();
			bytes.writeObject(data);
			bytes.position = 0;
			return bytes.readObject();
		}
	}
}