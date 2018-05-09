package com.sunny.game.engine.cfg
{
	import com.sunny.game.engine.manager.SSoundManager;

	/**
	 *
	 * <p>
	 * SunnyGame的引擎配置
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
	public class SEngineConfig
	{
		/**
		 * 背景音乐静音
		 */
		private static var _backgroundSoundMuted : Boolean = false;
		/**
		 * 特效音效静音
		 */
		private static var _effectSoundMuted : Boolean = false;

		public static function set soundMuted(value : Boolean) : void
		{
			_backgroundSoundMuted = value;
			_effectSoundMuted = value;
			if (value)
				SSoundManager.getInstance().pauseAll();
			else
				SSoundManager.getInstance().resumeAll();
		}

		public static function get backgroundSoundMuted() : Boolean
		{
			return _backgroundSoundMuted;
		}

		public static function set backgroundSoundMuted(value : Boolean) : void
		{
			_backgroundSoundMuted = value;
			if (value)
				SSoundManager.getInstance().pauseBackgroundSound();
			else
				SSoundManager.getInstance().resumeBackgroundSound();
		}

		public static function get effectSoundMuted() : Boolean
		{
			return _effectSoundMuted;
		}

		public static function set effectSoundMuted(value : Boolean) : void
		{
			_effectSoundMuted = value;
			if (value)
				SSoundManager.getInstance().stopEffectSounds();
		}

		public static var showWeather : Boolean = true;
		public static var canShake : Boolean = true;

		/**
		 * 是否允许纸娃娃（调试时可以使用）
		 */
		public static var avatarEnabled : Boolean = true;
		/**
		 * 是否允许特效（调试时可以使用）
		 */
		public static var effectEnabled : Boolean = true;
		/**
		 * 是否允许地图瓦片（调试时可以使用）
		 */
		public static var mapTileEnabled : Boolean = true;
		/**
		 * 是否允许影片（调试时可以使用）
		 */
		public static var movieEnabled : Boolean = true;

		/**
		 * 最大主角渲染数，不包括自己
		 */
		private static var _maxCharacterRenderNum : uint = 100;
		/**
		 * 当前渲染人数
		 */
		public static var curCharacterRenderNum : int;

		public static function get maxCharacterRenderNum() : uint
		{
			return _maxCharacterRenderNum;
		}

		public static function set maxCharacterRenderNum(value : uint) : void
		{
			if (_maxCharacterRenderNum == value)
				return;
			_maxCharacterRenderNum = value;
		}

		/**
		 * 最大特效渲染数，不包括场景特效
		 */
		private static var _maxEffectRenderNum : uint = 20;

		public static function get maxEffectRenderNum() : uint
		{
			return _maxEffectRenderNum;
		}

		public static function set maxEffectRenderNum(value : uint) : void
		{
			if (_maxEffectRenderNum == value)
				return;
			_maxEffectRenderNum = value;
		}
	}
}