package com.sunny.game.engine.weather
{
	import com.sunny.game.engine.core.SUpdatableSprite;
	import com.sunny.game.engine.utils.SFilterUtil;

	import flash.filters.BitmapFilterQuality;

	public class SBlueFlash extends SUpdatableSprite
	{
		public var vx : Number;
		public var vy : Number;
		public var sx : Number;
		public var sy : Number;
		public var ex : Number;
		public var ey : Number;
		public var life : Number;
		public var vLen : Number;

		public function SBlueFlash(sx : Number, sy : Number, ex : Number, ey : Number, life : Number)
		{
			this.sx = sx;
			this.sy = sy;
			this.ex = ex;
			this.ey = ey;
			this.life = life;
			var dx : Number = (this.sx - this.ex);
			var dy : Number = (this.sy - this.ey);
			var dist : Number = Math.sqrt(dx * dx + dy * dy);
			this.vx = -dx / 10;
			this.vy = -dy / 10;

			frameRate = 10;

			filters = [SFilterUtil.getGlowFilter(0x3299FF, 1, 8, 8, 2, BitmapFilterQuality.LOW)];
			//add
			register(2);
		}

		override public function update() : void
		{
			graphics.clear();
			var num1 : Number = 0;
			var num2 : Number = 0;
			var num3 : Number = (life / 100);

			var lsx : Number = sx;
			var lsy : Number = sy;

			graphics.lineStyle((1 + num3), 16777215, (num3 + 0.1));
			graphics.moveTo(lsx, lsy);
			var tick : int = 0;
			while (tick < 9)
			{
				num3 -= 0.05;

				num1 = -6 + Math.random() * 12;
				num2 = -6 + Math.random() * 12;
				num2 = num2 - Math.sin(tick * 0.5) * 5;
				lsx += vx;
				lsy += vy;
				lsx += num1;
				lsy += num2;
				graphics.lineTo(lsx, lsy);
				tick++;
			}
			;
			graphics.lineTo(ex, ey);

			life = (life - 3);
			if (life <= 0)
			{
				//remove
				unregister();
				if (parent)
					parent.removeChild(this);
			}
		}
	}
}