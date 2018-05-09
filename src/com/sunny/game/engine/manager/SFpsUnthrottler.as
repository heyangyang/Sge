package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.core.SUpdatable;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.events.SEvent;

	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.getTimer;

	/**
	 * 節流限制 (Throttle Mode)
	 * 利用 Sound SampleData 事件
	 * 迫使 Flash Player 背景執行時，仍以指定 FPS 運作
	 *
	 * 使用方式
	 *
	 * 1. 建立 FPSUnthrottler 實體，直接呼叫 activate 啟動
	 *
	 * 或是
	 *
	 * 2. 將 FPSUnthrottler 實體加入到 DisplayList
	 *   它會自動偵測目標 FPS 與實際 FPS，決定啟動或是停止
	 *
	 * 设置fp在浏览器中最小化时休眠模式的帧频
	 */
	internal class SFpsUnthrottler extends SUpdatable
	{
		private var recentFrameTimes : Array = [];
		private var snd : Sound;
		private var sndCh : SoundChannel;

		public function SFpsUnthrottler()
		{
			super();
			SShellVariables.nativeStage.addEventListener(Event.ACTIVATE, onStageActivate);
			SShellVariables.nativeStage.addEventListener(Event.DEACTIVATE, onStageDeactivate);
		}

		/**
		 * 开启强制保持原本设定的FPS
		 * */
		private function startPlay() : void
		{
			if (sndCh)
				return;
			if (!snd)
				snd = new Sound();
			snd.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataHandler, false, 0, true);
			sndCh = snd.play();
		}

		private function onSampleDataHandler(event : SampleDataEvent) : void
		{
			event.data.position = event.data.length = 4096 * 4;
		}

		/**
		 * 停止设置强制模式，进入休眠状态
		 * */
		private function stopPlay() : void
		{
			if (!sndCh)
				return;
			if (snd)
				snd.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataHandler);
			if (sndCh)
			{
				sndCh.stop();
				sndCh = null;
			}
		}

		override public function update() : void
		{
			super.update();
			var throttleFrameTime : int = 100;
			var targetFrameTime : int = 1000 / SShellVariables.frameRate;

			// 原本設定的 FPS 就已經低於 Throttle FPS 了
			if (targetFrameTime > throttleFrameTime - 20)
			{
				activate();
				return;
			}

			var currTime : int = getTimer();
			var lastFrameTime : int = currTime - recentFrameTimes[0];

			recentFrameTimes.unshift(currTime);
			var maxSampleLen : int = 300;
			var sampleLen : int = recentFrameTimes.length = Math.min(recentFrameTimes.length, maxSampleLen);
			var avgFrameTimeTotal : int = (recentFrameTimes[0] - recentFrameTimes[sampleLen - 1]) / sampleLen;

			//trace("FrameTimes:", targetFrameTime, lastFrameTime, avgFrameTimeTotal);

			if (lastFrameTime > throttleFrameTime)
			{
				// 最後一次影格事件突然小於 2 FPS
				deactivate();
			}
			else if (avgFrameTimeTotal <= targetFrameTime)
			{
				// 連續平均影格事件 FPS 小於等於目標 FPS
				activate();
			}
		}

		private function activate() : void
		{
			stopPlay();
		}

		private function deactivate() : void
		{
			startPlay();
		}

		private function onStageActivate(e : Event) : void
		{
			e.stopImmediatePropagation();
			activate();
			if (SShellVariables.stageIsActive)
				return;
			// restore original frame rate 
			SShellVariables.stageIsActive = true;
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, '屏幕激活, frameRate:', SShellVariables.nativeStage.frameRate);
			SEvent.dispatchEvent(SEvent.ACTIVATE);
		}

		private function onStageDeactivate(e : Event) : void
		{
			e.stopImmediatePropagation();
			deactivate();
			if (!SShellVariables.stageIsActive)
				return;
			// set frame rate to 0 
			SShellVariables.stageIsActive = false;
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, '屏幕休眠, frameRate:', SShellVariables.nativeStage.frameRate);
			SEvent.dispatchEvent(SEvent.DEACTIVATE);
		}
	}
}