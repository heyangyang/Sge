package com.sunny.game.engine.sound
{
	import com.sunny.game.engine.core.SInjector;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.parser.SSoundResourceParser;
	import com.sunny.game.engine.transition.tween.props.SSoundTransformProps;
	import com.sunny.game.engine.transition.tween.props.SSoundTweenProps;
	import com.sunny.game.engine.utils.SDictionary;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 *
	 * <p>
	 * SunnyGame的一个声音控制器
	 * 可以同时播放多个的声音，有计数器来控制音量大小
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
	public class SSoundController //extends EventDispatcher
	{
		private var _activeSound : SDictionary;
		private var _activeSoundMap : Array;
		/**
		 * 默认声音大小
		 */
		public var defaultVolume : Number = 1.0;

		private var _isPaused : Boolean;

		private var _loadCompleteFun : Function;
		private var _loadIOErrorFun : Function;

		private var _soundIds : Array;
		private var _currSoundId : String;

		public function SSoundController()
		{
			super();
			_isPaused = false;
			_activeSound = new SDictionary();
			_activeSoundMap = [];
		}

		/**
		 * 设置声音的大小
		 *
		 * @param name	名称
		 * @param volume	声音
		 * @param len	变化需要的时间
		 */
		public function setVolume(name : String, volume : Number, len : Number = 0) : void
		{
			if (_isPaused)
				return;
			var sc : SoundChannel = getActiveChannel(name);
			if (sc)
			{
				if (len == 0)
					sc.soundTransform = new SoundTransform(volume);
				else
				{
					var STween : Object = SInjector.hasMapping("STween") ? SInjector.getInstance("STween") : null;
					if (STween)
					{
						STween.clear(sc);
						var tweenProps : SSoundTweenProps = new SSoundTweenProps();
						tweenProps.soundTransform = new SSoundTransformProps();
						tweenProps.soundTransform.volume = volume;
						STween.to(sc, len, tweenProps);
					}
					else
					{
						sc.soundTransform = new SoundTransform(volume);
					}
				}
			}
		}

		/**
		 * 设置声音位置
		 *
		 * @param name	名称
		 * @param pan	声音位置，范围由-1到1
		 * @param len	过渡时间
		 */
		public function setPan(name : String, pan : Number, len : Number) : void
		{
			if (_isPaused)
				return;
			var sc : SoundChannel = getActiveChannel(name);
			if (sc)
			{
				if (len == 0)
					sc.soundTransform = new SoundTransform(sc.soundTransform.volume, pan);
				else
				{
					var STween : Object = SInjector.hasMapping("STween") ? SInjector.getInstance("STween") : null;
					if (STween)
					{
						STween.clear(sc);
						var tweenProps : SSoundTweenProps = new SSoundTweenProps();
						tweenProps.soundTransform = new SSoundTransformProps();
						tweenProps.soundTransform.pan = pan;
						STween.to(sc, len, tweenProps);
					}
					else
					{
						sc.soundTransform = new SoundTransform(sc.soundTransform.volume, pan);
					}
				}
			}
		}

		/**
		 * 设置全部声音的大小
		 *
		 * @param volume	声音
		 * @param len	变化需要的时间
		 *
		 */
		public function setAllVolume(volume : Number, len : Number = 0) : void
		{
			for (var name : String in _activeSound.dic)
			{
				setVolume(name, volume, len)
			}
		}

		/**
		 * 停止播放
		 *
		 * @param name	名称
		 * @param len	渐隐需要的时间
		 */
		public function stop(name : String, len : Number = 0) : void
		{
			if (!name)
				return;
			var data : SoundData = _activeSound.getValue(name);
			if (data)
			{
				var sc : SoundChannel = data.channel;
				if (sc)
				{
					if (len == 0)
					{
						removeActiveSound(name);
					}
					else
					{
						var STween : Object = SInjector.hasMapping("STween") ? SInjector.getInstance("STween") : null;
						if (STween)
						{
							STween.clear(sc);
							var tweenProps : SSoundTweenProps = new SSoundTweenProps();
							tweenProps.soundTransform = new SSoundTransformProps();
							tweenProps.soundTransform.volume = 0.0;
							tweenProps.onComplete = function() : void
							{
								removeActiveSound(name);
							};
							STween.to(sc, len, tweenProps);
						}
						else
						{
							removeActiveSound(name);
						}
					}
				}
				else
				{
					removeActiveSound(name);
				}
			}
		}

		/**
		 * 释放该对象  ，关闭当前正在加载的数据流并停止播放；
		 * 注： 在下次重新播放该文件时将会重新加载数据流
		 */
		public function stopAll(len : Number = 0) : void
		{
			_soundIds = null;
			_currSoundId = null;

			for (var name : String in _activeSound.dic)
			{
				stop(name, len);
			}
		}

		private function getActiveChannel(name : String) : SoundChannel
		{
			var data : SoundData = _activeSound.getValue(name);
			return data ? data.channel : null;
		}

		/**
		 * 播放
		 *
		 * @param name	名称
		 * @param loop	循环次数，-1为无限循环
		 * @param volume	声音
		 * @param len	渐显需要的时间
		 */
		private function play(name : String, loop : int = 1, volume : Number = -1, pan : Number = 0, len : Number = 0) : int
		{
			if (!name)
				return 0;
			if (isPlaying(name))
				stop(name);

			var soundID : String = name;
			soundID = soundID.split(".")[0];
			var soundResourceParser : SSoundResourceParser = SReferenceManager.getInstance().createSoundReference(soundID);
			if (!soundResourceParser.isLoaded)
			{
				addActiveSound(name, soundResourceParser.id, soundID, null, loop, volume, pan, len);
				soundResourceParser.onComplete(onComplete).onIOError(onIOError).load();
				return 1;
			}

			var sound : Sound = soundResourceParser.getSound();
			var channelState : int = addActiveSound(name, soundResourceParser.id, soundID, sound, loop, volume, pan, len);
			if (channelState == 0)
				return 0;

			return 2;
		}

		private function onComplete(res : SSoundResourceParser) : void
		{
			for (var name : String in _activeSound.dic)
			{
				var data : SoundData = _activeSound.getValue(name);
				if (data && data.resId == res.id)
				{
					var sound : Sound = res.getSound();
					if (sound)
					{
						var timeOut : Number = sound.length;
						if (res.elapsedTimes > timeOut)
						{
							removeActiveSound(name);
						}
						else
						{
							var soundState : int = play(name, data.loop, data.volume, data.pan, data.len);
							if (soundState == 2)
							{
							}
							else
							{
								removeActiveSound(name);
							}
						}
					}
					else
					{
						removeActiveSound(name);
					}
				}
			}
		}

		private function addActiveSound(name : String, resId : String, soundId : String, sound : Sound, loop : int, volume : Number, pan : Number, len : Number, startTime : Number = 0) : int
		{
			var data : SoundData = _activeSound.getValue(name);
			if (data)
			{
				if (data.channel)
				{
					if (STween)
						STween.clear(data.channel);
					data.channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
					data.channel.stop();
					data.channel = null;
				}
				data.sound = null;
			}
			data = new SoundData(name, resId, soundId, loop, volume, pan, len);
			_activeSound.setValue(name, data);
			if (_activeSoundMap.indexOf(name) == -1)
				_activeSoundMap.push(name);

			if (!sound)
				return 1;
			data.sound = sound;

			if (_isPaused)
				data.isPaused = _isPaused;
			if (data.isPaused)
				return 2;

			var channel : SoundChannel = addSoundChannel(sound, null, startTime, loop);
			if (!channel)
				return 0;
			data.channel = channel;

			var STween : Object = SInjector.hasMapping("STween") ? SInjector.getInstance("STween") : null;
			if (len == 0)
			{
				channel.soundTransform = new SoundTransform((volume != -1) ? volume : defaultVolume, pan);
			}
			else
			{
				channel.soundTransform = new SoundTransform(0, pan);

				if (STween)
				{
					STween.clear(channel);
					var tweenProps : SSoundTweenProps = new SSoundTweenProps();
					tweenProps.soundTransform = new SSoundTransformProps();
					tweenProps.soundTransform.volume = ((volume != -1) ? volume : defaultVolume);
					STween.to(channel, len, tweenProps);
				}
				else
				{
					channel.soundTransform = new SoundTransform((volume != -1) ? volume : defaultVolume, pan);
				}
			}


			return 3;
		}

		private function soundCompleteListener(evt : Event) : void
		{
			for (var name : String in _activeSound.dic)
			{
				var data : SoundData = _activeSound.getValue(name);
				if (data && data.channel == evt.currentTarget)
				{
					removeActiveSound(name);
				}
			}

			if (_soundIds && _soundIds.length > 0)
			{
				playNextSound();
			}
		}

		private function addSoundChannel(sound : Sound, transform : SoundTransform = null, startTime : Number = 0, loop : int = 1) : SoundChannel
		{
			var soundChannel : SoundChannel = sound.play(startTime, loop != -1 ? loop : int.MAX_VALUE, transform);
			if (soundChannel)
			{
				soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteListener, false, 0, true);
			}
			else
			{
				if (SDebug.OPEN_WARNING_TRACE)
					SDebug.warningPrint(this, "无法播放该声音文件，原因：没有声卡或没有可用的声道!");
			}
			return soundChannel;
		}

		private function removeActiveSound(name : String) : void
		{
			var data : SoundData = _activeSound.getValue(name);
			if (data)
			{
				if (data.channel)
				{
					var STween : Object = SInjector.hasMapping("STween") ? SInjector.getInstance("STween") : null;
					if (STween)
						STween.clear(data.channel);
					data.channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
					data.channel.stop();
					data.channel = null;
				}
				data.sound = null;
				_activeSound.deleteValue(name);
				var soundResourceParser : SSoundResourceParser = SReferenceManager.getInstance().getSoundReference(data.soundId);
				if (soundResourceParser)
				{
					soundResourceParser.release()
					soundResourceParser.removeOnComplete(onComplete).removeOnIOError(onIOError);
				}

				var index : int = _activeSoundMap.indexOf(name);
				if (index != -1)
					_activeSoundMap.splice(index, 1);
			}
		}

		public function playSound(soundID : String, loops : int = 1, volume : Number = -1, pan : Number = 0, len : Number = 0) : void
		{
			if (!soundID)
				return;
			_soundIds = null;
			_currSoundId = soundID;

			if (_activeSoundMap.length > 10)
			{
				var name : String = _activeSoundMap[0];
				stop(name);
			}

			play(soundID, loops, volume, pan, len);
		}

		/**
		 * 可设置一系列音乐，并且列表循环播放
		 * @param soundIds 可以用分号隔开
		 * @param transform
		 *
		 */
		public function playSounds(soundIds : String) : void
		{
			if (soundIds)
			{
				var tmpSoundIds : Array = soundIds.split(";");
				var soundId : String = tmpSoundIds[0];
				if (_currSoundId != soundId) //如果有相同的就连续播放，不重头开始
				{
					stopAll(1000);
					_soundIds = tmpSoundIds;
					_currSoundId = null;
					playNextSound();
				}
				else
				{
					_soundIds = tmpSoundIds;
				}
			}
			else
			{
				stopAll(1000);
			}
		}

		private function playNextSound() : void
		{
			var lastSoundId : String = _currSoundId;
			_currSoundId = null;
			var currSoundId : String = null;
			if (_soundIds && _soundIds.length > 0)
			{
				var soundIndex : int = _soundIds.indexOf(lastSoundId);
				soundIndex++;
				if (soundIndex >= _soundIds.length)
					soundIndex = 0;
				currSoundId = _soundIds[soundIndex];
			}
			if (currSoundId)
			{
				_currSoundId = currSoundId;
				play(currSoundId, 1, -1, 0, 1000);
			}
		}

		/**
		 * 声音是否正在播放
		 *
		 * @param name	名称
		 *
		 */
		public function isPlaying(name : String) : Boolean
		{
			return _activeSound.getValue(name) != null;
		}

		private function onIOError(res : SSoundResourceParser) : void
		{
			if (_loadIOErrorFun != null)
				_loadIOErrorFun(this);
		}

		public function pauseAll(len : Number = 0) : void
		{
			if (_isPaused)
				return;
			_isPaused = true;
			for (var name : String in _activeSound.dic)
			{
				pause(name, len);
			}
		}

		public function pause(name : String, len : Number = 0) : void
		{
			var data : SoundData = _activeSound.getValue(name);
			if (data && !data.isPaused)
			{
				data.isPaused = true;
				var sc : SoundChannel = data.channel;
				if (sc)
				{
					var STween : Object = SInjector.hasMapping("STween") ? SInjector.getInstance("STween") : null;
					if (STween)
						STween.clear(sc);

					if (len == 0)
					{
						sc.stop();
					}
					else
					{
						if (STween)
						{
							var tweenProps : SSoundTweenProps = new SSoundTweenProps();
							tweenProps.soundTransform = new SSoundTransformProps();
							tweenProps.soundTransform.volume = 0.0;
							tweenProps.onComplete = function() : void
							{
								data.pausedPosition = sc.position;
								sc.stop();
							};
							STween.to(sc, len, tweenProps);
						}
						else
						{
							sc.stop();
						}
					}
				}
			}
		}

		public function resumeAll(len : Number = 0) : void
		{
			if (!_isPaused)
				return;
			_isPaused = false;
			for (var name : String in _activeSound.dic)
			{
				resume(name, len);
			}
		}

		public function resume(name : String, len : Number = 0) : void
		{
			var data : SoundData = _activeSound.getValue(name);
			if (data && data.isPaused)
			{
				data.isPaused = false;
				var channelState : int = addActiveSound(name, data.resId, data.soundId, data.sound, data.loop, data.volume, data.pan, len, data.pausedPosition);
				if (channelState == 0)
					removeActiveSound(name);
			}
		}
	}
}
import flash.media.Sound;
import flash.media.SoundChannel;

class SoundData
{
	public var name : String = "";
	public var resId : String = "";
	public var soundId : String = "";
	public var loop : int = 1;
	public var volume : Number = -1;
	public var pan : Number = 0;
	public var len : Number;
	public var channel : SoundChannel = null;
	public var sound : Sound = null;
	private var _isPaused : Boolean;
	private var _pausedPosition : Number;

	public function SoundData(name : String, resId : String, soundId : String, loop : int, volume : Number, pan : Number, len : Number)
	{
		this.name = name;
		this.resId = resId;
		this.soundId = soundId;
		this.loop = loop;
		this.volume = volume;
		this.pan = pan;
		this.len = len;
		_isPaused = false;
		_pausedPosition = 0;
	}

	public function get isPaused() : Boolean
	{
		return _isPaused;
	}

	public function set isPaused(value : Boolean) : void
	{
		_isPaused = value;
	}

	public function get pausedPosition() : Number
	{
		return _pausedPosition;
	}

	public function set pausedPosition(value : Number) : void
	{
		_pausedPosition = value;
	}
}