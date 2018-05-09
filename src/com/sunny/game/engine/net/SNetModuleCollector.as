package com.sunny.game.engine.net
{
	import flash.utils.describeType;

	/**
	 *
	 * <p>
	 * 一个网络模块采集器
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
	public class SNetModuleCollector
	{
		public function SNetModuleCollector()
		{
		}

		public function collect() : void
		{
			var xml : XML = describeType(this);
			for each (var variable : * in xml.constant)
			{
				var varName : String = String(variable.@name);
				var obj : Object = this[varName];
				var msgCls : Class = obj.msg as Class;
				var index : int = msgCls.MODULE_INDEX;
				if (index >= 0)
				{
					var ntfCls : Class = obj.ntf as Class;
					var notify : SINotifier = new ntfCls();
					SNetManager.getInstance().registerModule(String(index), notify);
				}
			}
		}
	}
}