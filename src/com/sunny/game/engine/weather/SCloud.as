package com.sunny.game.engine.weather
{
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.parser.SPakResourceParser;
	import com.sunny.game.engine.parser.SSunnyResourceParser;
	import com.sunny.game.engine.particle.SParticle;

	import flash.display.DisplayObjectContainer;

	internal class SCloud extends SParticle
	{
		protected var _resourceParser : SPakResourceParser;
		private var _onCompleteFun : Function;
		public var frame : int = 1;

		public function SCloud(parent : DisplayObjectContainer, onCompleteFun : Function = null)
		{
			_onCompleteFun = onCompleteFun;
			super(parent);
			_resourceParser = SReferenceManager.getInstance().createParticleParser("cloud");
			if (_resourceParser.isLoaded)
			{
				onComplete(_resourceParser);
			}
			else
			{
				_resourceParser.onComplete(onComplete).onIOError(onIOError).load();
			}
		}

		protected function onComplete(res : SPakResourceParser) : void
		{
			this.bitmapData = _resourceParser.getBitmapDataByFrame(frame);
			if (_onCompleteFun != null)
				_onCompleteFun();
		}

		protected function onIOError(res : SSunnyResourceParser) : void
		{
		}

		override public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (parent)
				parent.removeChild(this);
			if (_resourceParser)
			{
				_resourceParser.removeOnComplete(onComplete).removeOnIOError(onIOError);
				_resourceParser.release();
				_resourceParser = null;
			}
			_onCompleteFun = null;
			super.destroy();
		}

		public function get isLoaded() : Boolean
		{
			return _resourceParser && _resourceParser.isLoaded;
		}
	}
}