
package com.sunny.game.engine.utils.swffit {
	
	import flash.events.Event;
	
	
	public class SSwfFitEvent extends Event {
		

		public static const CHANGE:String = "change";
		

		public static const START_FIT:String = "startFit";

		public static const STOP_FIT:String = "stopFit";
		
		
		public function SSwfFitEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		
		public override function clone():Event {
			return new SSwfFitEvent(type, bubbles, cancelable);
		}
		
		
		public override function toString():String {
			return formatToString("SWFFitEvent", "type", "bubbles", "cancelable");
		}
		
	}
	
}