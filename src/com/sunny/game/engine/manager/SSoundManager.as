package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.cfg.SEngineConfig;
	import com.sunny.game.engine.core.SInjector;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.sound.SSoundController;
	import com.sunny.game.engine.transition.tween.props.SSoundTransformProps;
	import com.sunny.game.engine.transition.tween.props.SSoundTweenProps;
	import com.sunny.game.engine.utils.SCommonUtil;

	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 *
	 * <p>
	 * SunnyGame的一个声音管理器
	 * </p>
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public class SSoundManager
	{
		private static var _instance : SSoundManager;

		private var _backgroundSoundController : SSoundController;
		private var _effectSoundController : SSoundController;

		public static function getInstance() : SSoundManager
		{
			if (_instance == null)
				_instance = new SSoundManager();
			return _instance;
		}

		public function SSoundManager()
		{
			_backgroundSoundController = new SSoundController();
			_effectSoundController = new SSoundController();
		}

		/**
		 * 设置全局声音的大小
		 *
		 * @param volume	声音
		 * @param pan	声音位置，范围由-1到1
		 * @param len	变化需要的时间
		 */
		public function setGlobalVolume(volume : Number, len : Number = 0) : void
		{
			if (len == 0)
				SoundMixer.soundTransform = new SoundTransform(volume);
			else
			{
				var STween : Object = SInjector.hasMapping("STween") ? SInjector.getInstance("STween") : null;
				if (STween)
				{
					STween.clear(SoundMixer);
					var tweenProps : SSoundTweenProps = new SSoundTweenProps();
					tweenProps.soundTransform = new SSoundTransformProps();
					tweenProps.soundTransform.volume = volume;
					STween.to(SoundMixer, len, tweenProps);
				}
				else
				{
					SoundMixer.soundTransform = new SoundTransform(volume);
				}
			}
		}

		public function set backgroundSoundVolume(value : int) : void
		{
			_backgroundSoundController.defaultVolume = value * 0.01;
			_backgroundSoundController.setAllVolume(value * 0.01, 500);
		}

		public function set effectSoundVolume(value : int) : void
		{
			_effectSoundController.defaultVolume = value * 0.01;
			_effectSoundController.setAllVolume(value * 0.01, 500);
		}

		private var _isPaused : Boolean;

		/**
		 * 暂停所有播放
		 */
		public function pauseAll() : void
		{
			if (_isPaused)
				return;
			_isPaused = true;
			pauseBackgroundSound();
			stopEffectSounds();
		}

		/**
		 * 恢复所有播放
		 */
		public function resumeAll() : void
		{
			if (!_isPaused)
				return;
			_isPaused = false;
			resumeBackgroundSound();
			//_effectSoundController.resumeAll(500);
		}

		/**
		 * 关闭所有
		 */
//		public function clearAll() : void
//		{
//			if (_backgroundSoundController)
//				_backgroundSoundController.stopAll();
//			if (_effectSoundController)
//				_effectSoundController.stopAll();
//		}

		public function playBackgroundSounds(musics : String) : void
		{
			_backgroundSoundController.playSounds(musics);
//			if (SEngineConfig.backgroundSoundMuted)
//				_backgroundSoundController.pauseAll(500);
		}

		/**
		 * 播放特效声音
		 * @param soundId
		 * @param loops
		 * @param hearerX
		 * @param hearerY
		 * @param soundX
		 * @param soundY
		 * @param vol
		 *
		 */
		public function playEffectSound(soundId : String, loops : int = 1, hearerX : int = 0, hearerY : int = 0, soundX : int = 0, soundY : int = 0, vol : Number = 1) : void
		{
			if (SEngineConfig.effectSoundMuted)
				return;
			if (soundX || soundY || soundX || soundY)
			{
				hearerX = hearerX ? hearerX : SShellVariables.sceneWidth * 0.5;
				hearerY = hearerY ? hearerY : SShellVariables.sceneHeight * 0.5;

				soundX = soundX ? soundX : SShellVariables.sceneWidth * 0.5;
				soundY = soundY ? soundY : SShellVariables.sceneHeight * 0.5;

				var volume : Number = 0;
				if (vol == 1)
				{
					var distance : int = SCommonUtil.getDistance(hearerX, hearerY, soundX, soundY);
					var radius : int = SCommonUtil.getDistance(0, 0, SShellVariables.sceneWidth * 0.5, SShellVariables.sceneHeight * 0.5);
					volume = (radius - distance) / radius;
				}
				else
				{
					volume = vol;
				}
				var distanceX : int = soundX - hearerX;
				var pan : Number = distanceX / (SShellVariables.sceneWidth * 0.5);
				volume = volume * _effectSoundController.defaultVolume;
				_effectSoundController.playSound(soundId, loops, volume, pan);
			}
			else
			{
				_effectSoundController.playSound(soundId, loops);
			}
		}

		public function resumeBackgroundSound() : void
		{
			if (_backgroundSoundController)
				_backgroundSoundController.resumeAll(1000);
		}

		public function pauseBackgroundSound() : void
		{
			if (_backgroundSoundController)
				_backgroundSoundController.pauseAll(1000);
		}

		public function stopEffectSound(soundId : String) : void
		{
			if (_effectSoundController)
				_effectSoundController.stop(soundId);
		}

		public function stopEffectSounds() : void
		{
			if (_effectSoundController)
				_effectSoundController.stopAll(0);
		}

		public function effectSoundIsPlaying(name : String) : Boolean
		{
			if (_effectSoundController)
				return _effectSoundController.isPlaying(name);
			return false;
		}
	}
}