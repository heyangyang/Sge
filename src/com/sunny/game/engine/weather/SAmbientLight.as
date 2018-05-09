package com.sunny.game.engine.weather
{
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 *
	 * <p>
	 * SunnyGame的环境光
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
	public class SAmbientLight extends Sprite
	{
		public static const TIME_MORNING : int = 0;
		public static const TIME_DAYTIME : int = 1;
		public static const TIME_NIGHTFALL : int = 2;
		public static const TIME_EVENING : int = 3;

		private var _width : int;
		private var _height : int;

		private var _light : SLight;

		public function SAmbientLight(width : int, height : int)
		{
			this.blendMode = BlendMode.LAYER;

			resize(width, height);
		}

		private function createChildren() : void
		{
			//_light = new SLight(400, _width,_height,[0x000000, 0x000000], [0, 0.7]);
			addChild(_light);
		}

		public function resize(w : int, h : int) : void
		{
			_width = w;
			_height = h;

			graphics.clear();
			graphics.beginFill(0x000000, 0.7);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();

			_light.x = (_width - _light.width) / 2;
			_light.y = (_height - _light.height) / 2;
		}

		public function show(timeType : int) : void
		{

		}

		public function showMorning() : void
		{

		}

		public function showDaytime() : void
		{
			graphics.clear();
		}

		public function showNightfall() : void
		{

		}

		public function showEvening() : void
		{
			graphics.clear();
			graphics.beginFill(0, 0.5);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();

			var w : int = 200;
			var h : int = 100;
			var sx : int = (_width - w) / 2;
			var sy : int = (_height - h) / 2;

			var fillType : String = GradientType.RADIAL;
			var colors : Array = [0xffffff, 0x000000];
			var alphas : Array = [0.3, 0];
			var ratios : Array = [120, 255];
			var matr : Matrix = new Matrix();
			matr.createGradientBox(w, h, 0, sx, sy);
			var spreadMethod : String = SpreadMethod.PAD;
			graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod, 'rgb', 0);
			graphics.drawEllipse(sx, sy, w, h);
			graphics.endFill();
		}
	}
}