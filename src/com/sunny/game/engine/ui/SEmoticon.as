package com.sunny.game.engine.ui
{
	import com.sunny.game.engine.core.SInjector;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.display.SSprite;
	import com.sunny.game.engine.events.STickEvent;
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.parser.SPakResourceParser;
	import com.sunny.game.engine.parser.SSunnyResourceParser;
	import com.sunny.game.engine.utils.STick;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 *
	 * <p>
	 * SunnyGame的一个表情符号
	 * 文中的emoticon就是“表情符号”的意思，这是一个由emotion（情绪）和icon（图标）缩合而成的词。
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
	public class SEmoticon extends SSprite
	{
		protected var _resId : String;
		protected var _resourceParser : SPakResourceParser;
		protected var imageBitmap : Bitmap;
		private var _onCompleteFun : Function;
		private var _onReachEnd : Function;
		private var _speed : int = 6;
		private var _loop : int;
		private var _currLoop : int;
		private var _currFrame : int = 0;

		private var _currEndFrame : int = 0;
		private var _startFrame : int = 1;
		private var _endFrame : int = 0;

		private var _autoSize : Boolean;

		private var _width : int;
		private var _height : int;

		private var _frameTimes : int = 0;
		private var _frameElapsedTime : int = 0;
		private var _content : SSprite;

		public function SEmoticon(id : String, width : int, height : int, frameTimes : int = 100)
		{
			SInjector.mapClass(STick, STick, "SEmoticon");
			_width = width;
			_height = height;
			_frameTimes = frameTimes;
			super();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
			load(id);
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}

		override protected function init() : void
		{
			super.init();
			_content = new SSprite();
			addChild(_content);
			_content.mouseChildren = false;
			imageBitmap = new Bitmap();
			_content.addChild(imageBitmap);
		}

		override protected function addToStage() : void
		{
			super.addToStage();
			(SInjector.getInstance(STick, "SEmoticon") as STick).addEventListener(STickEvent.TICK, onClipAnimation);
		}

		override protected function removedFromStage() : void
		{
			super.removedFromStage();
			(SInjector.getInstance(STick, "SEmoticon") as STick).removeEventListener(STickEvent.TICK, onClipAnimation);
		}

		private function load(id : String) : void
		{
			if (_resId == id)
				return;
			clearMovie();
			_resId = id;
			_currFrame = _startFrame;
			_currEndFrame = _endFrame;
			_currLoop = 0;
			resourceParser = SReferenceManager.getInstance().createFaceParser(id);

			if (_resourceParser.isLoaded)
			{
				onComplete(_resourceParser);
			}
			else
			{
				_resourceParser.onComplete(onComplete).load();
			}
		}

		private function set resourceParser(value : SPakResourceParser) : void
		{
			if (_resourceParser)
			{
				_resourceParser.removeOnComplete(onComplete);
				_resourceParser.release();
			}
			_resourceParser = value;
		}

		protected function onComplete(res : SPakResourceParser) : void
		{
			_content.scaleX = 1;
			_content.scaleY = 1;
			_content.graphics.clear();
			_content.graphics.beginFill(0, 0);
			_content.graphics.drawRect(0, 0, res.width, res.height);
			_content.graphics.endFill();
			if (_width > 0 && _height > 0)
			{
				_content.scaleX = _width / _resourceParser.width;
				_content.scaleY = _height / _resourceParser.height;
			}

			changeBitmap();
			if (_onCompleteFun != null)
				_onCompleteFun();
		}

		private function onClipAnimation(e : STickEvent) : void
		{
			if (_resourceParser && _resourceParser.isLoaded)
			{
				_frameElapsedTime += e.interval;
				if (_frameElapsedTime >= _frameTimes)
				{
					changeBitmap();
					if (_currEndFrame == 0)
						_currEndFrame = _resourceParser.getLength();
					if (_currFrame == _currEndFrame)
					{
						_currLoop++;
						if (_loop == 0 || _currLoop < _loop)
						{
							_currFrame = _startFrame;
						}
						else
						{
							if (_onReachEnd != null)
								_onReachEnd();
							clearMovie();
							return;
						}
					}
					else
						_currFrame++;
					_frameElapsedTime = 0;
				}
			}
		}

		private function changeBitmap() : void
		{
			if (_resourceParser && _resourceParser.isLoaded)
			{
				imageBitmap.bitmapData = _resourceParser.getBitmapDataByFrame(_currFrame);
				var offset : Point = _resourceParser.getOffset(_currFrame - 1);
				imageBitmap.x = offset.x;
				imageBitmap.y = offset.y;
			}
		}

		public function clearMovie() : void
		{
			resourceParser = null;
			_resId = null;

			if (imageBitmap && imageBitmap.bitmapData)
				imageBitmap.bitmapData = null;
			_frameElapsedTime = 0;
		}

		public function onReachEnd(fun : Function) : void
		{
			_onReachEnd = fun;
		}

		override public function destroy() : void
		{
			clearMovie();
			_onCompleteFun = null;
			_onReachEnd = null;
			imageBitmap = null;
			(SInjector.getInstance(STick, "SEmoticon") as STick).removeEventListener(STickEvent.TICK, onClipAnimation);
			if (_content)
			{
				_content.destroy();
				_content = null;
			}
			super.destroy();
		}
	}
}