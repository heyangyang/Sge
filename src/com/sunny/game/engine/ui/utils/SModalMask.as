package com.sunny.game.engine.ui.utils
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.events.SEventPool;
	import com.sunny.game.engine.ui.SUIStyle;
	import com.sunny.game.engine.utils.SFilterUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class SModalMask
	{
		private static var _masks : Dictionary = new Dictionary();
		private static var _masksInfo : Dictionary = new Dictionary();

		/**
		 * 添加遮罩
		 * @param target
		 * @param name
		 * @param width
		 * @param height
		 * @param color
		 * @param alpha
		 * @param resizeWithStage
		 */
		public static function addModalMask(parent : DisplayObjectContainer, target : *, color : uint = 0x000000, alpha : Number = 0.7, str : String = null, fm : TextFormat = null, embedFonts : Boolean = false) : Sprite
		{
			if (parent == null)
			{
				trace('ModalMask target 不能为null');
				return null;
			}
			var width : int = 0;
			var height : int = 0;
			//if (target == SGlobalVariables.popUpContainer)
			{
				width = SShellVariables.nativeStage.stageWidth;
				height = SShellVariables.nativeStage.stageHeight;
			}
//			else
//			{
//				width = target.width;
//				height = target.height;
//			}

			if (!_masks[target])
			{
				var info : Object = new Object();
				info['color'] = color;
				info['alpha'] = alpha;
				var modalMask : Sprite = new Sprite();
				parent.addChild(modalMask);

				var mask : Shape = new Shape();
				mask.name = "maskShape";
				modalMask.addChild(mask);
				mask.filters = [getBlurFilter()];

				modalMask.mouseChildren = true;
				modalMask.mouseEnabled = true;

				_masks[target] = modalMask;
				_masksInfo[target] = info;
				drawModal(mask, info);

				//if (target == SGlobalVariables.popUpContainer)
				SEventPool.addEventListener(SEvent.RESIZE, onStageResize);
				if (str)
					createTxt(modalMask, str, fm, embedFonts);
			}
			return _masks[target] as Sprite;
		}

		private static function drawModal(mask : Shape, info : Object) : void
		{
			var target : DisplayObjectContainer = mask.parent.parent;
			mask.graphics.clear();
			mask.graphics.beginFill(info["color"], info["alpha"]);
			var width : int = 0;
			var height : int = 0;
			//if (target == SGlobalVariables.popUpContainer)
			{
				width = SShellVariables.nativeStage.stageWidth;
				height = SShellVariables.nativeStage.stageHeight;
			}
//			else
//			{
//				width = target.width;
//				height = target.height;
//			}
			mask.graphics.drawRect(0, 0, width, height);
			mask.graphics.endFill();
		}

		private static function createTxt(modalMask : Sprite, str : String, fm : TextFormat, embedFonts : Boolean = false) : void
		{
			var txt : TextField = new TextField();
			txt.text = str;
			txt.textColor = 0x000000;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.mouseWheelEnabled = false;
			txt.embedFonts = embedFonts;
			if (!fm)
				fm = new TextFormat(SUIStyle.TEXT_FONT, "36", 0x000000, true);
			txt.setTextFormat(fm);
			txt.x = (modalMask.width - txt.width) / 2;
			txt.y = (modalMask.height - txt.height) / 2;
			txt.filters = SFilterUtil.blackFilters;
			modalMask.addChild(txt);
		}

		private static function getBlurFilter() : BlurFilter
		{
			return new BlurFilter(40, 40, BitmapFilterQuality.HIGH);
		}

		public static function removeModalMask(target : *) : void
		{
			var modalMask : Sprite = _masks[target] as Sprite;
			if (modalMask)
			{
				if (modalMask.parent)
					modalMask.parent.removeChild(modalMask);

				//if (target == SGlobalVariables.popUpContainer)
				//SEventPool.removeEventListener(Event.RESIZE, onStageResize);
				_masks[target] = null;
				delete _masks[target];
				_masksInfo[target] = null;
				delete _masksInfo[target];
			}
		}

		private static function onStageResize(e : SEvent) : void
		{
			for (var target : * in _masks)
			{
				var modalMask : Sprite = _masks[target];
				var info : Object = _masksInfo[target];
				if (modalMask && info)
				{
					var mask : Shape = modalMask.getChildByName("maskShape") as Shape;
					drawModal(mask, info);
				}
			}
		}
	}
}