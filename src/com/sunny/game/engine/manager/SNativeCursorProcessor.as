package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.core.SObject;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;

	/**
	 *
	 * <p>
	 * SunnyGame的一个本地光标处理
	 * 使用FP 10.2中的registerCursor(name:String, cursor:MouseCursorData)
	 * 进行系统级别鼠标替换的处理类, 光标资源不允许大于35*35
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
	public class SNativeCursorProcessor extends SObject implements SICusorProcessor
	{
		/**
		 * 默认光标
		 */
		public var defaultCursor : String;

		public function SNativeCursorProcessor()
		{
			super();
		}

		public function registerCursor(type : String, bitmapDatas : Array) : void
		{
			var cursorData : MouseCursorData = new MouseCursorData();
			cursorData.hotSpot = new Point(0, 0);
			cursorData.data = Vector.<BitmapData>(bitmapDatas);
			Mouse.registerCursor(type, cursorData);
		}

		public function changeCursor(type : String) : void
		{
			if (type == currentCursor)
				return;
			var cursor : String = type ? type : defaultCursor;
			if (cursor)
				currentCursor = cursor;
			else
				currentCursor = MouseCursor.AUTO;
		}

		/**
		 * 当前光标类型
		 * @return
		 *
		 */
		private function get currentCursor() : String
		{
			return Mouse.cursor;
		}

		private function set currentCursor(value : String) : void
		{
			Mouse.cursor = value;
		}
	}
}