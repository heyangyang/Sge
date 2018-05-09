
package com.sunny.game.engine.transition.tween.plugins
{
	import com.sunny.game.engine.ns.sunny_tween;
	import com.sunny.game.engine.transition.tween.STweenLite;
	import com.sunny.game.engine.transition.tween.props.SBezierProps;
	import com.sunny.game.engine.transition.tween.props.STweenProps;

	import flash.geom.Point;

	use namespace sunny_tween;

	
	
	
	
	public class SBezierPlugin extends STweenPlugin
	{
		
		public static const API : Number = 1.0;
		
		protected static const _RAD2DEG : Number = 180 / Math.PI;
		
		protected var _target : Object;
		
		protected var _orientData : Array;
		
		protected var _orient : Boolean;
		
		protected var _future : Object = {};
		
		protected var _beziers : Object;

		
		public function SBezierPlugin()
		{
			super();
			this.propName = "bezier";
			this.overwriteProps = [];
		}

		
		override public function setup(target : Object) : Boolean
		{
			if (!(_value is SBezierProps))
			{
				return false;
			}
			init(target as STweenLite, _value as SBezierProps);
			return true;
		}

		
		protected function init(tween : STweenLite, beziers : SBezierProps) : void
		{
			_target = tween.target;
			var enumerables : Object = (tween.tweenProps.isTV == true) ? tween.tweenProps.exposedVars : tween.tweenProps; //for TweenLiteVars and TweenMaxVars (we need an object with enumerable properties);
			if (enumerables.orientToBezier == true)
			{
				_orientData = [["x", "y", "rotation", 0, 0.01]];
				_orient = true;
			}
			else if (enumerables.orientToBezier is Array)
			{
				_orientData = enumerables.orientToBezier;
				_orient = true;
			}
			var props : Object = {}, i : int, p : String, killVarsLookup : STweenProps;
			var beziersLen : int = beziers.curvePoints.length;
			for (i = 0; i < beziersLen; i += 1)
			{
				var point : Point = beziers.curvePoints[i];
				p = "x";
				if (props[p] == undefined)
				{
					props[p] = [tween.target[p]];
				}
				if (typeof(point[p]) == "number")
				{
					props[p].push(point[p]);
				}
				else
				{
					props[p].push(tween.target[p] + Number(point[p])); //relative value
				}

				p = "y";
				if (props[p] == undefined)
				{
					props[p] = [tween.target[p]];
				}
				if (typeof(point[p]) == "number")
				{
					props[p].push(point[p]);
				}
				else
				{
					props[p].push(tween.target[p] + Number(point[p])); //relative value
				}
			}
			for (p in props)
			{
				this.overwriteProps[this.overwriteProps.length] = p;
				if (enumerables[p] != undefined)
				{
					if (typeof(enumerables[p]) == "number")
					{
						props[p].push(enumerables[p]);
					}
					else
					{
						props[p].push(tween.target[p] + Number(enumerables[p])); //relative value
					}
					killVarsLookup = new STweenProps();
					killVarsLookup[p] = true;
					tween.clearProps(killVarsLookup, false);
					delete enumerables[p]; //in case TweenLite/Max hasn't reached the enumerable yet in its init() function. This prevents normal tweens from getting created for the properties that should be controled with the BezierPlugin.
				}
			}
			_beziers = parseBeziers(props, beziers.through);
		}

		
		public static function parseBeziers(props : Object, through : Boolean = false) : Object
		{
			var i : int, a : Array, b : Object, p : String;
			var all : Object = {};
			if (through)
			{
				for (p in props)
				{
					a = props[p];
					all[p] = b = [];
					if (a.length > 2)
					{
						b[b.length] = [a[0], a[1] - ((a[2] - a[0]) / 4), a[1]];
						for (i = 1; i < a.length - 1; i += 1)
						{
							b[b.length] = [a[i], a[i] + (a[i] - b[i - 1][1]), a[i + 1]];
						}
					}
					else
					{
						b[b.length] = [a[0], (a[0] + a[1]) / 2, a[1]];
					}
				}
			}
			else
			{
				for (p in props)
				{
					a = props[p];
					all[p] = b = [];
					if (a.length > 3)
					{
						b[b.length] = [a[0], a[1], (a[1] + a[2]) / 2];
						for (i = 2; i < a.length - 2; i += 1)
						{
							b[b.length] = [b[i - 2][2], a[i], (a[i] + a[i + 1]) / 2];
						}
						b[b.length] = [b[b.length - 1][2], a[a.length - 2], a[a.length - 1]];
					}
					else if (a.length == 3)
					{
						b[b.length] = [a[0], a[1], a[2]];
					}
					else if (a.length == 2)
					{
						b[b.length] = [a[0], (a[0] + a[1]) / 2, a[1]];
					}
				}
			}
			return all;
		}

		
		override public function killProps(lookup : Object) : void
		{
			for (var p : String in _beziers)
			{
				if (p in lookup)
				{
					delete _beziers[p];
				}
			}
			super.killProps(lookup);
		}

		
		override public function set changeFactor(n : Number) : void
		{
			var i : int, p : String, b : Object, t : Number, segments : int, val : Number;
			_changeFactor = n;
			if (n == 1)
			{
				for (p in _beziers)
				{
					i = _beziers[p].length - 1;
					_target[p] = _beziers[p][i][2];
				}
			}
			else
			{
				for (p in _beziers)
				{
					segments = _beziers[p].length;
					if (n < 0)
					{
						i = 0;
					}
					else if (n >= 1)
					{
						i = segments - 1;
					}
					else
					{
						i = (segments * n) >> 0;
					}
					t = (n - (i * (1 / segments))) * segments;
					b = _beziers[p][i];
					if (this.round)
					{
						val = b[0] + t * (2 * (1 - t) * (b[1] - b[0]) + t * (b[2] - b[0]));
						if (val > 0)
						{
							_target[p] = (val + 0.5) >> 0; //4 times as fast as Math.round()
						}
						else
						{
							_target[p] = (val - 0.5) >> 0;
						}
					}
					else
					{
						_target[p] = b[0] + t * (2 * (1 - t) * (b[1] - b[0]) + t * (b[2] - b[0]));
					}
				}
			}

			if (_orient)
			{
				i = _orientData.length;
				var curVals : Object = {}, dx : Number, dy : Number, cotb : Array, toAdd : Number;
				while (i--)
				{
					cotb = _orientData[i]; //current orientToBezier Array
					curVals[cotb[0]] = _target[cotb[0]];
					curVals[cotb[1]] = _target[cotb[1]];
				}

				var oldTarget : Object = _target, oldRound : Boolean = this.round;
				_target = _future;
				this.round = false;
				_orient = false;
				i = _orientData.length;
				while (i--)
				{
					cotb = _orientData[i]; //current orientToBezier Array
					this.changeFactor = n + (cotb[4] || 0.01);
					toAdd = cotb[3] || 0;
					dx = _future[cotb[0]] - curVals[cotb[0]];
					dy = _future[cotb[1]] - curVals[cotb[1]];
					oldTarget[cotb[2]] = Math.atan2(dy, dx) * _RAD2DEG + toAdd;
				}
				_target = oldTarget;
				this.round = oldRound;
				_orient = true;
			}
		}
	}
}