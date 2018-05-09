package com.sunny.game.engine.sound
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.fileformat.mp3.SMP3Decoder;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	public class SSoundParser
	{
		private var sound : Sound;
		private var decoder : SMP3Decoder;

		public function SSoundParser()
		{
			decoder = new SMP3Decoder();
		}

		public function play(bytes : ByteArray) : void
		{
			bytes.position = 0;
			decoder.addEventListener(Event.COMPLETE, onCompleteHandler);
			decoder.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			decoder.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			decoder.decode(bytes);
		}

		private var _onCompleted : Function;
		private var _onReload : Function;

		public function onComplete(func : Function) : SSoundParser
		{
			_onCompleted = func;
			return this;
		}

		private function onCompleteHandler(e : Event) : void
		{
			removeEventListener();
			if (_onCompleted != null)
				_onCompleted(this);
		}

		public function onReload(func : Function) : SSoundParser
		{
			_onReload = func;
			return this;
		}

		private function ioErrorHandler(e : IOErrorEvent) : void
		{
			removeEventListener();
			if (_onReload != null)
				_onReload(this);
		}

		private function securityErrorHandler(e : SecurityErrorEvent) : void
		{
			removeEventListener();
			if (_onReload != null)
				_onReload(this);
		}

		private function removeEventListener() : void
		{
			decoder.removeEventListener(Event.COMPLETE, onCompleteHandler);
			decoder.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			decoder.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		public function getSound() : Sound
		{
			if (!sound)
			{
				if (decoder.result)
					sound = (new decoder.result()) as Sound;
				else
				{
					if (SDebug.OPEN_ERROR_TRACE)
						SDebug.errorPrint(this, "获取音效资源异常！");
				}
			}
			return sound;
		}

		public function destroy() : void
		{
			if (decoder)
			{
				removeEventListener();
				decoder.destroy();
				decoder = null;
			}
			if (sound)
			{
				try
				{
					sound.close();
				}
				catch (e : Error)
				{
					SDebug.warningPrint(this, "流关闭错误");
				}
				sound = null;
			}
			_onCompleted = null;
			_onReload = null;
		}
	}
}