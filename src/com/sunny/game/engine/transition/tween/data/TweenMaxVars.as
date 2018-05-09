package com.sunny.game.engine.transition.tween.data
{
	import flash.display.Stage;
	import flash.geom.Point;

	
	public class TweenMaxVars
	{
		
		public static const version : Number = 5.2;

		
		protected var _vars : Object;

		
		public function TweenMaxVars(vars : Object = null)
		{
			_vars = {};
			if (vars != null)
			{
				for (var p : String in vars)
				{
					_vars[p] = vars[p];
				}
			}
		}

		
		protected function _set(property : String, value : *, requirePlugin : Boolean = false) : TweenMaxVars
		{
			if (value == null)
			{
				delete _vars[property]; //in case it was previously set
			}
			else
			{
				_vars[property] = value;
			}
			return this;
		}

		
		public function prop(property : String, value : Number, relative : Boolean = false) : TweenMaxVars
		{
			return _set(property, (relative) ? String(value) : value);
		}

		
		public function data(data : *) : TweenMaxVars
		{
			return _set("data", data);
		}

		
		public function delay(delay : Number) : TweenMaxVars
		{
			return _set("delay", delay);
		}

		
		public function ease(ease : Function, easeParams : Array = null) : TweenMaxVars
		{
			_set("easeParams", easeParams);
			return _set("ease", ease);
		}

		
		public function immediateRender(value : Boolean) : TweenMaxVars
		{
			return _set("immediateRender", value, false);
		}

		
		public function onComplete(func : Function, params : Array = null) : TweenMaxVars
		{
			_set("onCompleteParams", params);
			return _set("onComplete", func);
		}

		
		public function onCompleteListener(func : Function) : TweenMaxVars
		{
			return _set("onCompleteListener", func);
		}

		
		public function onInit(func : Function, params : Array = null) : TweenMaxVars
		{
			_set("onInitParams", params);
			return _set("onInit", func);
		}

		
		public function onStart(func : Function, params : Array = null) : TweenMaxVars
		{
			_set("onStartParams", params);
			return _set("onStart", func);
		}

		
		public function onStartListener(func : Function) : TweenMaxVars
		{
			return _set("onStartListener", func)
		}

		
		public function onUpdate(func : Function, params : Array = null) : TweenMaxVars
		{
			_set("onUpdateParams", params);
			return _set("onUpdate", func);
		}

		
		public function onUpdateListener(func : Function) : TweenMaxVars
		{
			return _set("onUpdateListener", func);
		}

		
		public function onRepeat(func : Function, params : Array = null) : TweenMaxVars
		{
			_set("onRepeatParams", params);
			return _set("onRepeat", func);
		}

		
		public function onReverseComplete(func : Function, params : Array = null) : TweenMaxVars
		{
			_set("onReverseCompleteParams", params);
			return _set("onReverseComplete", func);
		}

		
		public function onReverseCompleteListener(func : Function) : TweenMaxVars
		{
			return _set("onReverseCompleteListener", func);
		}

		
		public function overwriteType(value : int) : TweenMaxVars
		{
			return _set("overwriteType", value, false);
		}

		
		public function paused(value : Boolean) : TweenMaxVars
		{
			return _set("paused", value, false);
		}

		
		public function repeat(value : int) : TweenMaxVars
		{
			return _set("repeat", value);
		}

		
		public function repeatDelay(value : Number) : TweenMaxVars
		{
			return _set("repeatDelay", value);
		}

		
		public function reversed(value : Boolean) : TweenMaxVars
		{
			return _set("reversed", value);
		}

		
		public function runBackwards(value : Boolean) : TweenMaxVars
		{
			return _set("runBackwards", value, false);
		}

		
		public function timeScale(value : Number) : TweenMaxVars
		{
			return _set("timeScale", value, false);
		}

		
		public function useFrames(value : Boolean) : TweenMaxVars
		{
			return _set("useFrames", value, false);
		}

		
		public function startAt(vars : TweenMaxVars) : TweenMaxVars
		{
			return _set("startAt", vars.vars);
		}

		
		public function invert(value : Boolean) : TweenMaxVars
		{
			return _set("invert", value);
		}

		//---- COMMON CONVENIENCE PROPERTIES (NO PLUGIN REQUIRED) -------------------------------------------------------------------

		
		public function move(x : Number, y : Number, relative : Boolean = false) : TweenMaxVars
		{
			prop("x", x, relative);
			return prop("y", y, relative);
		}

		
		public function scale(value : Number, relative : Boolean = false) : TweenMaxVars
		{
			prop("scaleX", value, relative);
			return prop("scaleY", value, relative);
		}

		
		public function rotation(value : Number, relative : Boolean = false) : TweenMaxVars
		{
			return prop("rotation", value, relative);
		}

		
		public function scaleX(value : Number, relative : Boolean = false) : TweenMaxVars
		{
			return prop("scaleX", value, relative);
		}

		
		public function scaleY(value : Number, relative : Boolean = false) : TweenMaxVars
		{
			return prop("scaleY", value, relative);
		}

		
		public function width(value : Number, relative : Boolean = false) : TweenMaxVars
		{
			return prop("width", value, relative);
		}

		
		public function height(value : Number, relative : Boolean = false) : TweenMaxVars
		{
			return prop("height", value, relative);
		}

		
		public function x(value : Number, relative : Boolean = false) : TweenMaxVars
		{
			return prop("x", value, relative);
		}

		
		public function y(value : Number, relative : Boolean = false) : TweenMaxVars
		{
			return prop("y", value, relative);
		}

		public function autoAlpha(alpha : Number) : TweenMaxVars
		{
			return _set("autoAlpha", alpha, true);
		}

		
		public function bevelFilter(distance : Number = 4, angle : Number = 45, highlightColor : uint = 0xFFFFFF, highlightAlpha : Number = 0.5, shadowColor : uint = 0x000000, shadowAlpha : Number = 0.5, blurX : Number = 4, blurY : Number = 4, strength : Number = 1, quality : int = 2, remove : Boolean = false, addFilter : Boolean = false, index : int = -1) : TweenMaxVars
		{
			var filter : Object = {distance: distance, angle: angle, highlightColor: highlightColor, highlightAlpha: highlightAlpha, shadowColor: shadowColor, shadowAlpha: shadowAlpha, blurX: blurX, blurY: blurY, strength: strength, quality: quality, addFilter: addFilter, remove: remove};
			if (index > -1)
			{
				filter.index = index;
			}
			return _set("bevelFilter", filter, true);
		}

		
		public function bezier(values : Array) : TweenMaxVars
		{
			return _set("bezier", values, true);
		}

		
		public function bezierThrough(values : Array) : TweenMaxVars
		{
			return _set("bezierThrough", values, true);
		}

		
		public function blurFilter(blurX : Number, blurY : Number, quality : int = 2, remove : Boolean = false, addFilter : Boolean = false, index : int = -1) : TweenMaxVars
		{
			var filter : Object = {blurX: blurX, blurY: blurY, quality: quality, addFilter: addFilter, remove: remove};
			if (index > -1)
			{
				filter.index = index;
			}
			return _set("blurFilter", filter, true);
		}

		public function colorMatrixFilter(colorize : uint = 0xFFFFFF, amount : Number = 1, saturation : Number = 1, contrast : Number = 1, brightness : Number = 1, hue : Number = 0, threshold : Number = -1, remove : Boolean = false, addFilter : Boolean = false, index : int = -1) : TweenMaxVars
		{
			var filter : Object = {saturation: saturation, contrast: contrast, brightness: brightness, hue: hue, addFilter: addFilter, remove: remove};
			if (colorize != 0xFFFFFF)
			{
				filter.colorize = colorize;
				filter.amount = amount;
			}
			if (threshold > -1)
			{
				filter.threshold = threshold;
			}
			if (index > -1)
			{
				filter.index = index;
			}
			return _set("colorMatrixFilter", filter, true);
		}

		
		public function colorTransform(color : Number = NaN, tintAmount : Number = NaN, exposure : Number = NaN, brightness : Number = NaN, redMultiplier : Number = NaN, greenMultiplier : Number = NaN, blueMultiplier : Number = NaN, alphaMultiplier : Number = NaN, redOffset : Number = NaN, greenOffset : Number = NaN, blueOffset : Number = NaN, alphaOffset : Number = NaN) : TweenMaxVars
		{
			var values : Object = {color: color, tintAmount: isNaN(color) ? NaN : tintAmount, exposure: exposure, brightness: brightness, redMultiplier: redMultiplier, greenMultiplier: greenMultiplier, blueMultiplier: blueMultiplier, alphaMultiplier: alphaMultiplier, redOffset: redOffset, greenOffset: greenOffset, blueOffset: blueOffset, alphaOffset: alphaOffset};
			for (var p : String in values)
			{
				if (isNaN(values[p]))
				{
					delete values[p];
				}
			}
			return _set("colorTransform", values, true);
		}

		
		public function dropShadowFilter(distance : Number = 4, blurX : Number = 4, blurY : Number = 4, alpha : Number = 1, angle : Number = 45, color : uint = 0x000000, strength : Number = 2, inner : Boolean = false, knockout : Boolean = false, hideObject : Boolean = false, quality : uint = 2, remove : Boolean = false, addFilter : Boolean = false, index : int = -1) : TweenMaxVars
		{
			var filter : Object = {distance: distance, blurX: blurX, blurY: blurY, alpha: alpha, angle: angle, color: color, strength: strength, inner: inner, knockout: knockout, hideObject: hideObject, quality: quality, addFilter: addFilter, remove: remove};
			if (index > -1)
			{
				filter.index = index;
			}
			return _set("dropShadowFilter", filter, true);
		}

		
		public function dynamicProps(props : Object, params : Object = null) : TweenMaxVars
		{
			if (params != null)
			{
				props.params = params;
			}
			return _set("dynamicProps", props, true);
		}

		
		public function endArray(values : Array) : TweenMaxVars
		{
			return _set("endArray", values, true);
		}

		
		public function frame(value : int, relative : Boolean = false) : TweenMaxVars
		{
			return _set("frame", (relative) ? String(value) : value, true);
		}

		
		public function frameBackward(frame : int) : TweenMaxVars
		{
			return _set("frameBackward", frame, true);
		}

		
		public function frameForward(frame : int) : TweenMaxVars
		{
			return _set("frameForward", frame, true);
		}

		
		public function frameLabel(label : String) : TweenMaxVars
		{
			return _set("frameLabel", label, true);
		}


		
		public function glowFilter(blurX : Number = 10, blurY : Number = 10, color : uint = 0xFFFFFF, alpha : Number = 1, strength : Number = 2, inner : Boolean = false, knockout : Boolean = false, quality : uint = 2, remove : Boolean = false, addFilter : Boolean = false, index : int = -1) : TweenMaxVars
		{
			var filter : Object = {blurX: blurX, blurY: blurY, color: color, alpha: alpha, strength: strength, inner: inner, knockout: knockout, quality: quality, addFilter: addFilter, remove: remove};
			if (index > -1)
			{
				filter.index = index;
			}
			return _set("glowFilter", filter, true);
		}

		
		public function hexColors(values : Object) : TweenMaxVars
		{
			return _set("hexColors", values, true);
		}


		
		public function motionBlur(strength : Number = 1, fastMode : Boolean = false, quality : int = 2, padding : int = 10) : TweenMaxVars
		{
			return _set("motionBlur", {strength: strength, fastMode: fastMode, quality: quality, padding: padding}, true);
		}

		
		public function orientToBezier(values : Object = null) : TweenMaxVars
		{
			return _set("orientToBezier", (values == null) ? true : values, false);
		}


		
		public function physics2D(velocity : Number, angle : Number, acceleration : Number = 0, accelerationAngle : Number = 90, friction : Number = 0) : TweenMaxVars
		{
			return _set("physics2D", {velocity: velocity, angle: angle, acceleration: acceleration, accelerationAngle: accelerationAngle, friction: friction}, true);
		}

		
		public function physicsProps(values : Object) : TweenMaxVars
		{
			return _set("physicsProps", values, true);
		}

		
		public function quaternions(values : Object) : TweenMaxVars
		{
			return _set("quaternions", values, true);
		}

		
		public function removeColor(remove : Boolean = true) : TweenMaxVars
		{
			return _set("removeColor", remove, true);
		}

		
		public function roundProps(propertyNames : Array) : TweenMaxVars
		{
			return _set("roundProps", propertyNames, true);
		}

		
		public function scrollRect(props : Object) : TweenMaxVars
		{
			return _set("scrollRect", props, true);
		}

		
		public function setSize(width : Number = NaN, height : Number = NaN) : TweenMaxVars
		{
			var values : Object = {};
			if (!isNaN(width))
			{
				values.width = width;
			}
			if (!isNaN(height))
			{
				values.height = height;
			}
			return _set("setSize", values, true);
		}

		
		public function shortRotation(values : Object) : TweenMaxVars
		{
			if (typeof(values) == "number")
			{
				values = {rotation: values};
			}
			return _set("shortRotation", values, true);
		}


		
		public function soundTransform(volume : Number = 1, pan : Number = 0, leftToLeft : Number = 1, leftToRight : Number = 0, rightToLeft : Number = 0, rightToRight : Number = 1) : TweenMaxVars
		{
			return _set("soundTransform", {volume: volume, pan: pan, leftToLeft: leftToLeft, leftToRight: leftToRight, rightToLeft: rightToLeft, rightToRight: rightToRight}, true);
		}

		
		public function stageQuality(stage : Stage, during : String = "medium", after : String = null) : TweenMaxVars
		{
			if (after == null)
			{
				after = stage.quality;
			}
			return _set("stageQuality", {stage: stage, during: during, after: after}, true);
		}

		
		public function throwProps(props : Object) : TweenMaxVars
		{
			return _set("throwProps", props, true);
		}

		
		public function color(color : uint) : TweenMaxVars
		{
			return _set("color", color, true);
		}

		
		public function transformAroundCenter(props : Object) : TweenMaxVars
		{
			return _set("transformAroundCenter", props, true);
		}

		
		public function transformAroundPoint(point : Point, props : Object) : TweenMaxVars
		{
			props.point = point;
			return _set("transformAroundPoint", props, true);
		}

		
		public function transformMatrix(properties : Object) : TweenMaxVars
		{
			return _set("transformMatrix", properties, true);
		}

		
		public function visible(value : Boolean) : TweenMaxVars
		{
			return _set("visible", value, true);
		}

		
		public function volume(volume : Number) : TweenMaxVars
		{
			return _set("volume", volume, true);
		}

		public function get vars() : Object
		{
			return _vars;
		}

		
		public function get isGSVars() : Boolean
		{
			return true;
		}

	}
}