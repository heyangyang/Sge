package com.sunny.game.engine.particle
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * 发光泡泡生成器
	 *
	 */
	public class SLightBallGenerator extends SBasicParticleGenerator
	{
		public var lightRadius : int;
		public var speed : Number;
		public var density : Number;

		public function SLightBallGenerator(parent : Sprite, viewRect : Rectangle, density : Number = 0.5, radius : int = 100, speed : Number = 40)
		{
			super(parent, viewRect);

			this.lightRadius = radius;
			this.speed = speed;
			this.density = density;
		}

		override public function update() : void
		{
			super.update();
			if (Math.random() < density)
				add();

			for (var i : int = children.length - 1; i >= 0; i--)
			{
				var child : LightBall = children[i] as LightBall;
				child.life += elapsedTimes / 1000 * child.speed;
				child.r += elapsedTimes / 1000 / 20 * child.speed * Math.random();
				if (child.life > 100)
				{
					remove(child);
				}
				else
				{
					child.y -= elapsedTimes / 1000 * child.speed;
					child.x += Math.cos(child.r);
					if (child.life < 20)
						child.alpha = child.life / 20;
					else if (child.life > 80)
						child.alpha = (100 - child.life) / 20;
				}
			}
		}

		protected override function createNewChild() : DisplayObject
		{
			return new LightBall(lightRadius, speed);
		}

		protected override function placeNewChild(child : DisplayObject) : void
		{
			child.x = Math.random() * (contentWidth + child.width * 2) - child.width;
			child.y = Math.random() * (contentHeight + child.height * 2) - child.height;
			LightBall(child).life = 0;
			LightBall(child).r = Math.random() * Math.PI * 2;
			child.alpha = 0.0;
		}

		protected override function destoryChild(child : DisplayObject) : void
		{
			(child as Bitmap).bitmapData.dispose();
		}
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.GradientType;
import flash.display.Shape;
import flash.geom.Matrix;

class LightBall extends Bitmap
{
	public var life : Number;
	public var speed : Number;
	public var r : Number;

	public function LightBall(radius : int, speed : Number)
	{
		radius = radius * (Math.random() + 0.5);
		super(new BitmapData(radius * 2, radius * 2, true, 0));

		this.speed = speed;

		var ma : Matrix = new Matrix();
		ma.createGradientBox(radius * 2, radius * 2);
		var shape : Shape = new Shape();
		shape.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, 0xFFFFFF], [Math.random(), 0.0], [0, 0xFF], ma);
		shape.graphics.drawCircle(radius, radius, radius);
		shape.graphics.endFill();
		this.bitmapData.draw(shape);

		blendMode = BlendMode.ADD;
	}
}