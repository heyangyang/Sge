package com.sunny.game.engine.weather
{
	import com.sunny.game.engine.core.SIResizable;
	import com.sunny.game.engine.core.SUpdatableSprite;

	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.filters.BitmapFilterType;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Matrix;

	/**
	 *
	 * <p>
	 * SunnyGame的光
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
	public class SLight extends SUpdatableSprite implements SIResizable
	{
		private var _color : uint;
		private var _intensity : int = 100;
		private var _decay : int = 50;
		private var _lightRadius : Number = 0;

		private var _lightSprite : Shape;

		/**
		 * 光球遮罩层
		 */
		public var maskSprite : Shape;

		public function SLight(radius : Number, width : int, height : int, color : uint = 0xffffff, intensity : int = 80, decay : int = 50)
		{
			super();

			_lightSprite = new Shape();
//			_lightSprite.alpha = 0.5;
			_lightSprite.blendMode = BlendMode.ADD; //BlendMode.ALPHA;
//			_lightSprite.filters = [new GlowFilter(0xffffff, 0.2  ,6 ,6 , 2 , 1 , false)];
			addChild(_lightSprite);

			this.maskSprite = new Shape();
			this.maskSprite.blendMode = BlendMode.ERASE;
			this.addChild(maskSprite);

			this.blendMode = BlendMode.LAYER;
			_color = color;
			_intensity = intensity;
			_decay = decay;

			resize(width, height);

			this.mouseEnabled = false;
			//this.cacheAsBitmap = true;
		}

		public function resize(w : int, h : int) : void
		{
			this.graphics.beginFill(0xffffff, 1);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}

		public function focusAt(x : int, y : int) : void
		{
			_lightSprite.x = x;
			_lightSprite.y = y;
		}

		public function get lightRadius() : Number
		{
			return _lightRadius;
		}

		public function set lightRadius(value : Number) : void
		{
			value = Math.max(value, 0);
			if (_lightRadius != value)
			{
				_lightRadius = value;
				updateGraphic();
			}
		}

		private function updateGraphic() : void
		{
			var m : Matrix = new Matrix();
			m.createGradientBox(_lightRadius * 2, _lightRadius * 2, 0, -_lightRadius, -_lightRadius);
			m.rotate(-45 * Math.PI / 180);
			m.scale(1.0015, 0.501);
			_lightSprite.graphics.clear();
			_lightSprite.graphics.beginGradientFill(GradientType.RADIAL, [_color, _color], [_intensity / 100, 0], [254 * _decay / 100, 255], m, SpreadMethod.PAD, "linearRGB", 0);
			_lightSprite.graphics.drawCircle(0, 0, _lightRadius);
			_lightSprite.graphics.endFill();
			var colors : Array = [_color, 0];
			var alphas : Array = [1, 0];
			var ratios : Array = [0, _lightRadius];
			var f : GradientGlowFilter = new GradientGlowFilter(0, 0, colors, alphas, ratios, 50, 50, 1, 2, BitmapFilterType.INNER, false);
			_lightSprite.filters = [f];
//			var displacer : DisplacementMapFilter = new DisplacementMapFilter();
//			displacer.componentX = 1;
//			displacer.componentY = 2;
//			displacer.mode =	DisplacementMapFilterMode.IGNORE;
//			displacer.alpha =	0;
//			displacer.scaleX = 120;
//			displacer.scaleY = 120;
//			_lightSprite.filters = [displacer];
//			displacer.mapBitmap = bumpMap.outputData;
		}

	/*private function updateGraphic() : void
	{
//			var matr:Matrix = new Matrix();
//			matr.createGradientBox(20, 20, 0, 0, 0);
		_lightSprite.graphics.clear();
		_lightSprite.graphics.beginGradientFill(GradientType.RADIAL, [0xffff00, 0x000000], [0.1, 1], [0, 255], null, 'pad', InterpolationMethod.LINEAR_RGB, 0.2);
		_lightSprite.graphics.drawCircle(0, 0, 100);
		_lightSprite.graphics.endFill();
		_lightSprite.width = _lightRadius * 2;
		_lightSprite.height = (_lightRadius * 2);
	}*/
	}

/**
 * Draws the polygon into the supplied graphics object
 * Does not clear(), beginFill() or endFill() so it can be used in any context
 *
 * @param canvas: Where polygon is to be drawn
 */
//	public function draw(canvas : Graphics) : void
//	{
//
//		for(var i : int = 0 ; i < this.contours.length ; i++)
//		{
//			var points : Array = this.contours[i]
//			var np : int = points.length
//			if(np >= 3)
//			{
//				canvas.moveTo(points[0].x , points[0].y)
//				for(var j : int = 1 ; j < np ; j++)
//					canvas.lineTo(points[j].x , points[j].y)
//			}
//		}
//		for(i = 0 ; i < this.holes.length ; i++)
//		{
//			points = this.holes[i]
//			np = points.length - 1
//			if(np >= 2)
//			{
//				canvas.moveTo(points[np].x , points[np].y)
//				for(j = np - 1 ; j >= 0 ; j--)
//					canvas.lineTo(points[j].x , points[j].y)
//			}
//		}
//
//	}

}