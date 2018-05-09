package com.sunny.game.engine.transition.tween.easing {
	 
	public class RoughEase {		
		
		private static var _lookup:Object = {};
		
		private static var _count:uint = 0;
		
		
		private var _name:String;
		
		private var _first:EasePoint;
		
		private var _last:EasePoint;
		
		
		public function RoughEase(strength:Number=1, points:uint=20, restrictMaxAndMin:Boolean=false, templateEase:Function=null, taper:String="none", randomize:Boolean=true, name:String="") {
			if (name == "") {
				_name = "roughEase" + (_count++);
			} else {
				_name = name;
				_lookup[_name] = this;
			}
			if (taper == "" || taper == null) {
				taper = "none";
			}
			var a:Array = [];
			var cnt:int = 0;
			strength *= 0.4; 
			var x:Number, y:Number, bump:Number, invX:Number, obj:Object;
			var i:int = points;
			while (--i > -1) {
				x = randomize ? Math.random() : (1 / points) * i;
				y = (templateEase != null) ? templateEase(x, 0, 1, 1) : x;
				if (taper == "none") {
					bump = strength;
				} else if (taper == "out") {
					invX = 1 - x;
					bump = invX * invX * strength;
				} else if (taper == "in") {
					bump = x * x * strength;
				} else if (x < 0.5) { 
					invX = x * 2;
					bump = invX * invX * 0.5 * strength;
				} else {				
					invX = (1 - x) * 2;
					bump = invX * invX * 0.5 * strength;
				}
				if (randomize) {
					y += (Math.random() * bump) - (bump * 0.5);
				} else if (i % 2) {
					y += bump * 0.5;
				} else {
					y -= bump * 0.5;
				}
				if (restrictMaxAndMin) {
					if (y > 1) {
						y = 1;
					} else if (y < 0) {
						y = 0;
					}
				}
				a[cnt++] = {x:x, y:y};
			}
			a.sortOn("x", Array.NUMERIC);
			
			_first = _last = new EasePoint(1, 1, null);
			
			i = points;
			while (--i > -1) {
				obj = a[i];
				_first = new EasePoint(obj.x, obj.y, _first);
			}
			
			_first = new EasePoint(0, 0, (_first.time != 0) ? _first : _first.next);
			
		}
		
		
		public static function create(strength:Number=1, points:uint=20, restrictMaxAndMin:Boolean=false, templateEase:Function=null, taper:String="none", randomize:Boolean=true, name:String=""):Function {
			var re:RoughEase = new RoughEase(strength, points, restrictMaxAndMin, templateEase, taper, randomize, name);
			return re.ease;
		}
		
		
		public static function byName(name:String):Function {
			return _lookup[name].ease;
		}
		
		
		public function ease(t:Number, b:Number, c:Number, d:Number):Number {
			var time:Number = t / d;
			var p:EasePoint;
			if (time < 0.5) {
				p = _first;
				while (p.time <= time) {
					p = p.next;
				}
				p = p.prev;
			} else {
				p = _last;
				while (p.time >= time) {
					p = p.prev;
				}
			}
			
			return b + (p.value + ((time - p.time) / p.gap) * p.change) * c;
		}
		
		
		public function dispose():void {
			delete _lookup[_name];
		}
		
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			delete _lookup[_name];
			_name = value;
			_lookup[_name] = this;
		}

	}
}

internal class EasePoint {
	public var time:Number;
	public var gap:Number;
	public var value:Number;
	public var change:Number;
	public var next:EasePoint;
	public var prev:EasePoint;
	
	public function EasePoint(time:Number, value:Number, next:EasePoint) {
		this.time = time;
		this.value = value;
		if (next) {
			this.next = next;
			next.prev = this;
			this.change = next.value - value;
			this.gap = next.time - time;
		}
	}
}