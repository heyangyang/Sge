package com.sunny.game.engine.parser
{
	import com.sunny.game.engine.loader.SLoadPriorityType;
	import com.sunny.game.engine.ns.sunny_engine;

	import flash.media.Sound;
	import flash.utils.ByteArray;
	import com.sunny.game.engine.sound.SSoundParser;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的音效资源解析器
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
	public class SSoundResourceParser extends SSunnyResourceParser
	{
		protected var _parser : SSoundParser;

		public function SSoundResourceParser(id : String, version : String)
		{
			_parser = new SSoundParser();
			super(id, version, SLoadPriorityType.SOUND);
		}

		override sunny_engine function parse(bytes : ByteArray) : void
		{
			if (!bytes)
				return;
			if (_parser)
			{
				_parser.onComplete(onCompletedHandler).onReload(onReload);
				_parser.play(bytes);
			}
		}

		private function onCompletedHandler(parser : SSoundParser) : void
		{
			parseCompleted();
		}

		private function onReload(parser : SSoundParser) : void
		{
			reload();
		}

		public function getSound() : Sound
		{
			if (isLoaded && _parser)
				return _parser.getSound();
			return null;
		}

		override protected function destroy() : void
		{
			if (_isDisposed)
				return;
			if (_parser)
				_parser.destroy();
			_parser = null;
			super.destroy();
		}
	}
}