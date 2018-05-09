package com.sunny.game.engine.display.text
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.display.SSprite;
	import com.sunny.game.engine.enum.STextType;
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	import com.sunny.game.engine.ns.sunny_plugin;
	import com.sunny.game.engine.plugin.SIPlugin;
	import com.sunny.game.engine.utils.core.SClassFactory;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.getDefinitionByName;

	/**
	 *
	 * <p>
	 * SunnyGame的一个富文本字段
	 * <p>RichTextField是一个基于TextField的图文混编的组件。</p>
	 * <p>众所周知，TextField可以用html的方式来插入图片，但无法有效控制图片的位置且不能实时编辑。RichTextField可以满足这方面的需求。</p>
	 * <p>RichTextField有如下特性：
	 * <br><ul>
	 * <li>在文本末尾追加文本和显示元素。</li>
	 * <li>在文本任何位置替换(删除)文本和显示元素。</li>
	 * <li>支持HTML文本和显示元素的混排。</li>
	 * <li>可动态设置RichTextField的尺寸大小。</li>
	 * <li>可导入和导出XML格式的文本框内容。</li>
	 * </ul></p>
	 *
	 *
	 * @example 下面的例子演示了RichTextField基本使用方法：
	 * <listing>
		var rtf:RichTextField = new RichTextField();
		rtf.x = 10;
		rtf.y = 10;
		addChild(rtf);

		//设置rtf的尺寸大小
		rtf.setSize(500, 400);
		//设置rtf的类型
		rtf.type = RichTextField.INPUT;
		//设置rtf的默认文本格式
		rtf.defaultTextFormat = new TextFormat("Arial", 12, 0x000000);

		//追加文本和显示元素到rtf中
		rtf.append("Hello, World!", [ { index:5, src:SpriteClassA }, { index:13, src:SpriteClassB } ]);
		//替换指定位置的内容为新的文本和显示元素
		rtf.replace(8, 13, "世界", [ { src:SpriteClassC } ]);</listing>
	 *
	 *
	 * @example 下面是一个RichTextField的内容的XML例子，你可以使用importXML()来导入具有这样格式的XML内容，或用exportXML()导出这样的XML内容方便保存和传输：
	 * <listing>
		&lt;rtf&gt;
		  &lt;text&gt;Hello, World!&lt;/text&gt;
		  &lt;sprites&gt;
				&lt;sprite src="SpriteClassA" index="5"/&gt;
				&lt;sprite src="SpriteClassB" index="13"/&gt;
		  &lt;/sprites&gt;
		&lt;/rtf&gt;</listing>
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
	public class SRichTextField extends SSprite
	{
		private var _width : Number;
		private var _height : Number;
		private var _textRenderer : STextRenderer;
		private var _spriteRenderer : SSpriteRenderer;
		private var _formatCalculator : TextField;
		private var _plugins : Array;

		private var _placeholder : String;
		private var _placeholderColor : uint;
		private var _placeholderMarginH : int;
		private var _placeholderMarginV : int;

		/**
		 * 一个布尔值，指示文本字段是否以HTML形式插入文本。
		 * @default false
		 */
		public var isHtml : Boolean;
		/**
		 * 指示文本字段的显示元素的行高（最大高度）。
		 * @default 0
		 */
		public var lineHeight : int;

		/**
		 * 构造函数。
		 */
		public function SRichTextField()
		{
			super();
			mouseChildren = true;

			//text renderer
			_textRenderer = new STextRenderer();
			addChild(_textRenderer);

			//sprite renderer
			_spriteRenderer = new SSpriteRenderer(this);
			addChild(_spriteRenderer.container);

			//default settings
			setSize(100, 100);
			type = STextType.DYNAMIC;
			lineHeight = 0;
			isHtml = false;

			//default placeholder
			_placeholder = String.fromCharCode(12288); //一个空格
			_placeholderColor = 0x000000;
			_placeholderMarginH = 1;
			_placeholderMarginV = 0;

			//an invisible textfield for calculating placeholder's textFormat
			_formatCalculator = new TextField();
			_formatCalculator.htmlText = _placeholder;

			//make sure that can't input placeholder
			_textRenderer.restrict = "^" + _placeholder;
		}

		/**
		 * 追加newText参数指定的文本和newSprites参数指定的显示元素到文本字段的末尾。
		 * @param	newText 要追加的新文本。
		 * @param	newSprites 要追加的显示元素数组，每个元素包含src和index两个属性，如：{src:sprite, index:1}。
		 * @param	autoWordWrap 指示是否自动换行。
		 * @param	format 应用于追加的新文本的格式。
		 */
		public function append(text : String, sprites : Array = null, autoWordWrap : Boolean = false, format : TextFormat = null) : void
		{
			var oldLength : int = _textRenderer.length;
			var textLength : int = 0;

			if (!text || text == "")
				return;
//				text = "";
			if (text || autoWordWrap)
			{
				if (text)
					text = text.split("\r").join("\n");
				if (autoWordWrap && !isHtml)
					text += "\n";
				_textRenderer.recoverDefaultFormat();
				if (isHtml)
				{
					_textRenderer.htmlText += "<p>" + text + "</p>";
				}
				else
				{
					_textRenderer.appendText(text);
					if (format == null)
						format = _textRenderer.defaultTextFormat;
					_textRenderer.setTextFormat(format, oldLength, _textRenderer.length);
				}
				if (isHtml || (autoWordWrap && !isHtml))
					textLength = _textRenderer.length - oldLength - 1;
				else
					textLength = _textRenderer.length - oldLength;
			}

			var newline : Boolean = isHtml && (oldLength != 0);
			insertSprites(sprites, oldLength, oldLength + textLength, newline);

			if (sprites != null)
				_spriteRenderer.render();

			dispatchEvent(new Event(Event.CHANGE));
		}

		sunny_plugin function replace(startIndex : int, endIndex : int, newText : String, newSprites : Array = null) : void
		{
			//replace text			
			var oldLength : int = _textRenderer.length;
			var textLength : int = 0;
			if (endIndex > oldLength)
				endIndex = oldLength;
			newText = newText.split(_placeholder).join("");
			_textRenderer.replaceText(startIndex, endIndex, newText);
			textLength = _textRenderer.length - oldLength + (endIndex - startIndex);

			if (textLength > 0)
			{
				_textRenderer.setTextFormat(_textRenderer.defaultTextFormat, startIndex, startIndex + textLength);
			}

			//remove sprites which be replaced
			for (var i : int = startIndex; i < endIndex; i++)
			{
				_spriteRenderer.removeSprite(i);
			}

			//adjust sprites after startIndex
			var adjusted : Boolean = _spriteRenderer.adjustSpritesIndex(startIndex - 1, _textRenderer.length - oldLength);

			//insert sprites
			insertSprites(newSprites, startIndex, startIndex + textLength);

			//if adjusted or have sprites inserted, do render
			if (adjusted || (newSprites && newSprites.length > 0))
				_spriteRenderer.render();
		}

		/**
		 * 使用newText和newSprites参数的内容替换startIndex和endIndex参数指定的位置之间的内容。
		 * @param	startIndex 要替换的起始位置。
		 * @param	endIndex 要替换的末位位置。
		 * @param	newText 要替换的新文本。
		 * @param	newSprites 要替换的显示元素数组，每个元素包含src和index两个属性，如：{src:sprite, index:1}。
		 */
		public function replace(startIndex : int, endIndex : int, newText : String, newSprites : Array = null) : void
		{
			sunny_plugin::replace(startIndex, endIndex, newText, newSprites);
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * 从参数startIndex指定的索引位置开始，插入若干个由参数newSprites指定的显示元素。
		 * @param	newSprites 要插入的显示元素数组，每个元素包含src和index两个属性，如：{src:sprite, index:1}。
		 * @param	startIndex 要插入显示元素的起始位置。
		 * @param	maxIndex 要插入显示元素的最大索引位置。
		 * @param	newline 指示是否为文本的新行。
		 */
		private function insertSprites(sprites : Array, startIndex : int, endIndex : int, newline : Boolean = false) : void
		{
			if (sprites == null)
				return;
			sprites.sortOn("index", Array.NUMERIC);

			for (var i : int = 0; i < sprites.length; i++)
			{
				var element : STextElement = sprites[i];
				var index : int = element.index;
				if (index < 0 || index > endIndex - startIndex)
				{
					element.index = endIndex - startIndex;
					sprites.splice(i, 1);
					sprites.push(element);
					i--;
					continue;
				}

				if (newline && index > 0 && index < endIndex - startIndex)
					index += startIndex + i - 1;
				else
					index += startIndex + i;
				element.index = index;
				insertSprite(element, false);
			}
		}
		/**
		 * 这个组件的高度老是返回的上一次的高度，然后发现用这个变量反而是正确的，所以
		 * @xx123  2015年7月8日 16:04:43
		 * */
		override public function get height():Number
		{
			return _height;
		}

		/**
		 * 在参数index指定的索引位置（从零开始）插入由newSprite参数指定的显示元素。
		 * @param	newSprite 要插入的显示元素。其格式包含src和index两个属性，如：{src:sprite, index:1}。
		 * @param	index 要插入的显示元素的索引位置。
		 * @param	autoRender 指示是否自动渲染插入的显示元素。
		 * @param	cache 指示是否对显示元素使用缓存。
		 */
		public function insertSprite(element : STextElement, autoRender : Boolean = true) : void
		{
			//create a instance of sprite
			var spriteObj : DisplayObject = getSpriteFromObject(element.source, element.params);
			if (spriteObj == null)
				throw SunnyGameEngineError("指定的精灵：" + element.source + "不是有效的显示对象！");

			//if (element.cache)
			//	spriteObj.cacheAsBitmap = true;
			//resize spriteObj if lineHeight is specified
			if (lineHeight > 0 && spriteObj.height > lineHeight)
			{
				var scaleRate : Number = lineHeight / spriteObj.height;
				spriteObj.height = lineHeight;
				spriteObj.width = spriteObj.width * scaleRate;
			}

			var index : int = element.index;
			//verify the index to insert
			if (index < 0 || index > _textRenderer.length)
				index = _textRenderer.length;
			//insert a placeholder into textfield by using replaceText method
			_textRenderer.replaceText(index, index, _placeholder);
			//calculate a special textFormat for spriteObj's placeholder
			var format : TextFormat = calcPlaceholderFormat(spriteObj.width, spriteObj.height);
			//apply the textFormat to placeholder to make it as same size as the spriteObj
			_textRenderer.setTextFormat(format, index, index + 1);

			//adjust sprites index which come after this sprite
			_spriteRenderer.adjustSpritesIndex(index, 1);
			//insert spriteObj to specific index and render it if it's visible
			_spriteRenderer.insertSprite(spriteObj, element.params, index, element.sunny_plugin::shortcut);

			//if autoRender, just do it
			if (autoRender)
				_spriteRenderer.render();

			dispatchEvent(new Event(Event.CHANGE));
		}

		private function getSpriteFromObject(source : Object, params : Array) : DisplayObject
		{
			if (source is String)
			{
				var clazz : Class = getDefinitionByName(String(source)) as Class;
				return SClassFactory.apply(clazz, params) as DisplayObject;
			}
			else if (source is Class)
			{
				return SClassFactory.apply(source as Class, params) as DisplayObject;
			}
			else
			{
				return source as DisplayObject;
			}
		}

		/**
		 * 计算显示元素的占位符的文本格式（若使用不同的占位符，可重写此方法）。
		 * @param	width 宽度。
		 * @param	height 高度。
		 * @return
		 */
		private function calcPlaceholderFormat(width : Number, height : Number) : TextFormat
		{
			var format : TextFormat = new TextFormat();
			format.color = _placeholderColor;
			format.size = height + 2 * _placeholderMarginV;

			//calculate placeholder text metrics with certain size to get actual letterSpacing
			_formatCalculator.setTextFormat(format);
			var metrics : TextLineMetrics = _formatCalculator.getLineMetrics(0);

			//letterSpacing is the key value for placeholder
			format.letterSpacing = width - metrics.width + 1 * _placeholderMarginH;
			format.underline = format.italic = format.bold = false;
			return format;
		}

		/**
		 * 设置RichTextField的尺寸大小（长和宽）。
		 * @param	width 宽度。
		 * @param	height 高度。
		 */
		public function setSize(width : Number, height : Number) : void
		{
			if (_width == width && _height == height)
				return;
			_width = width;
			_height = height;
			_textRenderer.width = _width;
			_textRenderer.height = _height;
			this.scrollRect = new Rectangle(0, 0, _width, _height);
			_spriteRenderer.render();
		}

		/**
		 * 指示index参数指定的索引位置上是否为显示元素。
		 * @param	index 指定的索引位置。
		 * @return
		 */
		public function isSpriteAt(index : int) : Boolean
		{
			if (index < 0 || index >= _textRenderer.length)
				return false;
			return _textRenderer.text.charAt(index) == _placeholder;
		}

		private function scrollHandler(e : Event) : void
		{
			_spriteRenderer.render();
		}

		private function changeHandler(e : Event) : void
		{
			var index : int = _textRenderer.caretIndex;
			var offset : int = _textRenderer.length - _textRenderer.oldLength;
			if (offset > 0)
			{
				_spriteRenderer.adjustSpritesIndex(index - 1, offset);
			}
			else
			{
				//remove sprites
				for (var i : int = index; i < index - offset; i++)
				{
					_spriteRenderer.removeSprite(i);
				}
				_spriteRenderer.adjustSpritesIndex(index + offset, offset);
			}
			_spriteRenderer.render();
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * 清除所有文本和显示元素。
		 */
		public function clearRender() : void
		{
			_spriteRenderer.clear();
			_textRenderer.clear();
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * 指示RichTextField的类型。
		 * @default RichTextField.DYNAMIC
		 */
		public function get type() : String
		{
			return _textRenderer.type;
		}

		public function set type(value : String) : void
		{
			_textRenderer.type = value;
			_textRenderer.addEventListener(Event.SCROLL, scrollHandler);
			if (value == STextType.INPUT)
			{
				_textRenderer.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		public function set selectable(value : Boolean) : void
		{
			_textRenderer.selectable = value;
		}

		public function get scrollHeight() : Number
		{
			return _textRenderer.scrollHeight;
		}

		public function get scrollV() : int
		{
			return _textRenderer.scrollV;
		}

		public function get scrollH() : int
		{
			return _textRenderer.scrollH;
		}

		public function get bottomScrollV() : int
		{
			return _textRenderer.bottomScrollV;
		}

		public function get oldLength() : int
		{
			return _textRenderer.oldLength;
		}

		public function get renderWidth() : Number
		{
			return _textRenderer.textWidth;
		}

		public function get renderHeight() : Number
		{
			return _textRenderer.textHeight;
		}

		public function getLineOffset(lineIndex : int) : int
		{
			return _textRenderer.getLineOffset(lineIndex);
		}

		public function getLineLength(lineIndex : int) : int
		{
			return _textRenderer.getLineLength(lineIndex);
		}

		public function getCharBoundaries(charIndex : int) : Rectangle
		{
			return _textRenderer.getCharBoundaries(charIndex);
		}

		public function getLineMetrics(lineIndex : int) : TextLineMetrics
		{
			return _textRenderer.getLineMetrics(lineIndex);
		}

		public function getLineIndexOfChar(charIndex : int) : int
		{
			return _textRenderer.getLineIndexOfChar(charIndex);
		}

		/**
		 * 指示显示元素占位符的水平边距。
		 * @default 1
		 */
		public function set placeholderMarginH(value : int) : void
		{
			_placeholderMarginH = value;
		}

		/**
		 * 指示显示元素占位符的垂直边距。
		 * @default 0
		 */
		public function set placeholderMarginV(value : int) : void
		{
			_placeholderMarginV = value;
		}

		/**
		 * 返回RichTextField对象的可见宽度。
		 */
		public function get viewWidth() : Number
		{
			return _width;
		}

		/**
		 * 返回RichTextField对象的可见高度。
		 */
		public function get viewHeight() : Number
		{
			return _height;
		}

		public function get textWidth() : Number
		{
			return _textRenderer.textWidth;
		}

		public function get textHeight() : Number
		{
			return _textRenderer.textHeight;
		}

		/**
		 * 返回文本字段中的合成内容（包括显示元素的占位符）。
		 */
		public function composeContent() : String
		{
			var texts : Array = _textRenderer.text.split(_placeholder);
			var result : String = "";
			result += texts[0];
			var arr : Array = [];
			for each (var s : Object in _spriteRenderer.spriteIndices)
			{
				arr.push(s);
			}
			if (arr.length > 1)
				arr.sortOn("index", Array.NUMERIC);

			var len : int = arr.length;
			for (var i : int = 0; i < len; i++)
			{
				result += arr[i].shortcut;
				result += texts[i + 1];
			}
			return result;
		}

		/**
		 * 返回文本字段中的内容（包括显示元素的占位符）。
		 */
		public function get content() : String
		{
			return _textRenderer.text;
		}

		/**
		 * 返回文字字段中的内容长度（包括显示元素的占位符）。
		 */
		public function get contentLength() : int
		{
			return _textRenderer.length;
		}

		/**
		 * 返回文本字段中的文本（不包括显示元素的占位符）。
		 */
		public function get text() : String
		{
			return _textRenderer.text.split(_placeholder).join("");
		}

		/**
		 * 返回文字字段中的文本长度（不包括显示元素的占位符）。
		 */
		public function get textLength() : int
		{
			return _textRenderer.length - _spriteRenderer.numSprites;
		}

		/**
		 * 返回由参数index指定的索引位置的显示元素。
		 * @param	index
		 * @return
		 */
		public function getSprite(index : int) : DisplayObject
		{
			return _spriteRenderer.getSprite(index);
		}

		/**
		 * 返回RichTextField中显示元素的数量。
		 */
		public function get numSprites() : int
		{
			return _spriteRenderer.numSprites;
		}

		/**
		 * 指定鼠标指针的位置。
		 */
		public function get caretIndex() : int
		{
			return _textRenderer.caretIndex;
		}

		public function set caretIndex(index : int) : void
		{
			_textRenderer.setSelection(index, index);
		}

		public function set mouseWheelEnabled(value : Boolean) : void
		{
			_textRenderer.mouseWheelEnabled = value;
		}

		public function set wordWrap(value : Boolean) : void
		{
			_textRenderer.wordWrap = value;
		}

		public function set multiline(value : Boolean) : void
		{
			_textRenderer.multiline = value;
		}

		public function set maxChars(value : int) : void
		{
			_textRenderer.maxChars = value;
		}

		public function get maxChars() : int
		{
			return _textRenderer.maxChars;
		}

		/**
		 * 指定文本字段的默认文本格式。
		 */
		public function get defaultTextFormat() : TextFormat
		{
			return _textRenderer.defaultTextFormat;
		}

		public function set defaultTextFormat(format : TextFormat) : void
		{
			if (format.color != null)
				_placeholderColor = uint(format.color);
			_textRenderer.defaultTextFormat = format;
		}

		/**
		 * 导出XML格式的SRichTextField的文本和显示元素内容。
		 * @return
		 */
		public function exportXML() : XML
		{
			var xml : XML = <rtf/>;
			if (isHtml)
				xml.htmlText = _textRenderer.htmlText.split(_placeholder).join("");
			else
				xml.text = _textRenderer.text.split(_placeholder).join("");

			xml.sprites = _spriteRenderer.exportXML();
			return xml;
		}

		/**
		 * 导入指定XML格式的文本和显示元素内容。
		 * @param	data 具有指定格式的XML内容。
		 */
		public function importXML(data : XML) : void
		{
			if(!data)
			{
				clearRender();
				return;
			}
			var content : String = "";
			if (data.hasOwnProperty("htmlText"))
				content = data.htmlText;
			else if (data.hasOwnProperty("text"))
				content = data.text;

			var sprites : Array = _spriteRenderer.importXML(XML(data.sprites));
			append(content, sprites);
		}

		/**
		 * 为RichTextField增加插件。
		 * @param	plugin 要增加的插件。
		 */
		public function installPlugin(plugin : SIPlugin) : void
		{
			if (plugin.setup(this))
			{
				if (_plugins == null)
					_plugins = [];
				_plugins.push(plugin);
			}
		}

		public function uninstallPlugin(plugin : SIPlugin) : void
		{
			if (_plugins)
			{
				plugin.destroy();
				var index : int = _plugins.indexOf(plugin);
				if (index > -1)
					_plugins.splice(index, 1);
			}
		}

		override public function set focus(value : Boolean) : void
		{
			if (value)
				SShellVariables.focus = _textRenderer;
			else
				SShellVariables.focusStage();
		}

		override public function get focus() : Boolean
		{
			return SShellVariables.focus == _textRenderer;
		}
	}
}