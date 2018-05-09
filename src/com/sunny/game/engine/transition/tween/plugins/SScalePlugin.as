/**
 * VERSION: 1.13
 * DATE: 10/2/2009
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
package com.sunny.game.engine.transition.tween.plugins
{
	import com.sunny.game.engine.transition.tween.STweenLite;

	/**
	 * ScalePlugin combines scaleX and scaleY into one "scale" property. <br /><br />
	 *
	 * <b>USAGE:</b><br /><br />
	 * <code>
	 * 		import com.greensock.TweenLite; <br />
	 * 		import com.greensock.plugins.TweenPlugin; <br />
	 * 		import com.greensock.plugins.ScalePlugin; <br />
	 * 		TweenPlugin.activate([ScalePlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
	 *
	 * 		TweenLite.to(mc, 1, {scale:2});  //tweens horizontal and vertical scale simultaneously <br /><br />
	 * </code>
	 *
	 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
	 *
	 * @author Jack Doyle, jack@greensock.com
	 */
	public class SScalePlugin extends STweenPlugin
	{
		/** @private **/
		public static const API : Number = 1.0;

		/** @private **/
		protected var _target : Object;
		/** @private **/
		protected var _startX : Number;
		/** @private **/
		protected var _changeX : Number;
		/** @private **/
		protected var _startY : Number;
		/** @private **/
		protected var _changeY : Number;

		/** @private **/
		public function SScalePlugin()
		{
			super();
			this.propName = "scale";
			this.overwriteProps = ["scaleX", "scaleY", "width", "height"];
		}

		/** @private **/
		override public function setup(target : Object) : Boolean
		{
			if (!(target as STweenLite).target.hasOwnProperty("scaleX"))
			{
				return false;
			}
			_target = (target as STweenLite).target;
			_startX = _target.scaleX;
			_startY = _target.scaleY;
			if (typeof(_value) == "number")
			{
				_changeX = Number(_value) - _startX;
				_changeY = Number(_value) - _startY;
			}
			else
			{
				_changeX = _changeY = Number(_value);
			}
			return true;
		}

		/** @private **/
		override public function killProps(lookup : Object) : void
		{
			var i : int = this.overwriteProps.length;
			while (i--)
			{
				if (this.overwriteProps[i] in lookup)
				{ //if any of the properties are found in the lookup, this whole plugin instance should be essentially deactivated. To do that, we must empty the overwriteProps Array.
					this.overwriteProps = [];
					return;
				}
			}
		}

		/** @private **/
		override public function set changeFactor(n : Number) : void
		{
			_target.scaleX = _startX + (n * _changeX);
			_target.scaleY = _startY + (n * _changeY);
		}
	}
}