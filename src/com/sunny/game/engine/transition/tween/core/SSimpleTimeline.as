package com.sunny.game.engine.transition.tween.core
{
	import com.sunny.game.engine.transition.tween.props.STweenProps;

	
	public class SSimpleTimeline extends STweenBase
	{
		
		protected var _firstChild : STweenBase;
		
		protected var _lastChild : STweenBase;
		
		public var autoRemoveChildren : Boolean;

		public function SSimpleTimeline(tweenProps : STweenProps = null)
		{
			super(0, tweenProps);
		}

		
		public function insert(tween : STweenBase, time : * = 0) : STweenBase
		{
			var prevTimeline : SSimpleTimeline = tween.timeline;
			if (!tween.cachedOrphan && prevTimeline)
			{
				prevTimeline.remove(tween, true);
			}
			tween.timeline = this;
			tween.cachedStartTime = Number(time) + tween.delay;
			if (tween.gc)
			{
				tween.setEnabled(true, true);
			}
			if (tween.cachedPaused && prevTimeline != this)
			{
				tween.cachedPauseTime = tween.cachedStartTime + ((this.rawTime - tween.cachedStartTime) / tween.cachedTimeScale);
			}
			if (_lastChild)
			{
				_lastChild.nextNode = tween;
			}
			else
			{
				_firstChild = tween;
			}
			tween.prevNode = _lastChild;
			_lastChild = tween;
			tween.nextNode = null;
			tween.cachedOrphan = false;
			return tween;
		}

		
		public function remove(tween : STweenBase, skipDisable : Boolean = false) : void
		{
			if (tween.cachedOrphan)
			{
				return;
			}
			else if (!skipDisable)
			{
				tween.setEnabled(false, true);
			}

			if (tween.nextNode)
			{
				tween.nextNode.prevNode = tween.prevNode;
			}
			else if (_lastChild == tween)
			{
				_lastChild = tween.prevNode;
			}
			if (tween.prevNode)
			{
				tween.prevNode.nextNode = tween.nextNode;
			}
			else if (_firstChild == tween)
			{
				_firstChild = tween.nextNode;
			}
			tween.cachedOrphan = true;
		}
		
		override public function renderTime(time : Number, suppressEvents : Boolean = false, force : Boolean = false) : void
		{
			var tween : STweenBase = _firstChild, dur : Number, next : STweenBase;
			this.cachedTotalTime = time;
			this.cachedTime = time;

			while (tween)
			{
				next = tween.nextNode;
				if (tween.active || (time >= tween.cachedStartTime && !tween.cachedPaused && !tween.gc))
				{
					if (!tween.cachedReversed)
					{
						tween.renderTime((time - tween.cachedStartTime) * tween.cachedTimeScale, suppressEvents, false);
					}
					else
					{
						dur = (tween.cacheIsDirty) ? tween.totalDuration : tween.cachedTotalDuration;
						tween.renderTime(dur - ((time - tween.cachedStartTime) * tween.cachedTimeScale), suppressEvents, false);
					}
				}
				tween = next;
			}
		}

		public function get rawTime() : Number
		{
			return this.cachedTotalTime;
		}

	}
}