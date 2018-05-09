package com.sunny.game.engine.ui.utils
{
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormat;


	/**
	 *
	 * 调用setMask函数产生蒙版效果 removeMask删除蒙版
	 */
	public class SMaskUtil
	{
		private static var _parent : DisplayObjectContainer;

		public function SMaskUtil()
		{
			throw new SunnyGameEngineError("这是一个静态类，不要进行初始化操作！");
		}

		/***
		 * 为一个对象添加遮照
		 * @param target 要加遮照的当前对象
		 * @param maskColor 蒙版的颜色
		 * @param maskAlpha
		 *
		 * **/
		public static function setMask(target : DisplayObjectContainer, name : String, str : String = null, fm : TextFormat = null, embedFonts : Boolean = false, alpha : Number = 0.5) : void
		{
			if (target == null)
				return;
			if (!name)
			{
				trace('setMask操作必须指定name属性');
				return;
			}
			SModalMask.addModalMask(target, name, 0x000000, alpha, str, fm, embedFonts);
		}

		/**
		 * 删除一个蒙版
		 * @param target
		 * @param isAddToStage
		 *
		 */
		public static function removeMask(name : String) : void
		{
			SModalMask.removeModalMask(name);
		}
	/**
	 *
	 * 绘制一段扇形图像 radius 半径 angle弧度
	 * var gb:Sprite = new Sprite();
	   this.addChild(gb);
	   var timer:Timer = new Timer(500,30);
	   timer.addEventListener(TimerEvent.TIMER,timerHandler);
	   timer.start();

	   function timerHandler(evt:TimerEvent):void {
	   removeAllChild(gb);
	   trace(12*evt.target.currentCount);
	   var f:Shape = drawFan(100,12*evt.target.currentCount);
	   f.rotation = 270;
	   f.x = 200;
	   f.y = 200;
	   gb.addChild(f);
	   }
	   function removeAllChild(ui:Sprite):void
	   {
	   for(var i:int = 0;i<ui.numChildren;i++)
	   {
	   ui.removeChildAt(0);
	   }
	   }
	 */
//		function drawFan(radius:Number, angle:Number, thickness:Number = 1, alpha:int = 1, color:uint = 0x000000):Shape {
//			var fan:Shape = new Shape();
//			fan.graphics.beginFill(color, thickness);
//			fan.graphics.lineTo(radius, 0);
//			for (var i:int = 0; i <= angle; i++) {
//				var degree:Number = Math.PI / 180 * i;
//				var targetPoint:Point = Point.polar(radius, degree);
//				fan.graphics.lineTo(targetPoint.x, targetPoint.y);
//			}
//			fan.graphics.lineTo(0, 0);
//			fan.graphics.endFill();
//			return fan;
//		}

	}

}