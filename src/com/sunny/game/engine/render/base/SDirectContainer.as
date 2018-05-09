package com.sunny.game.engine.render.base
{
	import com.sunny.game.engine.render.interfaces.SIContainer;
	import com.sunny.game.engine.render.interfaces.SIDisplay;
	
	import starling.base.SSprite;
	import starling.display.DisplayObject;

	public class SDirectContainer extends SSprite implements SIContainer
	{
		public function SDirectContainer()
		{
			super();
		}

		public function addGameChildAt(child : SIDisplay, index : int) : void
		{
			if (child is DisplayObject)
			{
				addChildAt(child as DisplayObject, index);
			}
		}

		public function addGameChild(child : SIDisplay) : void
		{
			if (child is DisplayObject)
			{
				addChild(child as DisplayObject);
			}
		}

		public function removeGameChildAt(index : int) : void
		{
			this.removeChildAt(index);
		}

		public function getGameChildIndex(child : SIDisplay) : int
		{
			return this.getChildIndex(child as DisplayObject);
		}

		public function setGameChildIndex(child : SIDisplay, index : int) : void
		{
			this.setChildIndex(child as DisplayObject, index);
		}

		public function removeGameChild(child : SIDisplay) : void
		{
			this.removeChild(child as DisplayObject);
		}

		public function get sparent() : SIContainer
		{
			return parent as SIContainer;
		}
	}
}