package com.sunny.game.engine.utils
{
	import flash.display.Stage;
	import flash.utils.getTimer;

	public class SFrameSkipping
	{
		private var lastTimer : int;
		private var deadLine : int;
		private var minContiguousFrames : int;
		private var maxContiguousSkips : int;
		private var _framesRendered : int;
		private var _framesSkipped : int;

		/**
		 * 一种模仿PCSX2的跳帧策略
		 * @param deadLineRate 当两次调用之间时差高于标准值多少开始跳帧，推荐1.2以上
		 * @param minContiguousFrames  进行跳帧前最少连续渲染了多少帧，推荐1以上
		 * @param maxContiguousSkips  最多可以连续跳过的帧数，推荐1
		 *
		 */
		public function SFrameSkipping(stage : Stage, deadLineRate : Number = 1.20, minContiguousFrames : int = 1, maxContiguousSkips : int = 1)
		{
			super();
			this.lastTimer = 0;
			this.deadLine = Math.ceil((1000 / stage.frameRate) * deadLineRate);
			this.minContiguousFrames = minContiguousFrames;
			this.maxContiguousSkips = maxContiguousSkips;
			_framesRendered = 0;
			_framesSkipped = 0;
		}

		public function requestFrameSkip() : Boolean
		{
			var rt : Boolean = false;
			var timer : int = getTimer();
			var dtTimer : int = timer - lastTimer;
			if (dtTimer > deadLine && _framesRendered >= minContiguousFrames && _framesSkipped < maxContiguousSkips)
			{
				//如果满足一系列条件才能批准跳帧
				rt = true;
				_framesRendered = 0;
				_framesSkipped += 1;
			}
			else
			{
				_framesSkipped = 0;
				_framesRendered += 1;
			}
			lastTimer = timer;
			return rt;
		}

		public function get framesRendered() : int
		{
			return _framesRendered;
		}

		public function get framesSkipped() : int
		{
			return _framesSkipped;
		}
	}
}