package com.sunny.game.engine.transition.tween.layout {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	 
	public class AutoFitArea extends Shape {
		
		public static const version:Number = 2.54;
		
		
		private static var _bd:BitmapData;
		
		private static var _rect:Rectangle = new Rectangle(0, 0, 2800, 2800);
		
		private static var _matrix:Matrix = new Matrix();
		
		
		protected var _parent:DisplayObjectContainer;
		
		protected var _previewColor:uint;
		
		protected var _rootItem:AutoFitItem;
		
		protected var _hasListener:Boolean;
		
		protected var _preview:Boolean;
		
		protected var _tweenMode:Boolean;
		
		protected var _width:Number;
		
		protected var _height:Number;
		
		
		public function AutoFitArea(parent:DisplayObjectContainer, x:Number=0, y:Number=0, width:Number=100, height:Number=100, previewColor:uint=0xFF0000) {
			super();
			super.x = x;
			super.y = y;
			if (parent == null) {
				throw new Error("AutoFitArea parent cannot be null");
			}
			_parent = parent;
			_width = width;
			_height = height;
			_redraw(previewColor);
		}
		
		
		public static function createAround(target:DisplayObject, vars:Object=null, ...args):AutoFitArea {
			if (vars == null || typeof(vars) == "string") {
				//sensed old method - parse the params for backwards compatibility
				vars = {scaleMode:vars || "proportionalInside",
						hAlign:args[0] || "center",
						vAlign:args[1] || "center",
						crop:Boolean(args[2]),
						minWidth:args[3] || 0,
						maxWidth:(isNaN(args[4]) ? 999999999 : args[4]),
						minHeight:args[5] || 0,
						maxHeight:(isNaN(args[6]) ? 999999999 : args[6]),
						calculateVisible:Boolean(args[8])};
			}
			var boundsTarget:DisplayObject = (vars.customBoundsTarget is DisplayObject) ? vars.customBoundsTarget : target;
			var previewColor:uint = isNaN(args[7]) ? (("previewColor" in vars) ? uint(vars.previewColor) : 0xFF0000) : args[7];
			var bounds:Rectangle = (vars.calculateVisible == true) ? getVisibleBounds(boundsTarget, target.parent) : boundsTarget.getBounds(target.parent);
			var afa:AutoFitArea = new AutoFitArea(target.parent, bounds.x, bounds.y, bounds.width, bounds.height, previewColor);
			afa.attach(target, vars);
			return afa;
		}
		
		
		public function attach(target:DisplayObject, vars:Object=null, ...args):void { 
			if (target.parent != _parent) {
				throw new Error("The parent of the DisplayObject " + target.name + " added to AutoFitArea " + this.name + " doesn't share the same parent.");
			}
			if (vars == null || typeof(vars) == "string") {
				//sensed old method - parse the params for backwards compatibility
				vars = {scaleMode:vars || "proportionalInside",
						hAlign:args[0] || "center",
						vAlign:args[1] || "center",
						crop:Boolean(args[2]),
						minWidth:args[3] || 0,
						maxWidth:(isNaN(args[4]) ? 999999999 : args[4]),
						minHeight:args[5] || 0,
						maxHeight:(isNaN(args[6]) ? 999999999 : args[6]),
						calculateVisible:Boolean(args[7]),
						customAspectRatio:Number(args[8]),
						roundPosition:Boolean(args[9])};
			}
			
			release(target);
			_rootItem = new AutoFitItem(target, vars, _rootItem);
			if (vars != null && vars.crop == true) {
				var shape:Shape = new Shape();
				var bounds:Rectangle = this.getBounds(this);
				shape.graphics.beginFill(_previewColor, 1);
				shape.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
				shape.graphics.endFill();
				shape.visible = false;
				_parent.addChild(shape);
				_rootItem.mask = shape;
				target.mask = shape;
			}
			if (_preview) {
				this.preview = true;
			}
			update(null);
		}
		
		
		public function release(target:DisplayObject):Boolean {
			var item:AutoFitItem = getItem(target);
			if (item == null) {
				return false;
			}
			if (item.mask != null) {
				if (item.mask.parent) {
					item.mask.parent.removeChild(item.mask);
				}
				target.mask = null;
				item.mask = null;
			}
			if (item.next) {
				item.next.prev = item.prev;
			}
			if (item.prev) {
				item.prev.next = item.next;
			} else if (item == _rootItem) {
				_rootItem = item.next;
			}
			item.next = item.prev = null;
			item.boundsTarget = null;
			item.target = null;
			return true;
		}
		
		
		public function getAttachedObjects():Array {
			var a:Array = [];
			var cnt:uint = 0;
			var item:AutoFitItem = _rootItem;
			while (item) {
				a[cnt++] = item.target;
				item = item.next;
			}
			return a;
		}
		
		
		protected function getItem(target:DisplayObject):AutoFitItem {
			var item:AutoFitItem = _rootItem;
			while (item) {
				if (item.target == target) {
					return item;
				}
				item = item.next;
			}
			return null;
		}
		
		
		
		public function update(event:Event=null):void {
			//create local variables to speed things up
			var width:Number = this.width;
			var height:Number = this.height;
			var x:Number = this.x;
			var y:Number = this.y;
			var matrix:Matrix = this.transform.matrix;
			
			var item:AutoFitItem = _rootItem;
			var w:Number, h:Number, tx:Number, ty:Number, target:DisplayObject, innerBounds:Rectangle, outerBounds:Rectangle, tRatio:Number, scaleMode:String, ratio:Number, angle:Number, sin:Number, cos:Number, m:Matrix, wScale:Number, hScale:Number, mPrev:Matrix;
			while (item) {
				target = item.target;
				scaleMode = item.scaleMode;
				
				if (scaleMode != ScaleMode.NONE) {
					
					//if the width or height is zero, we cannot effectively scale using multiplication/division, so make sure that the target is at least 1 pixel tall/wide before proceeding. Remember, it'll get adjusted back to what it should be later.
					if (scaleMode != ScaleMode.HEIGHT_ONLY && target.width == 0) {
						target.width = 1; 
					} 
					if (scaleMode != ScaleMode.WIDTH_ONLY && target.height == 0) {
						target.height = 1;
					}
					
					if (item.calculateVisible) {
						innerBounds = item.bounds = getVisibleBounds(item.boundsTarget, target);
						outerBounds = getVisibleBounds(item.boundsTarget, _parent);
					} else {
						innerBounds = item.boundsTarget.getBounds(target);
						outerBounds =  item.boundsTarget.getBounds(_parent);
					}
					tRatio = (item.hasCustomRatio) ? item.aspectRatio : innerBounds.width / innerBounds.height;
					
					m = target.transform.matrix;
					if (m.b != 0 || m.a == 0 || m.d == 0) {
						//if the width/height is zero, we cannot accurately measure the angle.
						if (m.a == 0 || m.d == 0) {
							m = target.transform.matrix = item.matrix;
						} else {
							//inline operations are about 10 times faster than doing item.matrix = m.clone();
							mPrev = item.matrix;
							mPrev.a = m.a;
							mPrev.b = m.b;
							mPrev.c = m.c;
							mPrev.d = m.d;
							mPrev.tx = m.tx;
							mPrev.ty = m.ty;
						}
						angle = Math.atan2(m.b, m.a);
						if (m.a < 0 && m.d >= 0) {
							if (angle <= 0) {
								angle += Math.PI;
							} else {
								angle -= Math.PI;
							}
						}
						sin = Math.sin(angle);
						if (sin < 0) {
							sin = -sin;
						}
						cos = Math.cos(angle);
						if (cos < 0) {
							cos = -cos;
						}
						tRatio = (tRatio * cos + sin) / (tRatio * sin + cos);
					}
					
					w = (width > item.maxWidth) ? item.maxWidth : (width < item.minWidth) ? item.minWidth : width;
					h = (height > item.maxHeight) ? item.maxHeight : (height < item.minHeight) ? item.minHeight : height;
					ratio = w / h;
					
					if ((tRatio < ratio && scaleMode == ScaleMode.PROPORTIONAL_INSIDE) || (tRatio > ratio && scaleMode == ScaleMode.PROPORTIONAL_OUTSIDE)) {
						w = h * tRatio;
						if (w == 0) {
							h = 0;
						} else if (w > item.maxWidth) {
							w = item.maxWidth;
							h = w / tRatio;
						} else if (w < item.minWidth) {
							w = item.minWidth;
							h = w / tRatio;
						}
					}
					if ((tRatio > ratio && scaleMode == ScaleMode.PROPORTIONAL_INSIDE) || (tRatio < ratio && scaleMode == ScaleMode.PROPORTIONAL_OUTSIDE)) {
						h = w / tRatio;
						if (h > item.maxHeight) {
							h = item.maxHeight;
							w = h * tRatio;
						} else if (h < item.minHeight) {
							h = item.minHeight;
							w = h * tRatio;
						}
					}
					
					if (w != 0 && h != 0) {
						wScale = w / outerBounds.width;
						hScale = h / outerBounds.height;
					} else {
						wScale = hScale = 0;
					}
					
					if (scaleMode != ScaleMode.HEIGHT_ONLY) {
						if (item.calculateVisible) {
							item.scaleVisibleWidth(wScale);
						} else if (m.b != 0) {
							m.a *= wScale;
							m.c *= wScale;
							target.transform.matrix = m;
						} else {
							target.width *= wScale;
						}
					}
					if (scaleMode != ScaleMode.WIDTH_ONLY) {
						if (item.calculateVisible) {
							item.scaleVisibleHeight(hScale);
						} else if (m.b != 0) {
							m.d *= hScale;
							m.b *= hScale;
							target.transform.matrix = m;
						} else {
							target.height *= hScale;
						}
					}
					
				}
				
				if (item.hasDrawNow) { //some components incorrectly report getBounds() until after we drawNow()
					Object(target).drawNow();
				}
				
				if (scaleMode != ScaleMode.NONE && innerBounds.x == 0 && innerBounds.y == 0) { //for optimization
					if (scaleMode != ScaleMode.HEIGHT_ONLY) {
						outerBounds.width = w;
					}
					if (scaleMode != ScaleMode.WIDTH_ONLY) {
						outerBounds.height = h;
					}
				} else {
					outerBounds = (item.calculateVisible) ? getVisibleBounds(item.boundsTarget, _parent) : item.boundsTarget.getBounds(_parent);
				}
				
				tx = target.x;
				ty = target.y;
				if (item.hAlign == AlignMode.LEFT) {
					tx += (x - outerBounds.x);
				} else if (item.hAlign == AlignMode.CENTER) {
					tx += (x - outerBounds.x) + ((width - outerBounds.width) * 0.5);
				} else if (item.hAlign == AlignMode.RIGHT) {
					tx += (x - outerBounds.x) + (width - outerBounds.width);
				}
				
				if (item.vAlign == AlignMode.TOP) {
					ty += (y - outerBounds.y);
				} else if (item.vAlign == AlignMode.CENTER) {
					ty += (y - outerBounds.y) + ((height - outerBounds.height) * 0.5);
				} else if (item.vAlign == AlignMode.BOTTOM) {
					ty += (y - outerBounds.y) + (height - outerBounds.height);
				}
				
				if (item.roundPosition) {
					tx = (tx + 0.5) >> 0; //much faster than Math.round()
					ty = (ty + 0.5) >> 0;
				}
				
				target.x = tx;
				target.y = ty;
				
				if (item.mask) {
					item.mask.transform.matrix = matrix;
				}
				
				item = item.next;
			}
			
			if (_hasListener) {
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		
		public function enableTweenMode():void {
			_tweenMode = true;
		}
		
		
		public function disableTweenMode():void {
			_tweenMode = false;
		}
		
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_hasListener = true;
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		
		public function destroy():void {
			if (_preview) {
				this.preview = false;
			}
			var nxt:AutoFitItem;
			var item:AutoFitItem = _rootItem;
			while (item) {
				nxt = item.next;
				release(item.target);
				item = nxt;
			}
			if (_bd != null) {
				_bd.dispose();
				_bd = null;
			}
			_parent = null;
		}
		
		
		protected static function getVisibleBounds(target:DisplayObject, targetCoordinateSpace:DisplayObject):Rectangle {
			if (_bd == null) {
				_bd = new BitmapData(2800, 2800, true, 0x00FFFFFF);
			}
			var msk:DisplayObject = target.mask;
			target.mask = null;
			_bd.fillRect(_rect, 0x00FFFFFF);
			_matrix.tx = _matrix.ty = 0;
			var offset:Rectangle = target.getBounds(targetCoordinateSpace);
			var m:Matrix = (targetCoordinateSpace == target) ? _matrix : target.transform.matrix;
			m.tx -= offset.x;
			m.ty -= offset.y;
			_bd.draw(target, m, null, "normal", _rect, false);
			var bounds:Rectangle = _bd.getColorBoundsRect(0xFF000000, 0x00000000, false);
			bounds.x += offset.x;
			bounds.y += offset.y;
			target.mask = msk;
			return bounds;
		}
		
		
		protected function _redraw(color:uint):void {
			_previewColor = color;
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(_previewColor, 1);
			g.drawRect(0, 0, _width, _height);
			g.endFill();
		}
		
//---- GETTERS / SETTERS ---------------------------------------------------------------------------
		
		
		override public function set x(value:Number):void {
			super.x = value;
			if (!_tweenMode) {
				update();
			}
		}
		
		
		override public function set y(value:Number):void {
			super.y = value;
			if (!_tweenMode) {
				update();
			}
		}
		
		
		override public function set width(value:Number):void {
			super.width = value;
			if (!_tweenMode) {
				update();
			}
		}
		
		
		override public function set height(value:Number):void {
			super.height = value;
			if (!_tweenMode) {
				update();
			}
		}
		
		
		override public function set scaleX(value:Number):void {
			super.scaleX = value;
			update();
		}
		
		
		override public function set scaleY(value:Number):void {
			super.scaleY = value;
			update();
		}
		
		
		override public function set rotation(value:Number):void {
			trace("Warning: AutoFitArea instances should not be rotated.");
		}
		
		
		public function get previewColor():uint {
			return _previewColor;
		}
		public function set previewColor(value:uint):void {
			_redraw(value);
		}
		
		
		public function get preview():Boolean {
			return _preview;
		}
		public function set preview(value:Boolean):void {
			_preview = value;
			if (this.parent == _parent) {
				_parent.removeChild(this);
			}
			if (value) {
				var level:uint = (_rootItem == null) ? 0 : 999999999;
				var index:uint;
				var item:AutoFitItem = _rootItem;
				while (item) {
					if (item.target.parent == _parent) {
						index = _parent.getChildIndex(item.target);
						if (index < level) {
							level = index;
						}
					}
					item = item.next;
				}
				_parent.addChildAt(this, level);
				this.visible = true;
			}
		}
		
	}
}

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Rectangle;

internal class AutoFitItem {
	public var target:DisplayObject;
	public var scaleMode:String;
	public var hAlign:String;
	public var vAlign:String;
	public var minWidth:Number;
	public var maxWidth:Number;
	public var minHeight:Number;
	public var maxHeight:Number;
	public var aspectRatio:Number;
	public var mask:Shape;
	public var matrix:Matrix;
	public var hasCustomRatio:Boolean;
	public var roundPosition:Boolean;
	
	public var next:AutoFitItem;
	public var prev:AutoFitItem;
	
	public var calculateVisible:Boolean;
	public var boundsTarget:DisplayObject;
	public var bounds:Rectangle;
	public var hasDrawNow:Boolean;
	
	
	public function AutoFitItem(target:DisplayObject, vars:Object, next:AutoFitItem) {
		this.target = target;
		if (vars == null) {
			vars = {};
		}
		this.scaleMode = 	vars.scaleMode || "proportionalInside";
		this.hAlign = 		vars.hAlign || "center";
		this.vAlign = 		vars.vAlign || "center";
		this.minWidth = 	Number(vars.minWidth) || 0;
		this.maxWidth = 	isNaN(vars.maxWidth) ? 999999999 : Number(vars.maxWidth);
		this.minHeight = 	Number(vars.minHeight) || 0;
		this.maxHeight = 	isNaN(vars.maxHeight) ? 999999999 : Number(vars.maxHeight);
		this.roundPosition = Boolean(vars.roundPosition);
		this.boundsTarget = (vars.customBoundsTarget is DisplayObject) ? vars.customBoundsTarget : this.target;
		this.matrix = target.transform.matrix;
		this.calculateVisible = Boolean(vars.calculateVisible);
		this.hasDrawNow = this.target.hasOwnProperty("drawNow");
		if (this.hasDrawNow) {
			Object(this.target).drawNow(); //just to make sure we're starting with the correct values if it's a component.
		}
		if (!isNaN(vars.customAspectRatio)) {
			this.aspectRatio = vars.customAspectRatio;
			this.hasCustomRatio = true;
		}
		if (next) {
			next.prev = this;
			this.next = next;
		}
	}
	
	
	public function setVisibleWidth(value:Number):void {
		var m:Matrix = this.target.transform.matrix;
		if ((m.a == 0 && m.c == 0) || (m.d == 0 && m.b == 0)) {
			m.a = this.matrix.a;
			m.c = this.matrix.c;
		}
		var curWidth:Number = (m.a < 0) ? -m.a * this.bounds.width : m.a * this.bounds.width;
		curWidth += (m.c < 0) ? -m.c * this.bounds.height : m.c * this.bounds.height;
		if (curWidth != 0) {
			var scale:Number = value / curWidth;
			m.a *= scale;
			m.c *= scale;
			this.target.transform.matrix = m;
			if (value != 0) {
				this.matrix = m;
			}
		}
	}
	
	
	public function setVisibleHeight(value:Number):void {
		var m:Matrix = this.target.transform.matrix;
		if ((m.a == 0 && m.c == 0) || (m.d == 0 && m.b == 0)) {
			m.b = this.matrix.b;
			m.d = this.matrix.d;
		}
		var curHeight:Number = (m.b < 0) ? -m.b * this.bounds.width : m.b * this.bounds.width;
		curHeight += (m.d < 0) ? -m.d * this.bounds.height : m.d * this.bounds.height;
		if (curHeight != 0) {
			var scale:Number = value / curHeight;
			m.b *= scale;
			m.d *= scale;
			this.target.transform.matrix = m;
			if (value != 0) {
				this.matrix = m;
			}
		}
	}
	
	
	public function scaleVisibleWidth(value:Number):void {
		var m:Matrix = this.target.transform.matrix;
		m.a *= value;
		m.c *= value;
		this.target.transform.matrix = m;
		if (value != 0) {
			this.matrix = m;
		}
	}
	
	
	public function scaleVisibleHeight(value:Number):void {
		var m:Matrix = this.target.transform.matrix;
		m.b *= value;
		m.d *= value;
		this.target.transform.matrix = m;
		if (value != 0) {
			this.matrix = m;
		}
	}
	
}