
package com.sunny.game.engine.transition.tween.plugins {
	import com.sunny.game.engine.transition.tween.plugins.STintPlugin;

	public class RemoveTintPlugin extends STintPlugin {
		
		public static const API:Number = 1.0;
		
		public function RemoveTintPlugin() {
			super();
			this.propName = "removeColor";
		}

	}
}