package com.sunny.game.engine.core
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * <p>
	 * SunnyGame的一个全局注入管理器，在项目中可以通过此类向框架内部注入指定的类，从而定制或者扩展部分模块的功能。<p/>
	 * 以下类若有调用，需要显式注入：<br>
	 * IBitmapDecoder:DXR位图动画所用的解码器实例<br>
	 * IBitmapEncoder:DXR位图动画所用的编码器实例<br>
	 * ISkinAdapter:皮肤解析适配器实例。<br>
	 * Theme:皮肤默认主题。<br>
	 * IResolover:资源管理器调用的文件解析类实例。
	 *
	 * l  映射

n  值

n  类(针对每一次注入都会创建新的实例)

n  单例(第一次注入创建，然后每次注入时都复用第一次创建的对象)

n  规则(允许在多个映射规则之间共享单例)

l  创建子注入器(injector),从而继承父注入器的映射关系，同时可以定义额外的映射关系或者重写父注入器的映射关系

l  通过Injector的hasMapping方法来查询已有的注入规则

l  通过使用Injector的getInstance方法直接应用注入规则


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
	public class SInjector
	{
		/**
		 * 储存类的映射规则
		 */
		private static var mapClassDic : Dictionary = new Dictionary;

		/**
		 * 以类定义为值进行映射注入，只有第一次请求它的单例时才会被实例化。
		 * @param whenAskedFor 传递类定义或类完全限定名作为需要映射的键。
		 * @param instantiateClass 传递类作为需要映射的值，它的构造函数必须为空。若不为空，请使用Injector.mapValue()方法直接注入实例。
		 * @param named 可选参数，在同一个类作为键需要映射多条规则时，可以传入此参数区分不同的映射。在调用getInstance()方法时要传入同样的参数。
		 */
		public static function mapClass(requestor : Object, generator : Class, name : String = "") : void
		{
			var requestName : String = getKey(requestor) + "#" + name;
			mapClassDic[requestName] = generator;
		}

		/**
		 * 获取完全限定类名
		 */
		private static function getKey(hostComponentKey : Object) : String
		{
			if (hostComponentKey is String)
				return hostComponentKey as String;
			return getQualifiedClassName(hostComponentKey);
		}

		private static var mapValueDic : Dictionary = new Dictionary;

		/**
		 * 以实例为值进行映射注入,当请求单例时始终返回注入的这个实例。
		 * @param whenAskedFor 传递类定义或类的完全限定名作为需要映射的键。
		 * @param useValue 传递对象实例作为需要映射的值。
		 * @param named 可选参数，在同一个类作为键需要映射多条规则时，可以传入此参数区分不同的映射。在调用getInstance()方法时要传入同样的参数。
		 */
		public static function mapObject(requestor : Object, instance : Object, name : String = "") : void
		{
			var requestName : String = getKey(requestor) + "#" + name;
			mapValueDic[requestName] = instance;
		}

		/**
		 * 检查指定的映射规则是否存在
		 * @param whenAskedFor 传递类定义或类的完全限定名作为需要映射的键。
		 * @param named 可选参数，在同一个类作为键需要映射多条规则时，可以传入此参数区分不同的映射。
		 */
		public static function hasMapping(requestor : Object, name : String = "") : Boolean
		{
			var requestName : String = getKey(requestor) + "#" + name;
			if (mapValueDic[requestName] || mapClassDic[requestName])
			{
				return true;
			}
			return false;
		}

		/**
		 * 获取指定类映射的单例
		 * @param clazz 类定义或类的完全限定名
		 * @param named 可选参数，若在调用mapClass()映射时设置了这个值，则要传入同样的字符串才能获取对应的单例
		 */
		public static function getInstance(requestor : Object, name : String = "") : Object
		{
			var requestName : String = getKey(requestor) + "#" + name;
			if (mapValueDic[requestName])
				return mapValueDic[requestName];
			var returnClass : Class = mapClassDic[requestName] as Class;
			if (returnClass)
			{
				var instance : Object = new returnClass();
				mapValueDic[requestName] = instance;
				delete mapClassDic[requestName];
				return instance;
			}
			throw new SunnyGameEngineError("调用了未配置的注入规则！Class#named:" + requestName + "。 请先在项目初始化里配置指定的注入规则，再调用对应单例。");
		}
	}
}