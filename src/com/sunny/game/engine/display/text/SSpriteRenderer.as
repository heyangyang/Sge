package com.sunny.game.engine.display.text
{
	import com.sunny.game.engine.display.SSprite;
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * <p>
	 * SunnyGame的一个富文本精灵渲染器
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
	internal class SSpriteRenderer
	{
		private var _rtf : SRichTextField;
		private var _numSprites : int;
		private var _spriteContainer : SSprite;
		private var _spriteIndices : Dictionary;

		public function SSpriteRenderer(rtf : SRichTextField)
		{
			_rtf = rtf;
			_numSprites = 0;
			_spriteContainer = new SSprite();
			_spriteIndices = new Dictionary();
		}

		internal function render() : void
		{
			if (_numSprites > 0)
			{
				doRender();
					//_spriteContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		/**
		 * prevent executing rendering code more than one time during a frame
		 * @param	e ENTER_FRAME evnet
		 */
		private function onEnterFrame(e : Event) : void
		{
			_spriteContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			doRender();
		}

		/**
		 * the real rendering function
		 */
		private function doRender() : void
		{
			//_spriteContainer.y = -_rtf.scrollHeight; //这个减去滚动的去掉了，发现这个container是放到scroller里面的，加上这句话会错位-xx1232015年5月18日 17:50:07
			renderVisibleSprites();
		}

		private function renderVisibleSprites() : void
		{
			//all visible sprites are between lines scrollV and bottomScrollV
			var startLine : int = _rtf.scrollV - 1;
			var endLine : int = _rtf.bottomScrollV - 1;
			var startIndex : int = _rtf.getLineOffset(startLine);
			var endIndex : int = _rtf.getLineOffset(endLine) + _rtf.getLineLength(endLine) - 1;

			//clear all rendered sprites
			while (_spriteContainer.numChildren > 0)
				_spriteContainer.removeChildAt(0);

			//render sprites which between sdtartIndex and endIndex
			while (startIndex <= endIndex)
			{
				if (_rtf.isSpriteAt(startIndex))
				{
					var sprite : DisplayObject = getSprite(startIndex);
					if (sprite != null)
						renderSprite(sprite, startIndex);
				}
				startIndex++;
			}
		}

		private function renderSprite(sprite : DisplayObject, index : int) : void
		{
			var rect : Rectangle = _rtf.getCharBoundaries(index);
			if (rect != null)
			{
				sprite.x = (rect.x + (rect.width - sprite.width) * 0.5 + 0.5 - _rtf.scrollH) >> 0;
				var y : Number = (rect.height - sprite.height) * 0.5;
				var lineMetrics : TextLineMetrics = _rtf.getLineMetrics(_rtf.getLineIndexOfChar(index));
				//make sure the sprite's y is not smaller than the ascent of line metrics
				if (y + sprite.height < lineMetrics.ascent)
					y = lineMetrics.ascent - sprite.height;
				sprite.y = (rect.y + y + 0.5) >> 0;
				_spriteContainer.addChild(sprite);
			}
		}

		private function deleteSprite(sprite : DisplayObject) : void
		{
			if (sprite.parent)
				sprite.parent.removeChild(sprite);
			_spriteIndices[sprite] = null;
			delete _spriteIndices[sprite];
			if (sprite is SIDestroy)
				(sprite as SIDestroy).destroy();
		}

		internal function adjustSpritesIndex(changeIndex : int, changeLength : int) : Boolean
		{
			var adjusted : Boolean = false;
			for each (var s : Object in _spriteIndices)
			{
				var index : int = int(s.index);
				if (index > changeIndex - changeLength)
				{
					s.index = index + changeLength;
					adjusted = true;
				}
			}
			return adjusted;
		}

		internal function insertSprite(sprite : DisplayObject, params : Array, index : int, shortcut : String) : void
		{
			if (_spriteIndices[sprite] == null)
			{
				_spriteIndices[sprite] = {index: index, sprite: sprite, params: params && params.length > 0 ? params.join(",") : "", shortcut: shortcut};
				_numSprites++;
			}
		}

		internal function removeSprite(index : int) : void
		{
			var sprite : DisplayObject = getSprite(index);
			if (sprite)
			{
				deleteSprite(sprite);
				_numSprites--;
			}
		}

		internal function getShortcut(index : int) : String
		{
			for each (var s : Object in _spriteIndices)
			{
				if (index == int(s.index))
					return s.shortcut as String;
			}
			return null;
		}

		internal function getSprite(index : int) : DisplayObject
		{
			for each (var s : Object in _spriteIndices)
			{
				if (index == int(s.index))
					return s.sprite as DisplayObject;
			}
			return null;
		}

		internal function getSpriteIndex(sprite : DisplayObject) : int
		{
			if (_spriteIndices[sprite])
				return int(_spriteIndices[sprite].index);
			return -1;
		}

		internal function clear() : void
		{
			for (var sprite : * in _spriteIndices)
			{
				deleteSprite(sprite as DisplayObject);
			}
			_numSprites = 0;
		}

		internal function get container() : SSprite
		{
			return _spriteContainer;
		}

		internal function get numSprites() : int
		{
			return _numSprites;
		}

		internal function exportXML() : XML
		{
			var info : Object;
			var arr : Array = [];
			for each (var s : Object in _spriteIndices)
			{
				info = {src: getQualifiedClassName(s.sprite), params: s.params, index: s.index};
				arr.push(info);
			}
			if (arr.length > 1)
				arr.sortOn("index", Array.NUMERIC);

			var xml : XML = <sprites/>;
			for (var i : int = 0; i < arr.length; i++)
			{
				info = arr[i];
				var node : XML = <sprite src={info.src} params={info.params} index={info.index - i} />;
				xml.appendChild(node);
			}
			return xml;
		}

		internal function importXML(data : XML) : Array
		{
			var sprites : Array = [];
			for (var i : int = 0; i < data.sprite.length(); i++)
			{
				var node : XML = data.sprite[i];
				var sprite : STextElement = new STextElement();
				sprite.source = String(node.@src);
				var params : String = String(node.@params);
				sprite.params = params ? params.split(",") : null;
				var index : int = int(node.@index);
				//correct the index if import as html
				if (_rtf.isHtml && _rtf.contentLength > 0 && index > 0)
					sprite.index = index + 1;
				else
					sprite.index = index;
				sprites.push(sprite);
			}
			return sprites;
		}

		internal function get spriteIndices() : Dictionary
		{
			return _spriteIndices;
		}
	}
}