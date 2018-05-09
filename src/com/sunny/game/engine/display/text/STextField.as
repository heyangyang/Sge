package com.sunny.game.engine.display.text
{
	import com.sunny.game.engine.ns.sunny_ui;
	import com.sunny.game.engine.ui.SUIStyle;
	import com.sunny.game.engine.utils.text.STextUtil;
	import com.sunny.game.engine.utils.text.SUbb;

	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	use namespace sunny_ui;

	/**
	 *
	 * <p>
	 * SunnyGame的一个文本字段
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
	public class STextField extends STextRenderer
	{
		private var _font : String = SUIStyle.TEXT_FONT;
		private var _size : uint = SUIStyle.TEXT_SIZE;
		private var _color : uint = SUIStyle.TEXT_COLOR;
		private var _bold : Boolean = SUIStyle.TEXT_BOLD;
		private var _leading : int = SUIStyle.TEXT_LEADING;
		private var _italic : Boolean = false;
		private var _align : String = TextFormatAlign.LEFT;

		/**
		 * 最大宽度（会重置wordWrap设置）
		 */
		public var maxWidth : Number = 0;

		/**
		 * 是否强制使用HTML文本
		 */
		protected var _isHtml : Boolean = false;
		/**
		 * 是否转换UBB（只在HTML文本中有效）
		 */
		protected var _isUbb : Boolean = false;
		protected var _text : String;
		/**
		 * 限定输入内容的正则表达式
		 */
		public var regExp : RegExp;
		/**
		 * ANSI的最大输入限制字数（中文算两个字）
		 */
		public var ansiMaxChars : int = 0;
		/**
		 * 文本改变时的回调函数
		 */
		public var textChangeHandler : Function;

		public function STextField()
		{
			super();
			this.autoSize = TextFieldAutoSize.LEFT;
			this.background = false;
			this.multiline = false;
			this.wordWrap = false;
			this.selectable = false;
			this.mouseEnabled = false;
			this.mouseWheelEnabled = false;
			_text = "";
			textChangeHandler = null;
			applyTextFormat();
		}

		public function set font(value : String) : void
		{
			_font = value;
		}

		public function set size(value : uint) : void
		{
			_size = value;
		}

		public function set bold(value : Boolean) : void
		{
			_bold = value;
		}

		public function set italic(value : Boolean) : void
		{
			_italic = value;
		}

		public function set leading(value : int) : void
		{
			_leading = value;
		}

		public function set color(value : uint) : void
		{
			_color = value;
		}

		public function set align(value : String) : void
		{
			_align = value;
		}

		override public function set text(value : String) : void
		{
			applyText(value);
		}

		override public function set htmlText(value : String) : void
		{
			_isHtml = true;
			applyText(value);
		}

		private function applyText(text : String) : void
		{
			_text = text;
			if (!text)
				text = "";
			if (textChangeHandler != null)
				text = textChangeHandler(text);
			if (_isHtml)
			{
				super.text = "";
				super.htmlText = text;
			}
			else if (_isUbb)
			{
				super.text = "";
				super.htmlText = SUbb.decode(text);
			}
			else
			{
				if (RegExp(/<html>/ig).test(text) && RegExp(/<\/html>/ig).test(text))
				{
					text = text.replace("/<html>/ig", "");
					text = text.replace("/<\/html>/ig", "");
					super.text = "";
					super.htmlText = text;
				}
				else if (RegExp(/\[ubb\]/ig).test(text) && RegExp(/\[\/ubb\]/ig).test(text))
				{
					text = text.replace(/\[ubb\]/ig, "");
					text = text.replace(/\[\/ubb\]/ig, "");
					super.text = "";
					super.htmlText = SUbb.decode(text);
				}
				else
				{
					super.htmlText = "";
					super.text = text;
				}
			}

			if (maxWidth > 0 && !isNaN(maxWidth))
			{
				wordWrap = false;
				if (textWidth > maxWidth)
				{
					wordWrap = true;
					width = maxWidth;
				}
			}
		}

		public function get isHtml() : Boolean
		{
			return _isHtml;
		}

		public function set isHtml(value : Boolean) : void
		{
			if (_isHtml == value)
				return;
			_isHtml = value;
			applyText(_text);
		}

		public function get isUbb() : Boolean
		{
			return _isUbb;
		}

		public function set isUbb(value : Boolean) : void
		{
			if (_isUbb == value)
				return;
			_isUbb = value;
			applyText(_text);
		}

		public function applyTextFormat() : void
		{
			var format : TextFormat = new TextFormat(_font, _size, _color, _bold, _italic, null, null, null, _align, null, null, null, _leading);
			if (this.length > 0)
				this.setTextFormat(format, 0, this.length);
			this.defaultTextFormat = format;
			this.textColor = _color;
		}

		public function focus() : void
		{
			if (stage)
				stage.focus = this;
		}

		override public function set type(value : String) : void
		{
			super.type = value;
			if (super.type == TextFieldType.INPUT)
			{
				this.addEventListener(Event.CHANGE, onChangeHandler, false, 0, true);
				this.addEventListener(TextEvent.TEXT_INPUT, onTextInputHandler, false, 0, true);
			}
			else
			{
				this.removeEventListener(Event.CHANGE, onChangeHandler);
				this.removeEventListener(TextEvent.TEXT_INPUT, onTextInputHandler);
			}
		}

		protected function onChangeHandler(event : Event) : void
		{
			_text = super.text;
		}

		/**
		 * 输入文字事件
		 * @param event
		 *
		 */
		protected function onTextInputHandler(event : TextEvent) : void
		{
			if (regExp && !regExp.test(super.text + event.text))
				event.preventDefault();

			if (ansiMaxChars && getANSILength(super.text + event.text) > ansiMaxChars)
				event.preventDefault();

			if (textChangeHandler != null)
				super.text = textChangeHandler(super.text);
			_text = super.text;
		}

		/**
		 * 获得ANSI长度（中文按两个字符计算）
		 * @param data
		 * @return
		 *
		 */
		private function getANSILength(data : String) : int
		{
			return STextUtil.getANSILength(data);
		}

		override public function get text() : String
		{
			return _text;
		}

		override public function appendText(newText : String) : void
		{
			super.appendText(newText);
			_text = super.text;
		}
	}
}