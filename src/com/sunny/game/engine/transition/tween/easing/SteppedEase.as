package com.sunny.game.engine.transition.tween.easing {
	 
	public class SteppedEase {
		
		private var _steps:int;
		
		private var _stepAmount:Number;
		
		
		public function SteppedEase(steps:int) {
			_stepAmount = 1 / steps;
			_steps = steps + 1;
		}
		
		
		public static function create(steps:int):Function {
			var se:SteppedEase = new SteppedEase(steps);
			return se.ease;
		}
		
		
		public function ease(t:Number, b:Number, c:Number, d:Number):Number {
			var ratio:Number = t / d;
			if (ratio < 0) {
				ratio = 0;
			} else if (ratio >= 1) {
				ratio = 0.999999999;
			}
			return ((_steps * ratio) >> 0) * _stepAmount;
		}
		
		
		public function get steps():int {
			return _steps - 1;
		}

	}
}
