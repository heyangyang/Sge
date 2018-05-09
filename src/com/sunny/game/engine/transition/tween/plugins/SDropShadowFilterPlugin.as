/**
 * VERSION: 2.0
 * DATE: 8/18/2009
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
package com.sunny.game.engine.transition.tween.plugins
{
	import com.sunny.game.engine.transition.tween.STweenLite;

	import flash.filters.DropShadowFilter;

	/**
	 * Tweens a DropShadowFilter. The following properties are available (you only need to define the ones you want to tween):
	 * <code>
	 * <ul>
	 * 		<li> distance : Number [0]</li>
	 * 		<li> angle : Number [45]</li>
	 * 		<li> color : uint [0x000000]</li>
	 * 		<li> alpha :Number [0]</li>
	 * 		<li> blurX : Number [0]</li>
	 * 		<li> blurY : Number [0]</li>
	 * 		<li> strength : Number [1]</li>
	 * 		<li> quality : uint [2]</li>
	 * 		<li> inner : Boolean [false]</li>
	 * 		<li> knockout : Boolean [false]</li>
	 * 		<li> hideObject : Boolean [false]</li>
	 * 		<li> index : uint</li>
	 * 		<li> addFilter : Boolean [false]</li>
	 * 		<li> remove : Boolean [false]</li>
	 * </ul>
	 * </code>
	 * Set <code>remove</code> to true if you want the filter to be removed when the tween completes. <br /><br />
	 *
	 * <b>USAGE:</b><br /><br />
	 * <code>
	 * 		import com.greensock.TweenLite; <br />
	 * 		import com.greensock.plugins.TweenPlugin; <br />
	 * 		import com.greensock.plugins.DropShadowFilterPlugin; <br />
	 * 		TweenPlugin.activate([DropShadowFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
	 *
	 * 		TweenLite.to(mc, 1, {dropShadowFilter:{blurX:5, blurY:5, distance:5, alpha:0.6}}); <br /><br />
	 * </code>
	 *
	 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
	 *
	 * @author Jack Doyle, jack@greensock.com
	 */
	public class SDropShadowFilterPlugin extends FilterPlugin
	{
		/** @private **/
		public static const API : Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		private static var _propNames : Array = ["distance", "angle", "color", "alpha", "blurX", "blurY", "strength", "quality", "inner", "knockout", "hideObject"];

		/** @private **/
		public function SDropShadowFilterPlugin()
		{
			super();
			this.propName = "dropShadowFilter";
			this.overwriteProps = ["dropShadowFilter"];
		}

		/** @private **/
		override public function setup(target : Object) : Boolean
		{
			_target = (target as STweenLite).target;
			_type = DropShadowFilter;
			initFilter(_value, new DropShadowFilter(0, 45, 0x000000, 0, 0, 0, 1, _value.quality || 2, _value.inner, _value.knockout, _value.hideObject), _propNames);
			return true;
		}
	}
}