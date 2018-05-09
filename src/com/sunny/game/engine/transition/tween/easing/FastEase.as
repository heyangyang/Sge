package com.sunny.game.engine.transition.tween.easing {
	import flash.utils.Dictionary;
	import com.sunny.game.engine.transition.tween.STweenLite;

	public class FastEase {
		
		
		public static function activateEase(ease:Function, type:int, power:uint):void {
			STweenLite.fastEaseLookup[ease] = [type, power];
		}
		
		
		public static function activate(easeClasses:Array):void {
			var i:int = easeClasses.length, easeClass:Object;
			while (i--) {
				easeClass = easeClasses[i];
				if (easeClass.hasOwnProperty("power")) {
					activateEase(easeClass.easeIn, 1, easeClass.power);
					activateEase(easeClass.easeOut, 2, easeClass.power);
					activateEase(easeClass.easeInOut, 3, easeClass.power);
					if (easeClass.hasOwnProperty("easeNone")) {
						activateEase(easeClass.easeNone, 1, 0);
					}
				}
			}
		}
		
	}
}