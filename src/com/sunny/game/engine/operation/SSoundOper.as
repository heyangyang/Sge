package com.sunny.game.engine.operation
{
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.manager.SSoundManager;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	[Event(name="complete", type="flash.events.Event")]

	/**
	 *
	 * <p>
	 * SunnyGame的一个播放声音的操作
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
	public class SSoundOper extends SOperation
	{
		public static var urlBase : String = "";
		public static var enabledSound : Boolean = true;

		/**
		 * 数据源
		 */
		public var source : *;

		/**
		 * 播放的声音
		 */
		public var channel : SoundChannel;

		/**
		 * 声音开始时间
		 */
		public var startTime : int;

		/**
		 * 循环次数，-1位无限循环
		 */
		public var loops : int;

		/**
		 * 是否在全部下载完毕后才播放
		 */
		public var playWhenComplete : Boolean;

		/**
		 * 声音缓动队列
		 */
		public var tweenQueue : SOperQueue;

		private var _soundTransform : SoundTransform;

		/**
		 * 声音滤镜对象
		 * @param v
		 *
		 */
		public function set soundTransform(v : SoundTransform) : void
		{
			if (channel)
				channel.soundTransform = v;
			else
				_soundTransform = v;
		}

		public function get soundTransform() : SoundTransform
		{
			if (channel)
				return channel.soundTransform;
			else
				return _soundTransform;
		}

		public function SSoundOper(source : * = null, playWhenComplete : Boolean = true, startTime : int = 0, loops : int = 1, volume : Number = 1.0, panning : Number = 0.5)
		{
			this.source = source;
			this.playWhenComplete = playWhenComplete;
			this.startTime = startTime;
			this.loops = loops;
			this.soundTransform = new SoundTransform(volume, panning);
		}

		/**
		 * 增加一个声音缓动
		 *
		 * @param delay	起始时间
		 * @param duration	持续时间
		 * @param volume	音量
		 * @param pan	声道均衡
		 * @param ease	缓动函数
		 *
		 */
		public function addTween(duration : int = 1000, volume : Number = NaN, pan : Number = NaN, ease : Function = null) : void
		{
			if (!tweenQueue)
				tweenQueue = new SOperQueue();

			var o : Object = new Object();
			if (!isNaN(volume))
				o.volume = volume;
			if (!isNaN(pan))
				o.pan = pan;
			if (ease != null)
				o.ease = ease;

			tweenQueue.children.push(new STweenOper(this, duration, o));
		}

		/** @inheritDoc*/
		public override function execute() : void
		{
			if (!enabledSound)
			{
				result();
				return;
			}

			super.execute();
			if (source is String)
			{
				SSoundManager.getInstance().playEffectSound(source as String);
			}

			if (source is Class)
				source = new source();

			if (source is Sound)
				playSound(source as Sound);
		}

		private function loadSoundComplete(event : Event) : void
		{
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, fault);
			event.currentTarget.removeEventListener(Event.COMPLETE, loadSoundComplete);

			dispatchEvent(new SEvent(SEvent.COMPLETE));

			if (playWhenComplete)
				playSound(source as Sound);
		}

		/**
		 * 播放声音
		 *
		 * @param s
		 * @return
		 *
		 */
		protected function playSound(s : Sound) : SoundChannel
		{
			channel = s.play(startTime, (loops >= 0) ? loops : int.MAX_VALUE, soundTransform);
			if (channel)
			{
				channel.addEventListener(Event.SOUND_COMPLETE, result);

				if (tweenQueue)
					tweenQueue.execute();
			}
			else
			{
				result(); //无声卡直接播放完成
			}
			return channel;
		}

		/** @inheritDoc*/
		public override function result(event : * = null) : void
		{
			if (channel)
				channel.removeEventListener(Event.SOUND_COMPLETE, result);

			super.result(event);
		}

		/** @inheritDoc*/
		public override function fault(event : * = null) : void
		{
			if (event)
			{
				event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, fault);
				event.currentTarget.removeEventListener(Event.COMPLETE, loadSoundComplete);
			}

			if (channel)
				channel.removeEventListener(Event.SOUND_COMPLETE, result);

			super.result(event);
		}
	}
}