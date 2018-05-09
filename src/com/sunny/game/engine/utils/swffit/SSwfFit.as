
package com.sunny.game.engine.utils.swffit {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	
	public class SSwfFit {
		
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		
		
		public function SSwfFit() {
			throw Error('this is a static class and should not be instantiated.');
		}
		
		
		public static function fit(t:String, mw:int = undefined, mh:int = undefined, xw:int = undefined, xh:int = undefined, hc:Boolean = true, vc:Boolean = true):void {
			ExternalInterface.call("swffit.fit", t, mw, mh , xw, xh, hc, vc);
			dispatch(SSwfFitEvent.CHANGE);
		}
		
		
		public static function configure(o:Object):void {
			ExternalInterface.call("swffit.configure", o);
			dispatch(SSwfFitEvent.CHANGE);
		}
		
		
		public static function stopFit(w:* = '100%', h:* = '100%'):void {
			ExternalInterface.call("swffit.stopFit", w, h);
			dispatch(SSwfFitEvent.STOP_FIT);
		}

		
		public static function startFit():void {
			ExternalInterface.call("swffit.startFit");
			dispatch(SSwfFitEvent.START_FIT);
		}
		
		
		public static function addResizeEvent(fn:String):void {
			ExternalInterface.call("swffit.addResizeEvent(" + fn + ")");
		}
		
		
		public static function removeResizeEvent(fn:String):void {
			ExternalInterface.call("swffit.removeResizeEvent(" + fn + ")");
		}
		
		
		private static function getValueOf(p:String):* {
			return ExternalInterface.call("swffit.getValueOf", p);
		}
		
        public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        
        public static function removeEventListener(type:String, listener:Function):void {
            _dispatcher.removeEventListener(type, listener, false);
        }

        
        public static function dispatchEvent(event:Event):Boolean {
            return _dispatcher.dispatchEvent(event);
        }

        
        public static function hasEventListener(type:String):Boolean {
            return _dispatcher.hasEventListener(type);
        }
		
		
		private static function dispatch(type:String):void {
			if (hasEventListener(type)) {
				dispatchEvent(new SSwfFitEvent(type));
			}
		}
		
		public static function set target(t:String):void {
			configure({ target: t });
		}
		public static function get target():String {
			return getValueOf("target");
		}
		
		
		public static function set minWid(w:int):void {
			configure({ minWid: w });
		}
		public static function get minWid():int {			
			return getValueOf("minWid");
		}
		
		
		public static function set minHei(h:int):void {
			configure({ minHei: h });
		}
		public static function get minHei():int {
			return getValueOf("minHei");
		}
		
		
		public static function set maxWid(w:int):void {
			configure({ maxWid: w });
		}
		public static function get maxWid():int {
			return getValueOf("maxWid");
		}
		
		
		public static function set maxHei(h:int):void {
			configure({ maxHei: h });
		}
		public static function get maxHei():int {
			return getValueOf("maxHei");
		}
		
		
		public static function set hCenter(c:Boolean):void {
			configure({ hCenter: c });
		}
		public static function get hCenter():Boolean {
			return getValueOf("hCenter");
		}
		
		
		public static function set vCenter(c:Boolean):void {
			configure({ vCenter: c });
		}
		public static function get vCenter():Boolean {
			return getValueOf("vCenter");
		}
		
	}
	
}