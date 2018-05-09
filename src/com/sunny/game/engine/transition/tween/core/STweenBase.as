package com.sunny.game.engine.transition.tween.core
{
	import com.sunny.game.engine.transition.tween.props.STweenProps;
	import com.sunny.game.engine.transition.tween.STweenLite;

	
	public class STweenBase
	{
		
		public static const version : Number = 1.693;

		
		protected static var _classInitted : Boolean;

		
		protected var _delay : Number;
		
		protected var _hasUpdate : Boolean;
		
		protected var _rawPrevTime : Number = -1;

		
		public var tweenProps : STweenProps;
		
		public var active : Boolean;
		
		public var gc : Boolean;
		
		public var initted : Boolean;
		
		public var timeline : SSimpleTimeline;
		
		public var cachedStartTime : Number;
		
		public var cachedTime : Number;
		
		public var cachedTotalTime : Number;
		
		public var cachedDuration : Number;
		
		public var cachedTotalDuration : Number;
		
		public var cachedTimeScale : Number;
		
		public var cachedPauseTime : Number;
		
		public var cachedReversed : Boolean;
		
		public var nextNode : STweenBase;
		
		public var prevNode : STweenBase;
		
		public var cachedOrphan : Boolean;
		
		public var cacheIsDirty : Boolean;
		
		public var cachedPaused : Boolean;
		
		public var data : *;

		public function STweenBase(duration : Number = 0, tweenProps : STweenProps = null)
		{
			this.tweenProps = (tweenProps != null) ? tweenProps : new STweenProps();
			if (this.tweenProps.isGSVars)
			{
				this.tweenProps = this.tweenProps.vars;
			}
			this.cachedDuration = this.cachedTotalDuration = duration / 1000;
			_delay = (this.tweenProps.delay) ? Number(this.tweenProps.delay) : 0;
			this.cachedTimeScale = (this.tweenProps.timeScale) ? Number(this.tweenProps.timeScale) : 1;
			this.active = Boolean(duration == 0 && _delay == 0 && this.tweenProps.immediateRender != false);
			this.cachedTotalTime = this.cachedTime = 0;
			this.data = this.tweenProps.data;

			if (!_classInitted)
			{
				if (isNaN(STweenLite.rootFrame))
				{
					STweenLite.initClass();
					_classInitted = true;
				}
				else
				{
					return;
				}
			}

			var tl : SSimpleTimeline = (this.tweenProps.timeline is SSimpleTimeline) ? this.tweenProps.timeline : (this.tweenProps.useFrames) ? STweenLite.rootFramesTimeline : STweenLite.rootTimeline;
			tl.insert(this, tl.cachedTotalTime);
			if (this.tweenProps.reversed)
			{
				this.cachedReversed = true;
			}
			if (this.tweenProps.paused)
			{
				this.paused = true;
			}
		}

		
		public function play() : void
		{
			this.reversed = false;
			this.paused = false;
		}

		
		public function pause() : void
		{
			this.paused = true;
		}

		
		public function resume() : void
		{
			this.paused = false;
		}

		
		public function restart(includeDelay : Boolean = false, suppressEvents : Boolean = true) : void
		{
			this.reversed = false;
			this.paused = false;
			this.setTotalTime((includeDelay) ? -_delay : 0, suppressEvents);
		}

		
		public function reverse(forceResume : Boolean = true) : void
		{
			this.reversed = true;
			if (forceResume)
			{
				this.paused = false;
			}
			else if (this.gc)
			{
				this.setEnabled(true, false);
			}
		}

		
		public function renderTime(time : Number, suppressEvents : Boolean = false, force : Boolean = false) : void
		{

		}

		
		public function complete(skipRender : Boolean = false, suppressEvents : Boolean = false) : void
		{
			if (!skipRender)
			{
				renderTime(this.totalDuration, suppressEvents, false); //just to force the final render
				return; //renderTime() will call complete() again, so just return here.
			}
			if (this.timeline.autoRemoveChildren)
			{
				this.setEnabled(false, false);
			}
			else
			{
				this.active = false;
			}
			if (!suppressEvents)
			{
				if (this.tweenProps.onComplete && this.cachedTotalTime >= this.cachedTotalDuration && !this.cachedReversed)
				{ //note: remember that tweens can have a duration of zero in which case their cachedTime and cachedDuration would always match. Also, TimelineLite/Max instances with autoRemoveChildren may have a cachedTotalTime that exceeds cachedTotalDuration because the children were removed after the last render.
					this.tweenProps.onComplete.apply(null, this.tweenProps.onCompleteParams);
				}
				else if (this.cachedReversed && this.cachedTotalTime == 0 && this.tweenProps.onReverseComplete)
				{
					this.tweenProps.onReverseComplete.apply(null, this.tweenProps.onReverseCompleteParams);
				}
			}
		}

		
		public function invalidate() : void
		{

		}

		
		public function setEnabled(enabled : Boolean, ignoreTimeline : Boolean = false) : Boolean
		{
			this.gc = !enabled;
			if (enabled)
			{
				this.active = Boolean(!this.cachedPaused && this.cachedTotalTime > 0 && this.cachedTotalTime < this.cachedTotalDuration);
				if (!ignoreTimeline && this.cachedOrphan)
				{
					this.timeline.insert(this, this.cachedStartTime - _delay);
				}
			}
			else
			{
				this.active = false;
				if (!ignoreTimeline && !this.cachedOrphan)
				{
					this.timeline.remove(this, true);
				}
			}
			return false;
		}

		
		public function kill() : void
		{
			setEnabled(false, false);
		}

		
		protected function setDirtyCache(includeSelf : Boolean = true) : void
		{
			var tween : STweenBase = (includeSelf) ? this : this.timeline;
			while (tween)
			{
				tween.cacheIsDirty = true;
				tween = tween.timeline;
			}
		}

		
		protected function setTotalTime(time : Number, suppressEvents : Boolean = false) : void
		{
			if (this.timeline)
			{
				var tlTime : Number = (this.cachedPaused) ? this.cachedPauseTime : this.timeline.cachedTotalTime;
				if (this.cachedReversed)
				{
					var dur : Number = (this.cacheIsDirty) ? this.totalDuration : this.cachedTotalDuration;
					this.cachedStartTime = tlTime - ((dur - time) / this.cachedTimeScale);
				}
				else
				{
					this.cachedStartTime = tlTime - (time / this.cachedTimeScale);
				}
				if (!this.timeline.cacheIsDirty)
				{ //for performance improvement. If the parent's cache is already dirty, it already took care of marking the anscestors as dirty too, so skip the function call here.
					setDirtyCache(false);
				}
				if (this.cachedTotalTime != time)
				{
					renderTime(time, suppressEvents, false);
				}
			}
		}


//---- GETTERS / SETTERS ------------------------------------------------------------

		
		public function get delay() : Number
		{
			return _delay;
		}

		public function set delay(n : Number) : void
		{
			this.startTime += n - _delay;
			_delay = n;
		}

		
		public function get duration() : Number
		{
			return this.cachedDuration;
		}

		public function set duration(n : Number) : void
		{
			var ratio : Number = n / this.cachedDuration;
			this.cachedDuration = this.cachedTotalDuration = n;
			setDirtyCache(true); //true in case it's a TweenMax or TimelineMax that has a repeat - we'll need to refresh the totalDuration. 
			if (this.active && !this.cachedPaused && n != 0)
			{
				this.setTotalTime(this.cachedTotalTime * ratio, true);
			}
		}

		
		public function get totalDuration() : Number
		{
			return this.cachedTotalDuration;
		}

		public function set totalDuration(n : Number) : void
		{
			this.duration = n;
		}

		
		public function get currentTime() : Number
		{
			return this.cachedTime;
		}

		public function set currentTime(n : Number) : void
		{
			setTotalTime(n, false);
		}

		
		public function get totalTime() : Number
		{
			return this.cachedTotalTime;
		}

		public function set totalTime(n : Number) : void
		{
			setTotalTime(n, false);
		}

		
		public function get startTime() : Number
		{
			return this.cachedStartTime;
		}

		public function set startTime(n : Number) : void
		{
			if (this.timeline != null && (n != this.cachedStartTime || this.gc))
			{
				this.timeline.insert(this, n - _delay); //ensures that any necessary re-sequencing of TweenCores in the timeline occurs to make sure the rendering order is correct.
			}
			else
			{
				this.cachedStartTime = n;
			}
		}

		
		public function get reversed() : Boolean
		{
			return this.cachedReversed;
		}

		public function set reversed(b : Boolean) : void
		{
			if (b != this.cachedReversed)
			{
				this.cachedReversed = b;
				setTotalTime(this.cachedTotalTime, true);
			}
		}

		
		public function get paused() : Boolean
		{
			return this.cachedPaused;
		}

		public function set paused(b : Boolean) : void
		{
			if (b != this.cachedPaused && this.timeline)
			{
				if (b)
				{
					this.cachedPauseTime = this.timeline.rawTime;
				}
				else
				{
					this.cachedStartTime += this.timeline.rawTime - this.cachedPauseTime;
					this.cachedPauseTime = NaN;
					setDirtyCache(false);
				}
				this.cachedPaused = b;
				this.active = Boolean(!this.cachedPaused && this.cachedTotalTime > 0 && this.cachedTotalTime < this.cachedTotalDuration);
			}
			if (!b && this.gc)
			{
				this.setEnabled(true, false);
			}
		}

	}
}