
package com.sunny.game.engine.transition.tween.plugins
{
	import com.sunny.game.engine.transition.tween.STweenLite;

	import flash.filters.BevelFilter;

	
	public class SBevelFilterPlugin extends FilterPlugin
	{
		
		public static const API : Number = 1.0;
		private static var _propNames : Array = ["distance", "angle", "highlightColor", "highlightAlpha", "shadowColor", "shadowAlpha", "blurX", "blurY", "strength", "quality"];

		
		public function SBevelFilterPlugin()
		{
			super();
			this.propName = "bevelFilter";
			this.overwriteProps = ["bevelFilter"];
		}

		
		override public function setup(target : Object) : Boolean
		{
			_target = (target as STweenLite).target;
			_type = BevelFilter;
			initFilter(_value, new BevelFilter(0, 0, 0xFFFFFF, 0.5, 0x000000, 0.5, 2, 2, 0, _value.quality || 2), _propNames);
			return true;
		}
	}
}