
package com.sunny.game.engine.transition.tween.plugins
{
	import com.sunny.game.engine.transition.tween.STweenLite;

	
	public class SAutoAlphaPlugin extends STweenPlugin
	{
		
		public static const API : Number = 1.0;
		
		protected var _target : Object;
		
		protected var _ignoreVisible : Boolean;

		
		public function SAutoAlphaPlugin()
		{
			super();
			this.propName = "autoAlpha";
			this.overwriteProps = ["alpha", "visible"];
		}

		
		override public function setup(target : Object) : Boolean
		{
			_target = (target as STweenLite).target;
			addTween(_target, "alpha", _target.alpha, _value, "alpha");
			return true;
		}

		
		override public function killProps(lookup : Object) : void
		{
			super.killProps(lookup);
			_ignoreVisible = Boolean("visible" in lookup);
		}

		
		override public function set changeFactor(n : Number) : void
		{
			updateTweens(n);
			if (!_ignoreVisible)
			{
				_target.visible = Boolean(_target.alpha != 0);
			}
		}

	}
}