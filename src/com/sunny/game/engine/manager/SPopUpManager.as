package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.ui.utils.SModalMask;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;

	/**
	 *
	 * <p>
	 * SunnyGame的一个弹出管理器
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
	public class SPopUpManager
	{
		private static var container : DisplayObjectContainer;
		public static var popUps : Array = [];

		public static function init(mainContainer : DisplayObjectContainer) : void
		{
			container = mainContainer;
		}

		public static function addPopUp(window : DisplayObject, parent : DisplayObjectContainer, modal : Boolean = false) : void
		{
			if (parent == null)
				parent = container;

			if (modal)
				SModalMask.addModalMask(parent, window.name);

			parent.addChild(window);
			popUps.push(window);
		}

		public static function removePopUp(popUp : DisplayObject) : void
		{
			var index : int = popUps.indexOf(popUp);
			if (index != -1)
			{
				SModalMask.removeModalMask(popUp.name);
				popUps.splice(index, 1);
				popUp.parent.removeChild(popUp);
			}
		}

		public static function centerPopUp(popUp : DisplayObject) : void
		{
			if (popUp.parent == container)
			{
				var w : int = popUp.parent is Stage ? (popUp.parent as Stage).stageWidth : popUp.parent.stage.stageWidth
				var h : int = popUp.parent is Stage ? (popUp.parent as Stage).stageHeight : popUp.parent.stage.stageHeight;
			}
			else
			{
				w = popUp.parent is Stage ? (popUp.parent as Stage).stageWidth : popUp.parent.width;
				h = popUp.parent is Stage ? (popUp.parent as Stage).stageHeight : popUp.parent.height;
			}

			popUp.x = (w - popUp.width) / 2;
			popUp.y = (h - popUp.height) / 2;
		}

		public static function bringToFront(popUp : DisplayObject) : void
		{
			popUp.parent.setChildIndex(popUp, popUp.parent.numChildren - 1);
		}
	}
}