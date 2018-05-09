package com.sunny.game.engine.transition.tween.easing {

	public class EaseLookup {
		
		private static var _lookup:Object;
		
		
		public static function find(name:String):Function {
			if (_lookup == null) {
				buildLookup();
			}
			return _lookup[name.toLowerCase()];
		}
		
		
		private static function buildLookup():void {
			_lookup = {};
			
			addInOut(SEaseBack, ["back"]);
			addInOut(SEaseBounce, ["bounce"]);
			addInOut(SEaseCircular, ["circ", "circular"]);
			addInOut(SEaseCubic, ["cubic"]);
			addInOut(SEaseElastic, ["elastic"]);
			addInOut(SEaseExponential, ["expo", "exponential"]);
			addInOut(SEaseLinear, ["linear"]);
			addInOut(SEaseQuadratic, ["quad", "quadratic"]);
			addInOut(SEaseQuartic, ["quart","quartic"]);
			addInOut(SEaseQuintic, ["quint", "quintic", "strong"]);
			addInOut(SEaseSinusoidal, ["sine"]);
			
			_lookup["linear.easenone"] = _lookup["lineareasenone"] = SEaseLinear.easeNone;
		}
		
		
		private static function addInOut(easeClass:Class, names:Array):void {
			var name:String;
			var i:int = names.length;
			while (i-- > 0) {
				name = names[i].toLowerCase();
				_lookup[name + ".easein"] = _lookup[name + "easein"] = easeClass.easeIn;
				_lookup[name + ".easeout"] = _lookup[name + "easeout"] = easeClass.easeOut;
				_lookup[name + ".easeinout"] = _lookup[name + "easeinout"] = easeClass.easeInOut;
			}
		}
		
		
	}
}