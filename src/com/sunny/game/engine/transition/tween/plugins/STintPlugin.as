/**
 * VERSION: 1.3
 * DATE: 2011-09-15
 * AS3
 * UPDATES AND DOCS AT: http://www.TweenMax.com
 **/
package com.sunny.game.engine.transition.tween.plugins
{
	import com.sunny.game.engine.transition.tween.STweenLite;
	import com.sunny.game.engine.transition.tween.core.PropTween;

	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;

	/**
	 * To change a DisplayObject's color/color, set this to the hex value of the color you'd like
	 * to end up at (or begin at if you're using <code>TweenMax.from()</code>). An example hex value would be <code>0xFF0000</code>.<br /><br />
	 *
	 * To remove a color completely, use the RemoveTintPlugin (after activating it, you can just set <code>removeColor:true</code>) <br /><br />
	 *
	 * <b>USAGE:</b><br /><br />
	 * <code>
	 * 		import com.greensock.TweenLite; <br />
	 * 		import com.greensock.plugins.TweenPlugin; <br />
	 * 		import com.greensock.plugins.TintPlugin; <br />
	 * 		TweenPlugin.activate([TintPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
	 *
	 * 		TweenLite.to(mc, 1, {color:0xFF0000}); <br /><br />
	 * </code>
	 *
	 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
	 *
	 * @author Jack Doyle, jack@greensock.com
	 */
	public class STintPlugin extends STweenPlugin
	{
		/** @private **/
		public static const API : Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		protected static var _props : Array = ["redMultiplier", "greenMultiplier", "blueMultiplier", "alphaMultiplier", "redOffset", "greenOffset", "blueOffset", "alphaOffset"];

		/** @private **/
		protected var _transform : Transform;

		/** @private **/
		public function STintPlugin()
		{
			super();
			this.propName = "color";
			this.overwriteProps = ["color"];
		}

		/** @private **/
		override public function setup(target : Object) : Boolean
		{
			if (!((target as STweenLite).target is DisplayObject))
			{
				return false;
			}
			var end : ColorTransform = new ColorTransform();
			if (_value != null && (target as STweenLite).tweenProps.removeColor != true)
			{
				end.color = uint(_value);
			}
			_transform = DisplayObject((target as STweenLite).target).transform;
			var start : ColorTransform = _transform.colorTransform;
			end.alphaMultiplier = start.alphaMultiplier;
			end.alphaOffset = start.alphaOffset;
			init(start, end);
			return true;
		}

		/** @private **/
		public function init(start : ColorTransform, end : ColorTransform) : void
		{
			var i : int = _props.length;
			var p : String, cnt : int = _tweens.length;
			while (i--)
			{
				p = _props[i];
				if (start[p] != end[p])
				{
					_tweens[cnt++] = new PropTween(start, p, start[p], end[p] - start[p], "color", false);
				}
			}
		}

		/** @private **/
		override public function set changeFactor(n : Number) : void
		{
			if (_transform)
			{
				var ct : ColorTransform = _transform.colorTransform;
				var pt : PropTween;
				var i : int = _tweens.length;
				while (--i > -1)
				{
					pt = _tweens[i];
					ct[pt.property] = pt.start + (pt.change * n);
				}
				_transform.colorTransform = ct;
			}
		}

	}
}